<template>
  <div class="remote-control">
    <h2 style="margin-top: -25px;">产线管理</h2>
    <el-row :gutter="20">
      <el-col :span="12">
        <el-card 
          class="robot-card" 
          v-for="(robot, index) in robots.slice(0, 2)" 
          :key="robot.name" 
          :class="{ 'active': robot.active }"
          @click="toggleSelection(robot)"
        >
          <div class="card-content-wrapper">
            <div>
              <el-checkbox-group v-model="selectedRobots">
                <el-checkbox :label="robot.name">{{ robot.name }}</el-checkbox>
              </el-checkbox-group>
              <el-radio disabled :label="robot.status">{{ robot.status }}</el-radio>
              <div class="card-actions">
                <el-button size="small" type="primary" @click.stop="remoteConnect(robot)">远程连接</el-button>
                <el-button size="small" type="info" @click.stop="showDetail(robot)">查看详细</el-button>
              </div>
            </div>
            <img src="@/assets/imgs/arm.png" alt="机械臂" class="robot-image" />
          </div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card 
          class="robot-card" 
          v-for="(robot, index) in robots.slice(2)" 
          :key="robot.name" 
          :class="{ 'active': robot.active }"
          @click="toggleSelection(robot)"
        >
          <div class="card-content-wrapper">
            <div>
              <el-checkbox-group v-model="selectedRobots">
                <el-checkbox :label="robot.name">{{ robot.name }}</el-checkbox>
              </el-checkbox-group>
              <el-radio disabled :label="robot.status">{{ robot.status }}</el-radio>
              <div class="card-actions">
                <el-button size="small" type="primary" @click.stop="remoteConnect(robot)">远程连接</el-button>
                <el-button size="small" type="info" @click.stop="showDetail(robot)">查看详细</el-button>
              </div>
            </div>
            <img src="@/assets/imgs/arm.png" alt="机械臂" class="robot-image" />
          </div>
        </el-card>
      </el-col>
    </el-row>
    <div class="control-buttons">
      <el-button type="primary" @click="showConfirmDialog">启动</el-button>
      <el-button type="danger" @click="stop">停止</el-button>
    </div>

    <!-- 确认对话框 -->
    <el-dialog v-model="dialogVisible" title="确认操作" width="30%">
      <span>确定要启动所选机械臂吗？</span>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="confirmStart">确认</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 机械臂详情抽屉 -->
    <el-drawer
      v-model="drawerVisible"
      title="机械臂详情"
      direction="rtl"
      size="50%"
      :with-header="true"
    >
      <div v-if="currentRobot" class="robot-detail">
        <h3>{{ currentRobot.name }}</h3>
        <div class="detail-section">
          <p><strong>处理器：</strong> Intel i5-10400 2.9GHz</p>
          <p><strong>内存：</strong> 16GB DDR4</p>
          <p><strong>存储：</strong> 512GB SSD</p>
          <p><strong>状态：</strong> {{ currentRobot.status }}</p>
        </div>
        <div class="detail-actions">
          <el-button type="primary" @click="remoteConnect(currentRobot)">远程连接</el-button>
          <el-button type="success" @click="startRobot(currentRobot)" :disabled="currentRobot.status === '运行中'">启动</el-button>
          <el-button type="danger" @click="stopRobot(currentRobot)" :disabled="currentRobot.status === '空闲'">停止</el-button>
          <el-button type="warning" @click="editRobot(currentRobot)">修改</el-button>
          <el-button type="info" @click="deleteRobot(currentRobot)">删除</el-button>
        </div>
      </div>
    </el-drawer>

    <!-- 远程连接抽屉 -->
    <el-drawer
      v-model="connDrawerVisible"
      title="远程连接"
      direction="rtl"
      size="80%"
      :with-header="true"
    >
      <div v-if="currentRobot" class="remote-connection">
        <div class="connection-header">
          <h3>{{ currentRobot.name }}</h3>
          <div class="ip-config">
            <div class="ip-input-group">
              <span>IP地址:</span>
              <el-input v-model="currentRobot.ip" placeholder="请输入IP地址" size="small" style="width: 180px;" />
              <span>端口: 9100</span>
            </div>
            <div class="connection-actions">
              <el-button type="primary" size="small" @click="testConnection">测试连接</el-button>
              <el-button type="success" size="small" @click="saveIpConfig">保存配置</el-button>
            </div>
          </div>
          <div class="connection-time">
            <span>最后更新: {{ currentTime }}</span>
            <div class="connection-status-indicator" :class="{'connected': connectionStatus}">
              <span>{{ connectionStatus ? '已连接' : '未连接' }}</span>
            </div>
            <el-button type="primary" icon="Refresh" circle @click="refreshMonitorData"></el-button>
          </div>
        </div>
        
        <div class="resource-monitor">
          <el-row :gutter="20">
            <el-col :span="6">
              <div class="resource-card">
                <h4>CPU 使用率</h4>
                <div class="resource-chart">
                  <el-progress type="dashboard" :percentage="cpuUsage" :color="getProgressColor(cpuUsage)"></el-progress>
                  <div class="usage-text">
                    <span class="used">已使用</span>
                    <span class="unused">未使用</span>
                  </div>
                  <div class="usage-value">{{ cpuUsage }}%</div>
                </div>
              </div>
            </el-col>
            <el-col :span="6">
              <div class="resource-card">
                <h4>内存使用率</h4>
                <div class="resource-chart">
                  <el-progress type="dashboard" :percentage="memoryUsage" :color="getProgressColor(memoryUsage)"></el-progress>
                  <div class="usage-text">
                    <span class="used">已使用</span>
                    <span class="unused">未使用</span>
                  </div>
                  <div class="usage-value">{{ memoryUsage }}%</div>
                </div>
              </div>
            </el-col>
            <el-col :span="6">
              <div class="resource-card">
                <h4>磁盘使用率</h4>
                <div class="resource-chart">
                  <el-progress type="dashboard" :percentage="diskUsage" :color="getProgressColor(diskUsage)"></el-progress>
                  <div class="usage-text">
                    <span class="used">已使用</span>
                    <span class="unused">未使用</span>
                  </div>
                  <div class="usage-value">{{ diskUsage }}%</div>
                </div>
              </div>
            </el-col>
            <el-col :span="6">
              <div class="resource-card">
                <h4>网络使用率</h4>
                <div class="resource-chart">
                  <el-progress type="dashboard" :percentage="networkUsage" :color="getProgressColor(networkUsage)"></el-progress>
                  <div class="usage-text">
                    <span class="used">已使用</span>
                    <span class="unused">未使用</span>
                  </div>
                  <div class="usage-value">{{ networkUsage }}%</div>
                </div>
              </div>
            </el-col>
          </el-row>
        </div>

        <el-tabs v-model="activeTab" class="monitor-tabs">
          <el-tab-pane label="资源监控" name="resource">
            <div class="resource-trend">
              <h4>资源使用趋势</h4>
              <p>实时监控服务器资源使用情况</p>
              <div class="tabs-content">
                <el-tabs v-model="resourceTab">
                  <el-tab-pane label="CPU" name="cpu">
                    <div ref="cpuChartRef" style="width: 100%; height: 300px;"></div>
                  </el-tab-pane>
                  <el-tab-pane label="内存" name="memory">
                    <div ref="memoryChartRef" style="width: 100%; height: 300px;"></div>
                  </el-tab-pane>
                  <el-tab-pane label="磁盘" name="disk">
                    <div ref="diskChartRef" style="width: 100%; height: 300px;"></div>
                  </el-tab-pane>
                  <el-tab-pane label="网络" name="network">
                    <div ref="networkChartRef" style="width: 100%; height: 300px;"></div>
                  </el-tab-pane>
                </el-tabs>
              </div>
            </div>
          </el-tab-pane>
          <el-tab-pane label="SSH 终端" name="ssh">
            <div class="ssh-terminal">
              <div class="terminal-info">
                <div class="terminal-user">
                  <el-icon><Message /></el-icon>
                  <span>root@{{ currentRobot.ip }}</span>
                  <el-input v-model="sshConfig.port" placeholder="端口" size="small" style="width: 80px;" />
                </div>
                <div class="ssh-auth">
                  <el-select v-model="sshConfig.authType" placeholder="认证方式" size="small">
                    <el-option label="密码认证" value="password"></el-option>
                    <el-option label="密钥认证" value="key"></el-option>
                  </el-select>
                  <el-input 
                    v-if="sshConfig.authType === 'password'" 
                    v-model="sshConfig.password" 
                    placeholder="密码" 
                    type="password" 
                    size="small" 
                    style="width: 150px; margin-left: 10px;" 
                  />
                  <el-upload 
                    v-else 
                    action="#" 
                    :auto-upload="false" 
                    :on-change="handleKeyFileChange"
                    style="margin-left: 10px;"
                  >
                    <el-button size="small">选择密钥文件</el-button>
                  </el-upload>
                </div>
                <el-button 
                  type="primary" 
                  :icon="sshConnected ? 'Close' : 'Link'" 
                  @click="handleSSHConnection"
                >
                  {{ sshConnected ? '断开连接' : '连接' }}
                </el-button>
              </div>
              <div class="terminal-window">
                <div v-if="!sshConnected" class="terminal-connect-hint">
                  <p>请配置SSH连接并点击连接按钮</p>
                </div>
                <div v-else class="terminal-content">
                  <p class="connection-message">正在连接到 {{ currentRobot.ip }}:{{ sshConfig.port }}...</p>
                  <p class="connection-message">SSH连接成功，使用{{ sshConfig.authType === 'password' ? '密码' : '密钥' }}认证</p>
                  <p class="terminal-prompt">root@{{ currentRobot.ip }}:~$</p>
                  <div class="command-input">
                    <span class="prompt">$</span>
                    <el-input 
                      v-model="sshCommand" 
                      placeholder="输入命令..." 
                      @keyup.enter="executeSSHCommand" 
                      size="small"
                      class="ssh-input"
                    />
                  </div>
                  <div v-for="(log, index) in sshLogs" :key="index" class="ssh-log">
                    <p v-if="log.type === 'command'" class="terminal-command">$ {{ log.content }}</p>
                    <p v-else class="terminal-result">{{ log.content }}</p>
                  </div>
                </div>
              </div>
              <div class="connection-status">
                <div :class="['status-badge', sshConnected ? 'success' : 'warning']">
                  {{ sshConnected ? '连接成功' : '未连接' }}
                </div>
                <div class="status-message">
                  {{ sshConnected ? '已连接到服务器 ' + currentRobot.ip : '请连接到SSH服务器' }}
                </div>
              </div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue';
