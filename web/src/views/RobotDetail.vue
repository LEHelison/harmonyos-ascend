<template>
  <div class="robot-detail-page">
    <div class="page-header">
      <h2>设备详情</h2>
      <el-button @click="goBack" icon="ArrowLeft">返回</el-button>
    </div>

    <el-card class="detail-card">
      <div class="detail-flex-wrap">
        <div class="detail-main-content">
          <div class="robot-info">
            <h3>{{ robotName }}</h3>
            <el-tag :type="robotStatus === '运行中' ? 'success' : 'info'">{{ robotStatus }}</el-tag>
          </div>

          <el-divider content-position="left">基本信息</el-divider>
          <div class="basic-info">
            <div class="info-item">
              <span class="label">处理器：</span>
              <span class="value">Intel i5-10400 2.9GHz</span>
            </div>
            <div class="info-item">
              <span class="label">内存：</span>
              <span class="value">16GB DDR4</span>
            </div>
            <div class="info-item">
              <span class="label">存储：</span>
              <span class="value">512GB SSD</span>
            </div>
            <div class="info-item">
              <span class="label">IP地址：</span>
              <span class="value">{{ robotIp }}</span>
            </div>
          </div>

          <el-divider content-position="left">资源监控
            <el-button size="small" type="primary" icon="Refresh" circle 
              @click="refreshData" :loading="loading" style="margin-left: 10px;">
            </el-button>
            <span class="update-time">{{ lastUpdateTime }}</span>
          </el-divider>
          
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

          <div class="action-buttons">
            <el-button type="primary" @click="remoteConnect">远程连接</el-button>
            <el-button type="success" @click="startRobot" :disabled="robotStatus === '运行中'">启动</el-button>
            <el-button type="danger" @click="stopRobot" :disabled="robotStatus === '空闲'">停止</el-button>
            <el-button type="warning" @click="editRobot">修改</el-button>
            <el-button type="info" @click="deleteRobot">删除</el-button>
          </div>
        </div>
        <img src="@/assets/imgs/arm.png" alt="机械臂" class="robot-detail-image" />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, onUnmounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import { ArrowLeft, Refresh } from '@element-plus/icons-vue';
import * as echarts from 'echarts';
import axios from 'axios';
import { notifySuccess } from '../utils/alertNotificationManager';

const route = useRoute();
const router = useRouter();

// 从路由参数获取机器人信息
const robotName = ref(route.query.name || '未知设备');
const robotStatus = ref(route.query.status || '空闲');
const robotIp = ref(route.query.ip || '192.168.1.1');

// 最后更新时间
const lastUpdateTime = ref(formatTime(new Date()));
const loading = ref(false);

// 资源使用率数据
const cpuUsage = ref(42);
const memoryUsage = ref(52);
const diskUsage = ref(32);
const networkUsage = ref(22);
const resourceTab = ref('cpu');

// 图表引用
const cpuChartRef = ref(null);
const memoryChartRef = ref(null);
const diskChartRef = ref(null);
const networkChartRef = ref(null);

// 图表实例和数据
let cpuChart = null;
let memoryChart = null;
let diskChart = null;
let networkChart = null;

// CPU数据历史记录
const cpuData = ref([]);
const memoryData = ref([]);
const diskData = ref([]);
const networkData = ref([]);
const timeData = ref([]);

// 刷新间隔
let refreshTimer = null;

// 返回上一页
const goBack = () => {
  router.back();
};

// 获取进度条颜色
const getProgressColor = (percentage) => {
  if (percentage < 50) return '#67C23A';
  if (percentage < 80) return '#E6A23C';
  return '#F56C6C';
};

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
        data: timeData.value,
        boundaryGap: false
      },
      yAxis: {
        type: 'value',
        min: 0,
        max: 100,
        name: '使用率(%)'
      },
      series: [{
        data: cpuData.value,
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
        data: timeData.value,
        boundaryGap: false
      },
      yAxis: {
        type: 'value',
        min: 0,
        max: 100,
        name: '使用率(%)'
      },
      series: [{
        data: memoryData.value,
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
        data: timeData.value,
        boundaryGap: false
      },
      yAxis: {
        type: 'value',
        min: 0,
        max: 100,
        name: '使用率(%)'
      },
      series: [{
        data: diskData.value,
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
        data: timeData.value,
        boundaryGap: false
      },
      yAxis: {
        type: 'value',
        min: 0,
        max: 100,
        name: '使用率(%)'
      },
      series: [{
        data: networkData.value,
        type: 'line',
        smooth: true,
        areaStyle: {},
        name: '网络使用率'
      }]
    });
  }
};

