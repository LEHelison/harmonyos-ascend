<template>
  <div class="xingshantongxin-layout">
    <!-- 左侧设备面板 -->
    <div class="device-panel">
      <div class="panel-title">设备面板</div>
      <div class="device-categories">
        <div class="category-item">
          <div class="category-title">路由设备</div>
          <div class="category-devices">
            <div class="device-item" draggable="true" @dragstart="onDeviceDragStart('router', $event)">
              <span class="device-icon router-icon">🖧</span>
              <span class="device-name">路由器</span>
            </div>
          </div>
        </div>
        <div class="category-item">
          <div class="category-title">交换设备</div>
          <div class="category-devices">
            <div class="device-item" draggable="true" @dragstart="onDeviceDragStart('switch', $event)">
              <span class="device-icon switch-icon">⇄</span>
              <span class="device-name">交换机</span>
            </div>
          </div>
        </div>
        <div class="category-item">
          <div class="category-title">网络设备</div>
          <div class="category-devices">
            <div class="device-item" draggable="true" @dragstart="onDeviceDragStart('gateway', $event)">
              <span class="device-icon gateway-icon">⋮</span>
              <span class="device-name">网关</span>
            </div>
          </div>
        </div>
        <div class="category-item">
          <div class="category-title">终端设备</div>
          <div class="category-devices">
            <div class="device-item" draggable="true" @dragstart="onDeviceDragStart('terminal', $event)">
              <span class="device-icon terminal-icon">💻</span>
              <span class="device-name">厂区</span>
            </div>
            <div class="device-item" draggable="true" @dragstart="onDeviceDragStart('light_controller', $event)">
              <span class="device-icon light-controller-icon">💡</span>
              <span class="device-name">设备灯光控制器</span>
            </div>
            <div class="device-item" draggable="true" @dragstart="onDeviceDragStart('temp_humid_sensor', $event)">
              <span class="device-icon temp-humid-icon">🌡️</span>
              <span class="device-name">温湿度传感器</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 右侧拓扑区域 -->
    <div class="topology-area">
      <div class="page-header">
        <h1>星闪通信网络拓扑</h1>
        <div class="header-actions">
          <el-button-group>
            <el-button type="primary" plain :class="{'active-tool': currentTool === 'move'}" @click="setTool('move')">
              <el-icon><Position /></el-icon> 移动设备
            </el-button>
            <el-button type="primary" plain :class="{'active-tool': currentTool === 'connect'}" @click="setTool('connect')">
              <el-icon><Connection /></el-icon> 连接设备
            </el-button>
            <el-button type="primary" plain :class="{'active-tool': currentTool === 'disconnect'}" @click="setTool('disconnect')">
              <el-icon><RemoveFilled /></el-icon> 切断连接
            </el-button>
            <el-button type="primary" plain :class="{'active-tool': currentTool === 'delete'}" @click="setTool('delete')">
              <el-icon><Delete /></el-icon> 删除设备
            </el-button>
            <el-button type="primary" plain :class="{'active-tool': currentTool === 'edit'}" @click="setTool('edit')">
              <el-icon><Edit /></el-icon> 修改设备
            </el-button>
          </el-button-group>
          <el-button type="primary" @click="refreshTopology">
            <el-icon><Refresh /></el-icon> 刷新拓扑
          </el-button>
          <el-button type="danger" @click="resetTopology">
            <el-icon><RefreshRight /></el-icon> 重置拓扑
          </el-button>
        </div>
      </div>
      
      <div class="operation-tip" v-if="currentTool === 'connect'">
        点击第一个设备，然后点击第二个设备，即可创建连接
      </div>
      <div class="operation-tip" v-else-if="currentTool === 'disconnect'">
        点击第一个设备，然后点击第二个设备，即可切断它们之间的连接
      </div>
      <div class="operation-tip" v-else-if="currentTool === 'delete'">
        点击设备即可将其删除，同时会删除与之相关的所有连接
      </div>
      <div class="operation-tip" v-else-if="currentTool === 'edit'">
        点击设备即可修改其名称和属性
      </div>
      <div class="operation-tip" v-else>
        可拖拽左侧设备到此区域，或移动已有设备
      </div>

      <el-card class="topology-card">
        <div class="topology-tools">
          <el-tooltip content="放大" placement="top">
            <el-button @click="zoomIn" circle>
              <el-icon><ZoomIn /></el-icon>
            </el-button>
          </el-tooltip>
          <el-tooltip content="缩小" placement="top">
            <el-button @click="zoomOut" circle>
              <el-icon><ZoomOut /></el-icon>
            </el-button>
          </el-tooltip>
        </div>
        
        <div class="topology-legend">
          <div class="legend-item">
            <div class="legend-icon router"></div>
            <span>路由器</span>
          </div>
          <div class="legend-item">
            <div class="legend-icon switch"></div>
            <span>交换机</span>
          </div>
          <div class="legend-item">
            <div class="legend-icon gateway"></div>
            <span>网关</span>
          </div>
          <div class="legend-item">
            <div class="legend-icon terminal"></div>
            <span>厂区</span>
          </div>
          <div class="legend-item">
            <div class="legend-icon light-controller"></div>
            <span>设备灯光控制器</span>
          </div>
          <div class="legend-item">
            <div class="legend-icon temp-humid"></div>
            <span>温湿度传感器</span>
          </div>
        </div>
        
        <!-- 拓扑图容器 -->
        <div class="topology-container" 
             ref="topologyContainer"
             @dragover.prevent
             @drop="onTopologyDrop">
          <div v-if="loading" class="loading-overlay">
            <el-icon class="loading-icon"><Loading /></el-icon>
            <span>加载中...</span>
          </div>
        </div>
      </el-card>

      <!-- 设备详情对话框 -->
      <el-dialog
        v-model="deviceDetailVisible"
        title="设备详情"
        width="40%"
      >
        <div v-if="selectedDevice" class="device-detail">
          <div class="device-header">
            <el-tag :type="selectedDevice.status === 'online' ? 'success' : 'danger'" size="large">
              <span class="device-header-icon">{{ getDeviceTypeIcon(selectedDevice.type) }}</span>
            </el-tag>
            <span class="device-header-name">{{ selectedDevice.name }}</span>
          </div>
          
          <el-descriptions title="基本信息" :column="2" border>
            <el-descriptions-item label="设备类型">{{ getDeviceTypeName(selectedDevice.type) }}</el-descriptions-item>
            <el-descriptions-item label="IP地址">{{ selectedDevice.ip }}</el-descriptions-item>
            <el-descriptions-item label="位置">{{ selectedDevice.location }}</el-descriptions-item>
            <el-descriptions-item label="最后更新">{{ selectedDevice.lastUpdated }}</el-descriptions-item>
          </el-descriptions>

          <el-divider v-if="selectedDevice.type === 'temp_humid_sensor'">实时数据</el-divider>
          <div v-if="selectedDevice && selectedDevice.type === 'temp_humid_sensor'" class="sensor-data">
            <el-descriptions title="温湿度信息" :column="1" border>
              <el-descriptions-item label="当前温度">
                <el-tag type="warning">{{ selectedDevice.temperature?.toFixed(2) }} °C</el-tag>
              </el-descriptions-item>
              <el-descriptions-item label="当前湿度">
                <el-tag type="info">{{ selectedDevice.humidity?.toFixed(2) }} %</el-tag>
              </el-descriptions-item>
            </el-descriptions>
          </div>

          <el-divider v-if="selectedDevice.type === 'light_controller'">设备灯光调节</el-divider>
          <div v-if="selectedDevice.type === 'light_controller'" class="light-controls">
            <el-form label-width="100px">
              <el-form-item label="红灯开关">
                <el-switch 
                  v-model="selectedDevice.isRedLightOn"
                  active-text="开"
                  inactive-text="关"
                  @change="setRedLampDutycycle(selectedDevice.isRedLightOn)"
                ></el-switch>
                <span class="light-indicator red-light" :class="{'is-on': selectedDevice.isRedLightOn}"></span>
              </el-form-item>
              <el-form-item label="绿灯开关">
                <el-switch
                  v-model="selectedDevice.isGreenLightOn"
                  active-text="开"
                  inactive-text="关"
                  @change="saveToLocalStorage"
                ></el-switch>
                <span class="light-indicator green-light" :class="{'is-on': selectedDevice.isGreenLightOn}"></span>
              </el-form-item>
            </el-form>
          </div>
        </div>
        <template #footer>
          <span class="dialog-footer">
            <el-button @click="deviceDetailVisible = false">关闭</el-button>
          </span>
        </template>
      </el-dialog>

      <!-- 编辑设备对话框 -->
      <el-dialog
        v-model="deviceEditVisible"
        title="编辑设备"
        width="30%"
      >
        <div v-if="editingDevice" class="device-edit-form">
          <el-form :model="editingDevice" label-width="80px">
            <el-form-item label="设备名称">
              <el-input v-model="editingDevice.name" placeholder="请输入设备名称"></el-input>
            </el-form-item>
            <el-form-item label="IP地址">
              <el-input v-model="editingDevice.ip" placeholder="请输入IP地址"></el-input>
            </el-form-item>
            <el-form-item label="MAC地址">
              <el-input v-model="editingDevice.mac" placeholder="请输入MAC地址" disabled></el-input>
            </el-form-item>
            <el-form-item label="位置">
              <el-input v-model="editingDevice.location" placeholder="请输入设备位置"></el-input>
            </el-form-item>
            <el-form-item label="状态">
              <el-select v-model="editingDevice.status" placeholder="请选择设备状态">
                <el-option label="在线" value="online"></el-option>
                <el-option label="离线" value="offline"></el-option>
              </el-select>
            </el-form-item>
          </el-form>
        </div>
        <template #footer>
          <span class="dialog-footer">
            <el-button v-if="editingDevice && editingDevice.status === 'offline'" type="success" @click="editingDevice.status = 'online'">启动</el-button>
            <el-button v-else-if="editingDevice && editingDevice.status === 'online'" type="danger" @click="editingDevice.status = 'offline'">关闭</el-button>
            <el-button @click="deviceEditVisible = false">取消</el-button>
            <el-button type="primary" @click="saveDeviceEdit">保存</el-button>
          </span>
        </template>
      </el-dialog>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, watch, onUnmounted } from 'vue';