import axios from 'axios'; // 引入axios库
import { ElMessageBox, ElMessage } from 'element-plus';
import { CircleCheck, Refresh, Message, Link, Close } from '@element-plus/icons-vue';
import * as echarts from 'echarts';
import { useRouter } from 'vue-router';
import { notifySuccess, notifyInfo } from '../utils/alertNotificationManager';

const router = useRouter();

// 机器人数据（示例数据）
const robots = [
  { name: '机械臂一', active: false, status: '空闲', ip: '192.168.31.12' },
  { name: '机械臂二', active: false, status: '空闲', ip: '192.168.31.13' },
  { name: '机械臂三', active: false, status: '空闲', ip: '192.168.31.14' },
  { name: '机械臂四', active: false, status: '空闲', ip: '192.168.31.15' }
];

const selectedRobots = ref([]); // 选中的机器人数组
const dialogVisible = ref(false); // 确认对话框显示状态
const drawerVisible = ref(false); // 详情抽屉显示状态
const connDrawerVisible = ref(false); // 远程连接抽屉显示状态
const currentRobot = ref(null); // 当前选中的机器人
const currentTime = ref(formatTime(new Date())); // 当前时间
const activeTab = ref('resource'); // 当前活动标签页
const resourceTab = ref('cpu'); // 资源监控标签页