// 刷新数据
const refreshData = async () => {
  loading.value = true;
  try {
    // 模拟API调用获取最新资源使用数据
    await new Promise(r => setTimeout(r, 1000)); // 模拟网络延迟
    
    // 获取随机数据模拟资源变化
    const newCpuUsage = Math.floor(Math.random() * 60) + 20; // 20-80%之间
    const newMemoryUsage = Math.floor(Math.random() * 40) + 40; // 40-80%之间
    const newDiskUsage = Math.floor(Math.random() * 20) + 30; // 30-50%之间
    const newNetworkUsage = Math.floor(Math.random() * 30) + 10; // 10-40%之间
    
    // 更新资源数据
    cpuUsage.value = newCpuUsage;
    memoryUsage.value = newMemoryUsage;
    diskUsage.value = newDiskUsage;
    networkUsage.value = newNetworkUsage;
    
    // 更新时间数据
    const now = new Date();
    const timeString = now.getHours() + ':' + String(now.getMinutes()).padStart(2, '0') + ':' + String(now.getSeconds()).padStart(2, '0');
    timeData.value.push(timeString);
    if (timeData.value.length > 10) timeData.value.shift(); // 只保留最近10个时间点
    
    // 更新各个图表的数据
    cpuData.value.push(newCpuUsage);
    if (cpuData.value.length > 10) cpuData.value.shift();
    
    memoryData.value.push(newMemoryUsage);
    if (memoryData.value.length > 10) memoryData.value.shift();
    
    diskData.value.push(newDiskUsage);
    if (diskData.value.length > 10) diskData.value.shift();
    
    networkData.value.push(newNetworkUsage);
    if (networkData.value.length > 10) networkData.value.shift();
    
    // 更新图表
    updateCharts();
    
    // 更新最后刷新时间
    lastUpdateTime.value = formatTime(now);
    
    notifySuccess('数据已刷新', '资源监控', 2000);
  } catch (error) {
    console.error('刷新数据失败:', error);
    ElMessage.error('刷新数据失败');
  } finally {
    loading.value = false;
  }
};

// 格式化时间
function formatTime(date) {
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  });
}

// 远程连接
const remoteConnect = () => {
  router.push({
    path: '/framework/remote-connection',
    query: {
      name: robotName.value,
      ip: robotIp.value
    }
  });
};

// 启动机器人
const startRobot = () => {
  ElMessage.success(`已启动 ${robotName.value}`);
  robotStatus.value = '运行中';
};

// 停止机器人
const stopRobot = () => {
  ElMessage.success(`已停止 ${robotName.value}`);
  robotStatus.value = '空闲';
};

// 编辑机器人
const editRobot = () => {
  ElMessage.info('编辑功能开发中');
};

// 删除机器人
const deleteRobot = () => {
  ElMessage.warning('删除功能开发中');
};

onMounted(() => {
  // 初始化图表
  initCharts();
  
  // 首次加载数据
  refreshData();
  
  // 设置定时刷新 (每30秒)
  refreshTimer = setInterval(refreshData, 30000);
});

onUnmounted(() => {
  // 清除定时器
  if (refreshTimer) {
    clearInterval(refreshTimer);
  }
  
  // 销毁图表实例
  if (cpuChart) cpuChart.dispose();
  if (memoryChart) memoryChart.dispose();
  if (diskChart) diskChart.dispose();
  if (networkChart) networkChart.dispose();
});
</script>

<style scoped>
.robot-detail-page {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.detail-card {
  margin-bottom: 20px;
}

.detail-flex-wrap {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
}
.detail-main-content {
  flex: 1;
}
.robot-detail-image {
  width: 220px;
  height: auto;
  margin-left: 1px;
  margin-top: 100px;
  border-radius: 8px;
  box-shadow: 0 2px 8px #eee;
}

.robot-info {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}

.robot-info h3 {
  margin: 0;
  margin-right: 10px;
}

.basic-info {
  margin-bottom: 20px;
}

.info-item {
  margin-bottom: 10px;
  display: flex;
}

.info-item .label {
  font-weight: bold;
  width: 100px;
}

.resource-monitor {
  margin-bottom: 30px;
}

.resource-card {
  background-color: #f9f9f9;
  border-radius: 8px;
  padding: 15px;
  text-align: center;
  height: 100%;
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

.update-time {
  font-size: 12px;
  color: #909399;
  margin-left: 10px;
}

.action-buttons {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-top: 20px;
}
</style> 