import { ElMessage } from 'element-plus';
import { 
  Refresh, ZoomIn, ZoomOut, Loading, Position, Connection, RemoveFilled, Delete, Edit, RefreshRight
} from '@element-plus/icons-vue';
import * as d3 from 'd3';

// 状态变量
const loading = ref(false);
const deviceDetailVisible = ref(false);
const selectedDevice = ref(null);
const topologyContainer = ref(null);
const zoom = ref(1);
const currentTool = ref('move');
const connectingSource = ref(null);
const deviceEditVisible = ref(false);
const editingDevice = ref(null);
const simulationInterval = ref(null);

// D3变量
let svg = null;
let simulation = null;
let dragging = false;

// 华为IoTDA灯光控制API配置
const LIGHT_CONTROL_URL = '/api_iotda/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/671ef76965629b34009b20f9_Lamp01/commands';
const LIGHT_CONTROL_TOKEN = "MIINwAYJKoZIhvcNAQcCoIINsTCCDa0CAQExDTALBglghkgBZQMEAgEwggvSBgkqhkiG9w0BBwGgggvDBIILv3sidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMTRUMDI6MDU6MzAuMjMwMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtIjoic2VjdV9hZ2VuY3kIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfY3Nic19yZXBfYWNjZWxlcmF0aW9uIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2Rpc2tBY2MiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kc3NfbW9udGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vYnNfZGVlcF9hcmNoaXZlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1zb3V0aC00YyIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZGljX21vbnRoX3VzZXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfc2VsbG91dCIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF93ZWxpbmticmlkZ2VfZW5kcG9pbnRfYnV5IiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfY2JyX2ZpbGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtcm9ja2V0bXE1LWJhc2ljIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZG1zLWthZmthMyIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfb2JzX2RlY19tb250aCIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfY2JyX3Ztd2FyZSIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfaWRtZV9tYm1fZm91bmRhdGlvbiIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZWNzX2M2YSIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfbXVsdGlfYmluZCIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfc21uX2NhbGxub3RpZnkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9NYXBfYmV0YSIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtNGQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Byb2dyZXNzYmFyIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfY2VzX3Jlc291cmNlZ3JvdXBfdGFnIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfYWM3IiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZXZzX3JldHlwZSIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfa29vbWFwIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZXZzX2Vzc2UyIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZG1zLWFtcXAtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcG9vbF9jYSIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfYV9jbi1zb3V0aHdlc3QtMmIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2NwaCIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZWNzX29mZmxpbmVfZGlza180IiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfaHdkZXYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fd2VsaW5rcmVkIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfaHZfdmVuZG9yIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZSIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZCIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZWNzX2hlY3NfeCIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfY3Nic19maWxlc19iYWNrdXAiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3NfYWM3IiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZXBzIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfY3Nic19yZXN0b3JlX2FsbCIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZiIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfcm91bmR0YWJsZSIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZXZzX2V4dCIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfcGZzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW1vc2Nvdz0xYiIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hcHBzdGFnZSIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWYiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9zbW5fYXBwbGljYXRpb24iLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfY29sZCIsImlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfcmRzX2NhIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZWNzX2dwdV9nNXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9tZXNzYWdlb3ZlcjVnIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfZWNzX3JpIiwiaWlkIjoiMCJ9LHsibmFtIjoib3BfZ2F0ZWRfYV9ydS1ub3J0aHdlc3QtMmMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9pZWYfcGxhdGludW0iLCJpZCI6IjAifV0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMTNUMDI6MDU6MzAuMjMwMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX0xggHBMIIBvQIBATCBlzCBiTELMAkGA1UEBhMCQ04xEjAQBgNVBAgMCUd1YW5nRG9uZzERMA8GA1UEBwwIU2hlblpoZW4xLjAsBgNVBAoMJUh1YXdlaSBTb2Z0d2FyZSBUZWNobm9sb2dpZXMgQ28uLCBMdGQxDjAMBgNVBAsMBUNsb3VkMRMwEQYDVQQDDApjYS5pYW0ucGtpAgkA3LMrXRBhahAwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAACMSRC3JnwyCmWqJ8jGVVT4KA7RGiFPmV-EwHig6IMUqPCbVxqHfmtwfMqdW2Hr62XuG0vRXJkHFtWTaLQpmuXDlFmx0nXwW8dlRKqoUJ8NLyWlmncsT4JkMAl0z0wOvrpG2fsYhZVXj9ECvCQ-DxLo-5+OZPKtjMlaxUIwLDc697zvLmolFqhp6BUca6xamQ6Rzg9HExVsRitMgN0iwdZahLAd0C+J7YQHLCE4uyl+79ibBeEB7RDMzfQUgrMwiddi9ugpEFjf-kEeZIKl-uoqF5TfBhLoBaoat6CEddLh4sL7Cr-TbvOPsnyymNH3A5A7CDRdgtNwqlswrWQveYs=";