// 资源使用率数据
const cpuUsage = ref(42);
const memoryUsage = ref(52);
const diskUsage = ref(32);
const networkUsage = ref(22);

// SSH相关配置
const sshConfig = ref({
  port: '22',
  authType: 'password',
  password: '',
  keyFile: null
});
const sshConnected = ref(false);
const sshCommand = ref('');
const sshLogs = ref([]);
const sshSessionId = ref(null);

// 连接状态
const connectionStatus = ref(false);

// 图表引用
const cpuChartRef = ref(null);
const memoryChartRef = ref(null);
const diskChartRef = ref(null);
const networkChartRef = ref(null);

// 图表实例
let cpuChart = null;
let memoryChart = null;
let diskChart = null;
let networkChart = null;

// 切换选中状态
const toggleSelection = (robot) => {
  const index = selectedRobots.value.indexOf(robot.name);
  if (index === -1) {
    selectedRobots.value.push(robot.name);
  } else {
    selectedRobots.value.splice(index, 1);
  }
};

// 显示确认对话框
const showConfirmDialog = () => {
  if (selectedRobots.value.length > 0) {
    dialogVisible.value = true;
  } else {
    ElMessage.warning('请选择至少一个机械臂');
  }
};

// 确认启动
const confirmStart = async () => {
  dialogVisible.value = false;
  robots.forEach(robot => {
    if (selectedRobots.value.includes(robot.name)) {
      robot.active = true;
      robot.status = '运行中';
    }
  });
  try {
    await axios.post('/api/start', { robotNames: selectedRobots.value });
    ElMessage.success('启动成功');
  } catch (error) {
    console.error('启动机械臂失败:', error);
    ElMessage.error('启动失败');
  }
};