// 设备数据
const devices = ref([
  { 
    id: 1, 
    name: '中心路由', 
    type: 'router', 
    status: 'online',
    ip: '192.168.1.1', 
    mac: '00:11:22:33:44:55',
    location: '中心机房',
    lastUpdated: '2023-06-10 14:30:22',
    connections: [2, 3, 4],
    x: 400,
    y: 300
  },
  { 
    id: 2, 
    name: '生产区交换机', 
    type: 'switch', 
    status: 'online',
    ip: '192.168.1.2', 
    mac: '00:11:22:33:44:56',
    location: '生产区机房',
    lastUpdated: '2023-06-10 14:35:10',
    connections: [1, 5],
    x: 600,
    y: 200
  },
  { 
    id: 3, 
    name: '仓储区网关', 
    type: 'gateway', 
    status: 'online',
    ip: '192.168.1.3', 
    mac: '00:11:22:33:44:57',
    location: '仓储区机房',
    lastUpdated: '2023-06-10 14:32:18',
    connections: [1, 6],
    x: 200,
    y: 200
  },
  { 
    id: 4, 
    name: '生产线终端A', 
    type: 'terminal', 
    status: 'online',
    ip: '192.168.1.4', 
    mac: '00:11:22:33:44:58',
    location: '生产线A',
    lastUpdated: '2023-06-10 12:10:45',
    connections: [1],
    x: 400,
    y: 500
  },
  { 
    id: 5, 
    name: '生产线终端B', 
    type: 'terminal', 
    status: 'online',
    ip: '192.168.1.5', 
    mac: '00:11:22:33:44:59',
    location: '生产线B',
    lastUpdated: '2023-06-10 14:38:22',
    connections: [2],
    x: 700,
    y: 300
  },
  { 
    id: 6, 
    name: '温湿度传感器', 
    type: 'temp_humid_sensor', 
    status: 'online',
    ip: '192.168.1.6', 
    mac: '00:11:22:33:44:60',
    location: '仓储区A',
    lastUpdated: '2023-06-10 14:40:12',
    connections: [3],
    x: 100,
    y: 300,
    temperature: 25.5,
    humidity: 60.2
  }
]);