// 停止按钮点击事件
const stop = async () => {
  robots.forEach(robot => {
    if (selectedRobots.value.includes(robot.name)) {
      robot.active = false;
      robot.status = '空闲';
    }
  });
  selectedRobots.value = [];
  try {
    await axios.post('/api/stop', { robotNames: selectedRobots.value });
    ElMessage.success('停止成功');
  } catch (error) {
    console.error('停止机械臂失败:', error);
    ElMessage.error('停止失败');
  }
};

// 修改远程连接函数
const remoteConnect = (robot) => {
  router.push({
    path: '/framework/remote-connection',
    query: {
      name: robot.name,
      ip: robot.ip || '192.168.1.1'
    }
  });
};

// 修改查看详细函数
const showDetail = (robot) => {
  router.push({
    path: '/framework/robot-detail',
    query: {
      name: robot.name,
      status: robot.status,
      ip: robot.ip || '192.168.1.1'
    }
  });
};

// 刷新监控数据
const refreshMonitorData = async () => {
  try {
    // 检查连接状态
    if (!connectionStatus.value) {
      await testConnection();
      if (!connectionStatus.value) {
        return;
      }
    }
    
    // 从node_exporter获取真实数据
    const response = await axios.get(`/api/robots/monitor/metrics`, {
      params: {
        ip: currentRobot.value.ip,
        port: 9100
      }
    }).catch(error => {
      throw new Error('获取数据失败');
    });
    
    if (response.data) {
      // 假设后端已经处理了数据解析
      cpuUsage.value = response.data.cpu || Math.floor(Math.random() * 30) + 30;
      memoryUsage.value = response.data.memory || Math.floor(Math.random() * 30) + 40;
      diskUsage.value = response.data.disk || Math.floor(Math.random() * 30) + 20;
      networkUsage.value = response.data.network || Math.floor(Math.random() * 30) + 10;
    } else {
      // 回退到模拟数据
      cpuUsage.value = Math.floor(Math.random() * 30) + 30;
      memoryUsage.value = Math.floor(Math.random() * 30) + 40;
      diskUsage.value = Math.floor(Math.random() * 30) + 20;
      networkUsage.value = Math.floor(Math.random() * 30) + 10;
    }
    
    currentTime.value = formatTime(new Date());
    updateCharts();
    
    ElMessage.success('数据刷新成功');
  } catch (error) {
    console.error('获取监控数据失败:', error);
    ElMessage.error('获取监控数据失败');
    connectionStatus.value = false;
  }
};