// 工具函数 
function setTool(tool) {
  currentTool.value = tool;
  if (tool !== 'connect') {
    connectingSource.value = null;
  }
}

function onDeviceDragStart(type, event) {
  event.dataTransfer.setData('deviceType', type);
}

// 持久化存储功能
function saveToLocalStorage() {
  localStorage.setItem('xingshantongxin-topology', JSON.stringify(devices.value));
}

function loadFromLocalStorage() {
  const savedData = localStorage.getItem('xingshantongxin-topology');
  if (savedData) {
    try {
      return JSON.parse(savedData);
    } catch (e) {
      console.error('解析保存的拓扑图数据失败:', e);
      return null;
    }
  }
  return null;
}

// 在添加设备时保存数据
function onTopologyDrop(event) {
  const deviceType = event.dataTransfer.getData('deviceType');
  if (!deviceType) return;
  
  // 获取鼠标在容器中的坐标
  const rect = topologyContainer.value.getBoundingClientRect();
  const x = event.clientX - rect.left;
  const y = event.clientY - rect.top;
  
  // 生成新设备ID
  const maxId = devices.value.reduce((max, device) => Math.max(max, device.id), 0);
  const newId = maxId + 1;
  
  // 创建新设备
  const newDevice = {
    id: newId,
    name: `${getDeviceTypeName(deviceType)}${newId}`,
    type: deviceType,
    status: 'online',
    ip: `192.168.1.${newId}`,
    mac: `00:11:22:33:44:${(newId + 50).toString(16).padStart(2, '0')}`,
    location: '智慧工厂',
    lastUpdated: new Date().toLocaleString(),
    connections: [],
    x,
    y
  };
  
  if (deviceType === 'light_controller') {
    newDevice.isRedLightOn = false;
    newDevice.isGreenLightOn = true;
  }
  if (deviceType === 'temp_humid_sensor') {
    newDevice.temperature = parseFloat((20 + Math.random() * 10).toFixed(2));
    newDevice.humidity = parseFloat((50 + Math.random() * 20).toFixed(2));
  }
  
  devices.value.push(newDevice);
  renderTopology();
  saveToLocalStorage(); // 保存更新后的数据
}

// 方法
const getDeviceTypeName = (type) => {
  const typeMap = {
    'router': '路由器',
    'switch': '交换机',
    'gateway': '网关',
    'terminal': '厂区',
    'light_controller': '设备灯光控制器',
    'temp_humid_sensor': '温湿度传感器'
  };
  return typeMap[type] || '未知设备';
};

const getDeviceTypeIcon = (type) => {
  switch (type) {
    case 'router': return '🖧';
    case 'switch': return '⇄';
    case 'gateway': return '⋮';
    case 'terminal': return '💻';
    case 'light_controller': return '💡';
    case 'temp_humid_sensor': return '🌡️';
    default: return '?';
  }
};

const zoomIn = () => {
  zoom.value = Math.min(2, zoom.value + 0.1);
  applyZoom();
};

const zoomOut = () => {
  zoom.value = Math.max(0.5, zoom.value - 0.1);
  applyZoom();
};

const applyZoom = () => {
  if (svg) {
    svg.attr('transform', `scale(${zoom.value})`);
  }
};