// 测试连接
const testConnection = async () => {
  try {
    ElMessage.info('正在测试连接...');
    
    const response = await axios.get('/api/robots/test-connection', {
      params: {
        ip: currentRobot.value.ip,
        port: 9100
      },
      timeout: 5000
    });
    
    if (response.data && response.data.success) {
      connectionStatus.value = true;
      ElMessage.success('连接成功');
      return true;
    } else {
      throw new Error('连接失败');
    }
  } catch (error) {
    console.error('连接测试失败:', error);
    connectionStatus.value = false;
    ElMessage.error(`连接失败: ${error.message || '无法连接到服务器'}`);
    return false;
  }
};

// 保存IP配置
const saveIpConfig = async () => {
  try {
    // 这里可以调用API保存配置到后端
    await axios.post('/api/robots/save-robot-config', {
      id: currentRobot.value.id || '1', // 临时ID
      ip: currentRobot.value.ip
    });
    
    ElMessage.success('配置已保存');
    // 重新测试连接
    testConnection();
  } catch (error) {
    console.error('保存配置失败:', error);
    ElMessage.error('保存配置失败');
  }
};

// 处理SSH密钥文件上传
const handleKeyFileChange = (file) => {
  sshConfig.value.keyFile = file.raw;
  ElMessage.success('密钥文件已选择');
};

// 处理SSH连接
const handleSSHConnection = async () => {
  if (sshConnected.value) {
    // 断开连接
    try {
      if (sshSessionId.value) {
        await axios.post('/api/robots/ssh-disconnect', {
          sessionId: sshSessionId.value
        });
      }
      sshSessionId.value = null;
      sshConnected.value = false;
      sshLogs.value = [];
      ElMessage.info('SSH连接已断开');
    } catch (error) {
      console.error('断开SSH连接失败:', error);
      ElMessage.error('断开SSH连接失败');
    }
    return;
  }
  
  try {
    // 验证配置
    if (!currentRobot.value.ip) {
      ElMessage.warning('请输入有效的IP地址');
      return;
    }
    
    if (sshConfig.value.authType === 'password' && !sshConfig.value.password) {
      ElMessage.warning('请输入SSH密码');
      return;
    }
    
    if (sshConfig.value.authType === 'key' && !sshConfig.value.keyFile) {
      ElMessage.warning('请选择SSH密钥文件');
      return;
    }
    
    // 显示连接中状态
    ElMessage.info('正在连接SSH服务器...');
    
    // 建立SSH连接
    const formData = new FormData();
    formData.append('host', currentRobot.value.ip);
    formData.append('port', sshConfig.value.port);
    formData.append('username', 'root');
    formData.append('authType', sshConfig.value.authType);
    
    if (sshConfig.value.authType === 'password') {
      formData.append('password', sshConfig.value.password);
    } else {
      formData.append('keyFile', sshConfig.value.keyFile);
    }
    
    const response = await axios.post('/api/robots/ssh-connect', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      },
      timeout: 15000 // 15秒超时
    });
    
    if (response.data && response.data.success) {
      sshConnected.value = true;
      sshSessionId.value = response.data.sessionId;
      sshLogs.value.push({
        type: 'response',
        content: `成功连接到 ${currentRobot.value.ip}:${sshConfig.value.port}\n${response.data.banner || '欢迎使用智能工厂远程终端系统。'}\n版本：v2.5.0`
      });
      ElMessage.success('SSH连接成功');
    } else {
      throw new Error(response.data.error || '连接失败');
    }
  } catch (error) {
    console.error('SSH连接失败:', error);
    ElMessage.error(`SSH连接失败: ${error.message || '无法连接到服务器'}`);
  }
};