// 连接设备逻辑
function handleNodeClick(event, d) {
  if (dragging) return; // 忽略拖拽过程中的点击
  
  event.stopPropagation();
  
  const clickedDevice = devices.value.find(dev => dev.id === d.id);
  if (!clickedDevice) return;
  
  if (currentTool.value === 'connect') {
    if (!connectingSource.value) {
      // 记录第一个设备
      connectingSource.value = clickedDevice;
      ElMessage.info(`选择第一个设备: ${clickedDevice.name}`);
    } else if (connectingSource.value.id !== clickedDevice.id) {
      // 选择了第二个设备，创建连接
      const sourceId = connectingSource.value.id;
      const targetId = clickedDevice.id;
      
      // 检查连接是否已存在
      if (!connectingSource.value.connections.includes(targetId) && 
          !clickedDevice.connections.includes(sourceId)) {
        // 添加连接
        connectingSource.value.connections.push(targetId);
        clickedDevice.connections.push(sourceId);
        renderTopology();
        saveToLocalStorage(); // 保存更新后的数据
        ElMessage.success(`已连接 ${connectingSource.value.name} 和 ${clickedDevice.name}`);
      } else {
        ElMessage.warning('这两个设备已经连接');
      }
      
      // 重置连接状态
      connectingSource.value = null;
    }
  } else if (currentTool.value === 'disconnect') {
    if (!connectingSource.value) {
      // 记录第一个设备
      connectingSource.value = clickedDevice;
      ElMessage.info(`选择第一个设备: ${clickedDevice.name}`);
    } else if (connectingSource.value.id !== clickedDevice.id) {
      // 选择了第二个设备，切断连接
      const sourceId = connectingSource.value.id;
      const targetId = clickedDevice.id;
      
      // 检查连接是否存在
      if (connectingSource.value.connections.includes(targetId) || 
          clickedDevice.connections.includes(sourceId)) {
        // 切断连接
        connectingSource.value.connections = connectingSource.value.connections.filter(id => id !== targetId);
        clickedDevice.connections = clickedDevice.connections.filter(id => id !== sourceId);
        renderTopology();
        saveToLocalStorage(); // 保存更新后的数据
        ElMessage.success(`已切断 ${connectingSource.value.name} 和 ${clickedDevice.name} 之间的连接`);
      } else {
        ElMessage.warning('这两个设备没有连接');
      }
      
      // 重置连接状态
      connectingSource.value = null;
    }
  } else if (currentTool.value === 'delete') {
    // 删除设备及其所有连接
    // 1. 从所有其他设备的connections中删除该设备
    devices.value.forEach(device => {
      if (device.id !== clickedDevice.id) {
        device.connections = device.connections.filter(id => id !== clickedDevice.id);
      }
    });
    
    // 2. 从设备数组中删除该设备
    devices.value = devices.value.filter(device => device.id !== clickedDevice.id);
    
    // 3. 重新渲染拓扑图
    renderTopology();
    saveToLocalStorage(); // 保存更新后的数据
    ElMessage.success(`已删除设备: ${clickedDevice.name}`);
  } else if (currentTool.value === 'edit') {
    // 编辑设备信息
    editingDevice.value = JSON.parse(JSON.stringify(clickedDevice)); // 复制一份避免直接修改
    deviceEditVisible.value = true;
  } else {
    // 显示设备详情
    selectedDevice.value = clickedDevice;
    deviceDetailVisible.value = true;
  }
}

// 刷新拓扑图
const refreshTopology = async () => {
  loading.value = true;
  try {
    await new Promise(resolve => setTimeout(resolve, 800));
    renderTopology();
    ElMessage.success('拓扑图刷新成功');
  } catch (error) {
    console.error('刷新拓扑图失败:', error);
    ElMessage.error('刷新拓扑图失败');
  } finally {
    loading.value = false;
  }
};