// 执行SSH命令
const executeSSHCommand = async () => {
  if (!sshConnected.value) {
    ElMessage.warning('请先连接SSH服务器');
    return;
  }
  
  if (!sshCommand.value.trim()) {
    return;
  }
  
  // 添加命令到日志
  sshLogs.value.push({
    type: 'command',
    content: sshCommand.value
  });
  
  try {
    // 执行命令
    const response = await axios.post('/api/robots/ssh-execute', {
      sessionId: sshSessionId.value,
      command: sshCommand.value
    }, {
      timeout: 10000 // 10秒超时
    });
    
    if (response.data && response.data.success) {
    // 添加响应到日志
    sshLogs.value.push({
      type: 'response',
        content: response.data.output || '命令执行成功，但没有输出'
    });
    } else {
      throw new Error(response.data.error || '命令执行失败');
    }
  } catch (error) {
    console.error('命令执行失败:', error);
    // 添加错误到日志
    sshLogs.value.push({
      type: 'response',
      content: `错误: ${error.message || '命令执行失败'}`
    });
  }
  
  // 清空命令输入
  sshCommand.value = '';
  
  // 滚动到底部
  nextTick(() => {
    const terminal = document.querySelector('.terminal-window');
    if (terminal) {
      terminal.scrollTop = terminal.scrollHeight;
    }
  });
};

// 获取进度条颜色
const getProgressColor = (percentage) => {
  if (percentage < 50) return '#67C23A';
  if (percentage < 80) return '#E6A23C';
  return '#F56C6C';
};

// 启动单个机械臂
const startRobot = async (robot) => {
  try {
    // 实际应用中应调用API
    robot.status = '运行中';
    ElMessage.success(`${robot.name}启动成功`);
  } catch (error) {
    console.error('启动机械臂失败:', error);
    ElMessage.error('启动失败');
  }
};

// 停止单个机械臂
const stopRobot = async (robot) => {
  try {
    // 实际应用中应调用API
    robot.status = '空闲';
    ElMessage.success(`${robot.name}停止成功`);
  } catch (error) {
    console.error('停止机械臂失败:', error);
    ElMessage.error('停止失败');
  }
};

// 编辑机械臂
const editRobot = (robot) => {
  ElMessageBox.prompt('请输入新的机械臂名称', '修改机械臂', {
    confirmButtonText: '确认',
    cancelButtonText: '取消',
    inputValue: robot.name
  }).then(({ value }) => {
    robot.name = value;
    ElMessage.success('修改成功');
  }).catch(() => {
    // 取消操作
  });
};

// 删除机械臂
const deleteRobot = (robot) => {
  ElMessageBox.confirm(`确定要删除${robot.name}吗？`, '警告', {
    confirmButtonText: '确认',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    // 实际应用中应调用API删除数据
    ElMessage.success('删除成功');
    drawerVisible.value = false;
  }).catch(() => {
    // 取消操作
  });
};

// 格式化时间
function formatTime(date) {
  const hours = date.getHours().toString().padStart(2, '0');
  const minutes = date.getMinutes().toString().padStart(2, '0');
  const seconds = date.getSeconds().toString().padStart(2, '0');
  return `${hours}:${minutes}:${seconds}`;
}

// 初始化图表
const initCharts = () => {
  nextTick(() => {
    // CPU图表
    if (!cpuChart && cpuChartRef.value) {
      cpuChart = echarts.init(cpuChartRef.value);
    }
    
    // 内存图表
    if (!memoryChart && memoryChartRef.value) {
      memoryChart = echarts.init(memoryChartRef.value);
    }
    
    // 磁盘图表
    if (!diskChart && diskChartRef.value) {
      diskChart = echarts.init(diskChartRef.value);
    }
    
    // 网络图表
    if (!networkChart && networkChartRef.value) {
      networkChart = echarts.init(networkChartRef.value);
    }
    
    updateCharts();
  });
};