// 拓扑图渲染
const renderTopology = () => {
  if (!topologyContainer.value) {
    console.error('拓扑图容器不存在');
    return;
  }

  const width = topologyContainer.value.clientWidth || 800;
  const height = topologyContainer.value.clientHeight || 600;
  
  // 清除现有SVG
  d3.select(topologyContainer.value).selectAll('svg').remove();
  
  // 创建新SVG
  const svgContainer = d3.select(topologyContainer.value)
    .append('svg')
    .attr('width', width)
    .attr('height', height);
  
  // 添加网格背景
  const gridPattern = svgContainer.append('defs')
    .append('pattern')
    .attr('id', 'grid')
    .attr('width', 20)
    .attr('height', 20)
    .attr('patternUnits', 'userSpaceOnUse');
  
  // 网格背景矩形
  gridPattern.append('rect')
    .attr('width', 20)
    .attr('height', 20)
    .attr('fill', '#f5f7fa');
  
  // 网格点
  gridPattern.append('circle')
    .attr('cx', 1)
    .attr('cy', 1)
    .attr('r', 1)
    .attr('fill', '#ddd');
  
  // 应用网格背景
  svgContainer.append('rect')
    .attr('width', width)
    .attr('height', height)
    .attr('fill', 'url(#grid)');
  
  // 创建可缩放组
  svg = svgContainer.append('g');
  
  // 准备节点和连接数据
  const nodes = devices.value.map(d => ({...d})); // 复制以避免直接修改原始数据
  const links = [];
  
  // 构建连接数据
  devices.value.forEach(source => {
    source.connections.forEach(targetId => {
      const target = devices.value.find(d => d.id === targetId);
      if (target && source.id < target.id) { // 避免重复连接
        links.push({ 
          source: source.id, 
          target: target.id,
          isActive: source.status === 'online' && target.status === 'online'
        });
      }
    });
  });
  
  // 绘制连接线
  const linkElements = svg.append('g')
    .selectAll('line')
    .data(links)
    .enter()
    .append('line')
    .attr('class', 'link')
    .attr('stroke', '#333') // 黑色连线，类似eNSP
    .attr('stroke-width', 2)
    .attr('x1', d => {
      const source = nodes.find(n => n.id === d.source);
      return source ? source.x : 0;
    })
    .attr('y1', d => {
      const source = nodes.find(n => n.id === d.source);
      return source ? source.y : 0;
    })
    .attr('x2', d => {
      const target = nodes.find(n => n.id === d.target);
      return target ? target.x : 0;
    })
    .attr('y2', d => {
      const target = nodes.find(n => n.id === d.target);
      return target ? target.y : 0;
    });
  
  // 绘制节点组
  const nodeElements = svg.append('g')
    .selectAll('.node')
    .data(nodes)
    .enter()
    .append('g')
    .attr('class', 'node')
    .attr('transform', d => `translate(${d.x}, ${d.y})`)
    .call(d3.drag()
      .on('start', dragStarted)
      .on('drag', dragged)
      .on('end', dragEnded)
    )
    .on('click', handleNodeClick);
  
  // 绘制节点圆形背景
  nodeElements.append('circle')
    .attr('r', 20)
    .attr('fill', d => {
      switch(d.type) {
        case 'router': return '#409EFF';
        case 'switch': return '#67C23A';
        case 'gateway': return '#F56C6C';
        case 'terminal': 
          return '#909399'; // 终端背景保持灰色
        case 'light_controller': return '#FF6B6B';
        case 'temp_humid_sensor': return '#E6A23C';
        default: return '#909399';
      }
    })
    .attr('opacity', 0.9);
  
  // 添加设备图标
  nodeElements.append('text')
    .attr('text-anchor', 'middle')
    .attr('dominant-baseline', 'central')
    .text(d => getDeviceTypeIcon(d.type))
    .attr('fill', 'white')
    .attr('font-size', '18px');
  
  // 添加设备状态指示灯
  nodeElements.append('circle')
    .attr('class', 'status-indicator')
    .attr('r', 6) // 指示灯大小
    .attr('cx', 15) // 相对于节点中心向右偏移，放置在右上角
    .attr('cy', -15) // 相对于节点中心向上偏移，放置在右上角
    .attr('fill', d => d.status === 'online' ? '#67C23A' : '#F56C6C') // 根据设备状态设置颜色
    .attr('stroke', '#fff')
    .attr('stroke-width', 1.5);

  // 添加设备名称
  nodeElements.append('text')
    .attr('text-anchor', 'middle')
    .attr('y', 30)
    .text(d => d.name)
    .attr('fill', '#333')
    .attr('font-size', '12px');
  
  // 传感器数据显示
  nodeElements.append('text')
    .attr('class', 'sensor-data-text')
    .attr('text-anchor', 'middle')
    .attr('y', 45) // 放在设备名称下方
    .attr('fill', d => {
      if (d.type === 'temp_humid_sensor') return '#303133';
      return 'transparent';
    })
    .attr('font-size', '11px')
    .attr('font-weight', 'bold')
    .text(d => {
      const currentDeviceData = devices.value.find(device => device.id === d.id);
      if (currentDeviceData && currentDeviceData.type === 'temp_humid_sensor' && currentDeviceData.temperature !== undefined && currentDeviceData.humidity !== undefined) {
        return `${currentDeviceData.temperature.toFixed(1)}°C / ${currentDeviceData.humidity.toFixed(1)}%`;
      }
      return '';
    });
  
  function dragStarted(event, d) {
    dragging = true;
  }
  
  function dragged(event, d) {
    // 更新当前节点位置
    d.x = event.x;
    d.y = event.y;
    
    // 更新视图
    d3.select(this).attr('transform', `translate(${d.x}, ${d.y})`);
    
    // 更新连接线位置
    linkElements
      .filter(link => link.source === d.id || link.target === d.id)
      .attr('x1', link => {
        const source = nodes.find(n => n.id === link.source);
        return source ? source.x : 0;
      })
      .attr('y1', link => {
        const source = nodes.find(n => n.id === link.source);
        return source ? source.y : 0;
      })
      .attr('x2', link => {
        const target = nodes.find(n => n.id === link.target);
        return target ? target.x : 0;
      })
      .attr('y2', link => {
        const target = nodes.find(n => n.id === link.target);
        return target ? target.y : 0;
      });
  }
  
  function dragEnded(event, d) {
    dragging = false;
    
    // 更新原始数据中的位置
    const device = devices.value.find(dev => dev.id === d.id);
    if (device) {
      device.x = d.x;
      device.y = d.y;
      saveToLocalStorage(); // 保存更新后的位置
    }
  }
};