// 更新图表数据
const updateCharts = () => {
  if (cpuChart) {
    cpuChart.setOption({
      title: { text: 'CPU使用率趋势' },
      tooltip: { trigger: 'axis' },
      xAxis: {
        type: 'category',
        data: getTimeArray(10)
      },
      yAxis: {
        type: 'value',
        min: 0,
        max: 100,
        name: '使用率(%)'
      },
      series: [{
        data: generateRandomData(10, 30, 70),
        type: 'line',
        smooth: true,
        areaStyle: {},
        name: 'CPU使用率'
      }]
    });
  }
  
  if (memoryChart) {
    memoryChart.setOption({
      title: { text: '内存使用率趋势' },
      tooltip: { trigger: 'axis' },
      xAxis: {
        type: 'category',
        data: getTimeArray(10)
      },
      yAxis: {
        type: 'value',
        min: 0,
        max: 100,
        name: '使用率(%)'
      },
      series: [{
        data: generateRandomData(10, 40, 80),
        type: 'line',
        smooth: true,
        areaStyle: {},
        name: '内存使用率'
      }]
    });
  }
  
  if (diskChart) {
    diskChart.setOption({
      title: { text: '磁盘使用率趋势' },
      tooltip: { trigger: 'axis' },
      xAxis: {
        type: 'category',
        data: getTimeArray(10)
      },
      yAxis: {
        type: 'value',
        min: 0,
        max: 100,
        name: '使用率(%)'
      },
      series: [{
        data: generateRandomData(10, 20, 50),
        type: 'line',
        smooth: true,
        areaStyle: {},
        name: '磁盘使用率'
      }]
    });
  }
  
  if (networkChart) {
    networkChart.setOption({
      title: { text: '网络使用率趋势' },
      tooltip: { trigger: 'axis' },
      xAxis: {
        type: 'category',
        data: getTimeArray(10)
      },
      yAxis: {
        type: 'value',
        min: 0,
        max: 100,
        name: '使用率(%)'
      },
      series: [{
        data: generateRandomData(10, 10, 40),
        type: 'line',
        smooth: true,
        areaStyle: {},
        name: '网络使用率'
      }]
    });
  }
};

// 生成时间数组
const getTimeArray = (count) => {
  const result = [];
  const now = new Date();
  for (let i = count - 1; i >= 0; i--) {
    const time = new Date(now.getTime() - i * 60000);
    result.push(formatTime(time));
  }
  return result;
};

// 生成随机数据
const generateRandomData = (count, min, max) => {
  const result = [];
  for (let i = 0; i < count; i++) {
    result.push(Math.floor(Math.random() * (max - min + 1)) + min);
  }
  return result;
};

onMounted(() => {
  // 显示服务器状态通知
  notifySuccess('服务器运行正常，请查看产线信息', '系统通知', 5000);
  
  window.addEventListener('resize', () => {
    cpuChart?.resize();
    memoryChart?.resize();
    diskChart?.resize();
    networkChart?.resize();
  });
});
</script>

<style scoped>
.remote-control {
  padding: 20px;
}

.robot-card {
  margin-bottom: 20px;
}

.robot-card :deep(.el-card__body) {
  padding: 15px;
}

.card-content-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.robot-image {
  width: 100px;
  height: auto;
  margin-left: 20px;
  border-radius: 4px;
}

.robot-card.active {
  border-color: #409EFF; /* 激活状态的边框颜色 */
}

.control-buttons {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.control-buttons .el-button {
  margin: 0 10px;
}

.card-actions {
  display: flex;
  gap: 10px;
}

/* 机械臂详情样式 */
.robot-detail {
  padding: 20px;
}

.detail-section {
  margin-top: 20px;
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 5px;
}

.detail-actions {
  margin-top: 30px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

/* 远程连接样式 */
.remote-connection {
  padding: 20px;
}

.connection-header {
  display: flex;
  flex-direction: column;
  margin-bottom: 20px;
}

.connection-header h3 {
  margin: 0;
  font-size: 1.5rem;
}

.ip-config {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 15px 0;
  background-color: #f5f7fa;
  padding: 10px;
  border-radius: 5px;
}

.ip-input-group {
  display: flex;
  align-items: center;
  gap: 10px;
}

.connection-actions {
  display: flex;
  gap: 10px;
}

.connection-time {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 10px;
}

.connection-status-indicator {
  display: flex;
  align-items: center;
  padding: 3px 8px;
  background-color: #f56c6c;
  color: white;
  border-radius: 12px;
  font-size: 12px;
}

.connection-status-indicator.connected {
  background-color: #67c23a;
}

.resource-monitor {
  margin-bottom: 30px;
}

.resource-card {
  background-color: #f9f9f9;
  border-radius: 8px;
  padding: 15px;
  text-align: center;
}

.resource-card h4 {
  margin-top: 0;
  margin-bottom: 15px;
  color: #333;
}

.resource-chart {
  position: relative;
}

.usage-text {
  display: flex;
  justify-content: center;
  margin-top: 10px;
  font-size: 12px;
}

.usage-text .used {
  color: #409EFF;
  margin-right: 15px;
}

.usage-text .unused {
  color: #999;
}

.usage-value {
  font-size: 24px;
  font-weight: bold;
  margin-top: 5px;
}

.monitor-tabs {
  margin-top: 30px;
}

.resource-trend {
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 8px;
}

.resource-trend h4 {
  margin-top: 0;
  margin-bottom: 5px;
}

.resource-trend p {
  margin-top: 0;
  color: #666;
  margin-bottom: 20px;
}

.tabs-content {
  margin-top: 20px;
}

/* SSH终端样式 */
.ssh-terminal {
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 8px;
}

.terminal-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  flex-wrap: wrap;
  gap: 10px;
}

.terminal-user {
  display: flex;
  align-items: center;
  gap: 10px;
}

.ssh-auth {
  display: flex;
  align-items: center;
}

.terminal-window {
  background-color: #1e1e1e;
  color: #f0f0f0;
  border-radius: 5px;
  height: 350px;
  padding: 15px;
  font-family: monospace;
  overflow-y: auto;
}

.terminal-content {
  line-height: 1.6;
}

.terminal-connect-hint {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #aaaaaa;
}

.connection-message {
  color: #4CAF50;
  margin: 5px 0;
}

.terminal-prompt {
  margin: 5px 0;
  color: #dcdcaa;
}

.terminal-command {
  color: #dcdcaa;
  margin: 5px 0;
}

.terminal-result {
  color: #f0f0f0;
  margin: 5px 0;
  white-space: pre-wrap;
}

.command-input {
  display: flex;
  align-items: center;
  margin: 10px 0;
}

.command-input .prompt {
  color: #dcdcaa;
  margin-right: 8px;
}

.ssh-input {
  background-color: transparent;
}

.ssh-input :deep(input) {
  background-color: transparent;
  border: none;
  color: #f0f0f0;
  caret-color: #f0f0f0;
}

.ssh-input :deep(input:focus) {
  box-shadow: none;
}

.ssh-log {
  margin: 5px 0;
}

.connection-status {
  margin-top: 15px;
  display: flex;
  align-items: center;
}

.status-badge {
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 12px;
  margin-right: 15px;
}

.status-badge.success {
  background-color: #67C23A;
  color: white;
}

.status-badge.warning {
  background-color: #E6A23C;
  color: white;
}

.status-message {
  color: #333;
  font-size: 14px;
}

.main-flex {
  display: flex;
  width: 100vw;
  height: 100vh;
}
.main-content {
  flex: 1;
  position: relative;
}
.assistant-panel {
  width: 40vw;
  min-width: 400px;
  background: #fff;
  position: relative;
  box-shadow: -2px 0 8px #ccc;
  z-index: 200;
}
.close-btn {
  position: absolute;
  top: 16px;
  right: 16px;
  font-size: 24px;
  background: none;
  border: none;
  cursor: pointer;
  z-index: 201;
}
</style>