// 生命周期钩子
onMounted(async () => {
  try {
    loading.value = true;
    
    // 加载保存的数据
    const savedData = loadFromLocalStorage();
    if (savedData && savedData.length > 0) {
      devices.value = savedData;
      ElMessage.info('已加载保存的拓扑图数据');
    }
    
    // 确保DOM已经完全加载
    nextTick(() => {
      renderTopology();
      loading.value = false;
      ElMessage.success('星闪通信拓扑图已加载');
    });
    
    simulationInterval.value = setInterval(() => {
      let needsUpdate = false;
      devices.value.forEach(device => {
        if (device.type === 'temp_humid_sensor' && device.status === 'online') {
          const tempChange = (Math.random() - 0.5) * 0.2;
          device.temperature = parseFloat((device.temperature + tempChange).toFixed(2));
          const humidChange = (Math.random() - 0.5) * 0.5;
          device.humidity = parseFloat((device.humidity + humidChange).toFixed(2));
          needsUpdate = true;
        }
      });

      if (needsUpdate && svg) {
        // 只更新D3中的文本，避免重绘整个拓扑
        svg.selectAll('.sensor-data-text')
          .text(d => {
            const currentDeviceData = devices.value.find(device => device.id === d.id);
            if (currentDeviceData && currentDeviceData.type === 'temp_humid_sensor' && currentDeviceData.temperature !== undefined && currentDeviceData.humidity !== undefined) {
              return `${currentDeviceData.temperature.toFixed(1)}°C / ${currentDeviceData.humidity.toFixed(1)}%`;
            }
            return '';
          });
      }
    }, 3000); // 每3秒更新一次

    // 监听窗口大小变化
    window.addEventListener('resize', () => {
      try {
        renderTopology();
      } catch (error) {
        console.error('重新渲染拓扑图失败:', error);
      }
    });
  } catch (error) {
    console.error('初始化星闪通信页面失败:', error);
    ElMessage.error('加载拓扑图失败，请刷新页面');
    loading.value = false;
  }
});

onUnmounted(() => {
  if (simulationInterval.value) {
    clearInterval(simulationInterval.value);
  }
});

// 保存设备编辑
function saveDeviceEdit() {
  if (!editingDevice.value) return;
  
  // 查找并更新设备
  const device = devices.value.find(d => d.id === editingDevice.value.id);
  if (device) {
    device.name = editingDevice.value.name;
    device.ip = editingDevice.value.ip;
    device.location = editingDevice.value.location;
    device.status = editingDevice.value.status;
    
    // 更新最后修改时间
    device.lastUpdated = new Date().toLocaleString();
    
    // 重新渲染拓扑图
    renderTopology();
    saveToLocalStorage(); // 保存更新后的数据
    ElMessage.success('设备信息已更新');
  }
  
  // 关闭对话框
  deviceEditVisible.value = false;
  editingDevice.value = null;
}

// 添加恢复默认布局按钮和函数
function resetTopology() {
  ElMessage.info('正在重置拓扑图...');
  localStorage.removeItem('xingshantongxin-topology');
  devices.value = [
    { 
      id: 1, 
      name: '中心路由', 
      type: 'router', 
      status: 'online',
      ip: '192.168.1.1', 
      mac: '00:11:22:33:44:55',
      location: '中心机房',
      lastUpdated: '2023-06-10 14:30:22',
      connections: [2, 3, 4],
      x: 400,
      y: 300
    },
    {
      id: 2,
      name: '生产区交换机',
      type: 'switch',
      status: 'online',
      ip: '192.168.1.2',
      mac: '00:11:22:33:44:56',
      location: '生产区机房',
      lastUpdated: '2023-06-10 14:35:10',
      connections: [1, 5],
      x: 600,
      y: 200
    },
    {
      id: 3,
      name: '仓储区网关',
      type: 'gateway',
      status: 'online',
      ip: '192.168.1.3',
      mac: '00:11:22:33:44:57',
      location: '仓储区机房',
      lastUpdated: '2023-06-10 14:32:18',
      connections: [1, 6],
      x: 200,
      y: 200
    },
    {
      id: 4,
      name: '生产线终端A',
      type: 'terminal',
      status: 'online',
      ip: '192.168.1.4',
      mac: '00:11:22:33:44:58',
      location: '生产线A',
      lastUpdated: '2023-06-10 12:10:45',
      connections: [1],
      x: 400,
      y: 500
    },
    {
      id: 5,
      name: '生产线终端B',
      type: 'terminal',
      status: 'online',
      ip: '192.168.1.5',
      mac: '00:11:22:33:44:59',
      location: '生产线B',
      lastUpdated: '2023-06-10 14:38:22',
      connections: [2],
      x: 700,
      y: 300
    },
    {
      id: 6,
      name: '温湿度传感器',
      type: 'temp_humid_sensor',
      status: 'online',
      ip: '192.168.1.6',
      mac: '00:11:22:33:44:60',
      location: '仓储区A',
      lastUpdated: '2023-06-10 14:40:12',
      connections: [3],
      x: 100,
      y: 300,
      temperature: 25.5,
      humidity: 60.2
    }
  ];
  renderTopology();
  ElMessage.success('拓扑图已重置');
}

// 新增红灯开关API调用方法
async function setRedLampDutycycle(state) {
  try {
    await fetch('http://192.168.31.30:5003/set_lamp_status', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ lamp_status: state ? 'ON' : 'OFF' })
    });
    saveToLocalStorage();
  } catch (e) {
    ElMessage.error('红灯控制API调用失败');
    selectedDevice.value.isRedLightOn = false;
    saveToLocalStorage();
  }
}
</script>

<style scoped>
.xingshantongxin-layout {
  display: flex;
  height: 100%;
}
.device-panel {
  width: 200px;
  background: #f5f7fa;
  border-right: 1px solid #ddd;
  height: 100%;
  overflow-y: auto;
  padding: 15px 10px;
}
.panel-title {
  font-size: 18px;
  font-weight: bold;
  padding-bottom: 15px;
  border-bottom: 1px solid #e0e0e0;
  margin-bottom: 15px;
}
.device-categories {
  display: flex;
  flex-direction: column;
  gap: 15px;
}
.category-item {
  margin-bottom: 10px;
}
.category-title {
  font-weight: bold;
  font-size: 15px;
  margin-bottom: 8px;
  color: #1989fa;
}
.category-devices {
  display: flex;
  flex-direction: column;
  gap: 5px;
}
.device-item {
  display: flex;
  align-items: center;
  padding: 8px;
  border-radius: 4px;
  background: white;
  cursor: grab;
  user-select: none;
  box-shadow: 0 1px 2px rgba(0,0,0,0.1);
  transition: all 0.2s ease;
}
.device-item:hover {
  background: #e6f7ff;
  box-shadow: 0 2px 4px rgba(0,0,0,0.15);
}
.device-icon {
  font-size: 20px;
  margin-right: 8px;
}
.router-icon {
  color: #409EFF;
}
.switch-icon {
  color: #67C23A;
}
.gateway-icon {
  color: #F56C6C;
}
.terminal-icon {
  color: #909399;
}
.temp-humid-icon {
  color: #E6A23C;
}
.device-name {
  font-size: 14px;
}
.topology-area {
  flex-grow: 1;
  padding: 15px;
  height: 100%;
  overflow: auto;
  display: flex;
  flex-direction: column;
}
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}
.header-actions {
  display: flex;
  gap: 10px;
  align-items: center;
}
.operation-tip {
  margin-bottom: 10px;
  padding: 8px;
  background: #ecf8ff;
  border-radius: 4px;
  color: #409EFF;
  font-size: 14px;
}
.active-tool {
  background-color: #409EFF !important;
  color: white !important;
}
.topology-card {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}
.topology-tools {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
  padding: 10px;
  border-bottom: 1px solid #eee;
}
.topology-legend {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  margin-bottom: 10px;
  padding: 10px;
  background-color: #f5f7fa;
  border-radius: 4px;
}
.legend-item {
  display: flex;
  align-items: center;
  gap: 5px;
}
.legend-icon {
  width: 20px;
  height: 20px;
  border-radius: 50%;
}
.router {
  background-color: #409EFF;
}
.switch {
  background-color: #67C23A;
}
.gateway {
  background-color: #F56C6C;
}
.terminal {
  background-color: #909399;
}
.temp-humid {
  background-color: #E6A23C;
}
.light-controller {
  background-color: #FF6B6B;
}
.topology-container {
  width: 100%;
  flex-grow: 1;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  position: relative;
  overflow: hidden;
  min-height: 500px;
}
.loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  background-color: rgba(255, 255, 255, 0.7);
  z-index: 10;
}
.loading-icon {
  font-size: 30px;
  animation: spin 1s linear infinite;
  margin-bottom: 10px;
}
@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
.device-detail {
  padding: 10px;
}
.device-header {
  margin-bottom: 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
}
.device-header .el-tag {
  padding: 15px;
  height: auto;
  border-radius: 8px;
  line-height: 1;
}
.device-header-icon {
  margin-right: 0;
  font-size: 4em;
  line-height: 1;
}
.device-header-name {
  font-size: 16px;
  font-weight: 600;
}
.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
.device-control-form {
  margin-top: 20px;
  padding: 15px;
  border: 1px solid #EBEEF5;
  border-radius: 4px;
  background-color: #F8F8F8;
}
.sensor-data {
  margin-top: 20px;
  padding: 15px;
  border: 1px solid #EBEEF5;
  border-radius: 4px;
  background-color: #F8F8F8;
}
.light-controls {
  margin-top: 20px;
  padding: 15px;
  border: 1px solid #EBEEF5;
  border-radius: 4px;
  background-color: #F8F8F8;
}
.el-form-item {
  display: flex;
  align-items: center;
}
.light-indicator {
  width: 16px;
  height: 16px;
  border-radius: 50%;
  margin-left: 10px;
  border: 1px solid #ccc;
  transition: all 0.3s ease;
  box-shadow: 0 0 5px rgba(0,0,0,0.2);
}
.red-light.is-on {
  background-color: #F56C6C;
  box-shadow: 0 0 8px #F56C6C, 0 0 15px #F56C6C;
  border-color: #F56C6C;
}
.green-light.is-on {
  background-color: #67C23A;
  box-shadow: 0 0 8px #67C23A, 0 0 15px #67C23A;
  border-color: #67C23A;
}
/* 连接线样式 */
.link {
  stroke-opacity: 0.8;
}
/* 节点样式 */
.node {
  cursor: pointer;
}
.node:hover circle {
  filter: brightness(1.1);
}
.status-indicator {
  filter: drop-shadow(0 0 3px rgba(0,0,0,0.5));
}
.light-controller-icon {
  color: #FF6B6B;
}
</style>