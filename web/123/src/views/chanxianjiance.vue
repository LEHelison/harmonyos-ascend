<template>
  <div class="monitor-center">
    <h1 style="margin-top: -25px;">工厂检测</h1>
    <div class="filter-bar">
      <el-tabs v-model="activeTab">
        <el-tab-pane label="环境监控" name="environment"></el-tab-pane>
        <el-tab-pane label="生产数据" name="production"></el-tab-pane>
      </el-tabs>
      <div class="filters">
        <el-select v-model="selectedFactory" placeholder="所有厂区">
          <el-option label="所有厂区" value="all"></el-option>
          <el-option v-for="factory in factories" :key="factory.id" :label="factory.name"
            :value="factory.id"></el-option>
        </el-select>
        <el-date-picker v-model="selectedDate" type="date" placeholder="选择日期"></el-date-picker>
      </div>
    </div>

    <!-- 环境监控内容 -->
    <div v-if="activeTab === 'environment'">


      <!-- 厂区状态卡片 -->
      <el-row :gutter="20">
        <el-col :span="8" v-for="factory in displayedFactories" :key="factory.id">
          <el-card :class="['factory-card', factory.status]" @click="navigateToFactoryDetail(factory.id)">
            <div class="factory-header">
              <span style="margin-right: 20px;">{{ factory.name }}</span>
              <el-tag
                :type="factory.status === 'normal' ? 'success' : factory.status === 'alert' ? 'warning' : 'danger'">{{
                  factory.statusLabel }}</el-tag>
            </div>
            <p>最后更新: {{ factory.lastUpdated }}</p>
            <div class="factory-data">
              <div class="factory-data-grid">
                <div class="data-item">
                  <span class="data-value">{{ factory.temperature }}°C</span>
                  <div class="data-label">温度</div>
                </div>
                <div class="data-item">
                  <span class="data-value">{{ factory.humidity }}%</span>
                  <div class="data-label">湿度</div>
                </div>
                <div class="data-item">
                  <span class="data-value">{{ Number(factory.pm25).toFixed(1) }} μg/m³</span>
                  <div class="data-label">PM2.5</div>
                </div>
                <div class="data-item">
                  <span class="data-value">{{ Number(factory.noise).toFixed(1) }} dB</span>
                  <div class="data-label">噪音</div>
                </div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
      <!-- 静态温湿度折线图 -->
      <div style="display: flex; gap: 20px; margin-top: 30px;">
        <div id="tempChart" style="width: 48%; height: 300px; background: #fff; border-radius: 10px;"></div>
        <div id="humiChart" style="width: 48%; height: 300px; background: #fff; border-radius: 10px;"></div>
      </div>
    </div>

    <!-- 生产数据内容 -->
    <div v-if="activeTab === 'production'">
      <!-- 总生产数、合格品数、残次品数与残次品率 -->
      <el-row :gutter="20">
        <el-col :span="8">
          <el-card class="stats-card">
            <div class="card-header">
              <span>总生产数</span>
            </div>
            <div class="card-content">
              <span class="large-number">{{ totalProductionCard }}</span>
              <br>
              <small>近7天生产总量</small>
            </div>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card class="stats-card">
            <div class="card-header">
              <span>合格品数</span>
            </div>
            <div class="card-content">
              <span class="large-number">{{ qualifiedProductsCard }}</span>
              <br>
              <small>近7天合格品总量</small>
            </div>
          </el-card>
        </el-col>
        <el-col :span="8">
          <el-card class="stats-card">
            <div class="card-header">
              <span>残次品数与残次品率</span>
            </div>
            <div class="card-content">
              <span class="large-number">{{ defectiveProductsCard }}</span>
              <p style="margin-top: -20px; font-size: 16px; color: red; margin-bottom: -40px;">{{ averageDefectRateCard
              }}%</p>
              <small> 近7天残次品量与平均残次品率</small>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <!-- 生产数据统计与残次品率趋势折线图 -->
      <div style="display: flex; gap: 20px; margin-top: 30px;">
        <div style="width: 48%; background: #fff; border-radius: 10px; padding: 20px 10px 10px 10px;">
          <div style="font-size: 28px; font-weight: bold; margin-bottom: -10px;">生产数据统计</div>
          <div id="productionChart" style="width: 100%; height: 300px;"></div>
        </div>
        <div style="width: 48%; background: #fff; border-radius: 10px; padding: 20px 10px 10px 10px;">
          <div style="font-size: 28px; font-weight: bold; margin-bottom: -10px;">残次品率趋势</div>
          <div id="defectRateChart" style="width: 100%; height: 300px;"></div>
        </div>
      </div>

      <!-- 操作按钮 -->
      <div style="text-align: right; margin-top: 20px;">
        <el-button type="primary" @click="generateReport">生成详细报表</el-button>
        <el-button type="info" @click="exportData">导出数据</el-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch, nextTick, onUnmounted } from 'vue';
import { ElTabs, ElTabPane, ElSelect, ElOption, ElDatePicker, ElAlert, ElRow, ElCol, ElCard, ElTag, ElMessage } from 'element-plus';
import { useRouter } from 'vue-router';
import axios from 'axios';
import * as echarts from 'echarts';

const router = useRouter();

// 静态工厂数据（卡片用）
const factories = ref([
  { id: 1, name: '厂区一', status: 'normal', statusLabel: '正常', lastUpdated: '2025/4/17 15:29:07', temperature: 30.5, humidity: 55, pm25: 0, noise: 0 },
  { id: 2, name: '厂区二', status: 'normal', statusLabel: '正常', lastUpdated: '2025/4/17 15:29:07', temperature: 28.2, humidity: 60, pm25: 0, noise: 0 },
  { id: 3, name: '厂区三', status: 'alert', statusLabel: '警告', lastUpdated: '2025/4/17 15:29:07', temperature: 32.8, humidity: 70, pm25: 0, noise: 0 }
]);

const activeTab = ref('environment');
const selectedFactory = ref('all');
const selectedDate = ref(null);
const loading = ref(false);

const environmentWarning = ref('厂区三 - 温度过高');
const environmentAlert = ref('厂区五 - 温度过高，湿度过高');

const displayedFactories = computed(() => {
  if (selectedFactory.value === 'all') {
    return factories.value;
  } else {
    return factories.value.filter(factory => factory.id === parseInt(selectedFactory.value));
  }
});

// ECharts 实例ref
const tempChartRef = ref(null);
const humiChartRef = ref(null);
const productionChartRef = ref(null);
const defectRateChartRef = ref(null);

// 静态温湿度数据
const tempData = ref([31, 30.6, 31.2, 31.7, 32, 32.3, 32.5, 32.4, 33, 33.4, 33.9, 33.9, 33.2, 32.9, 33.8, 33.2, 33.7, 33.4]);
const humiData = ref([54, 56, 58, 59, 60, 60, 61, 60, 61, 62, 65, 63, 62, 61, 63, 60, 61, 55]);
const timeData = ref([
  '2025/5/7 14:04:11', '2025/5/7 15:04:11', '2025/5/7 16:04:11', '2025/5/7 17:04:11', '2025/5/7 18:04:11',
  '2025/5/7 19:04:11', '2025/5/7 20:04:11', '2025/5/7 21:04:11', '2025/5/7 22:04:11', '2025/5/8 00:04:11',
  '2025/5/8 04:04:11', '2025/5/8 06:04:11', '2025/5/8 08:04:11', '2025/5/8 09:04:11', '2025/5/8 10:04:11',
  '2025/5/8 11:04:11', '2025/5/8 12:04:11', '2025/5/8 13:04:11'
]);

// 生产数据静态数据
const prodTime = ref([]);
const prodTotal = ref([]);
const prodQualified = ref([]);
const prodDefect = ref([]);
const prodDefectRate = ref([]);

const totalProductionCard = ref(0);
const qualifiedProductsCard = ref(0);
const defectiveProductsCard = ref(0);
const averageDefectRateCard = ref(0);

let timer = null;

function getNextTimeStr(lastTimeStr, type = 'env') {
  // type: 'env' or 'prod'
  const date = new Date(lastTimeStr.replace(/-/g, '/'));
  if (type === 'env') {
    date.setHours(date.getHours() + 1);
    return date.toISOString().slice(0, 19).replace('T', ' ');
  } else {
    date.setDate(date.getDate() + 1);
    return date.toISOString().slice(0, 10);
  }
}

function randomFloat(base, range) {
  return parseFloat((base + (Math.random() - 0.5) * range).toFixed(1));
}

function randomInt(base, range) {
  return Math.round(base + (Math.random() - 0.5) * range);
}

function updateChartsData() {
  // 环境监控
  const lastEnvTime = timeData.value[timeData.value.length - 1];
  timeData.value.push(getNextTimeStr(lastEnvTime, 'env'));
  tempData.value.push(randomFloat(tempData.value[tempData.value.length - 1], 0.5));
  humiData.value.push(randomFloat(humiData.value[humiData.value.length - 1], 1));
  if (timeData.value.length > 18) {
    timeData.value.shift();
    tempData.value.shift();
    humiData.value.shift();
  }

  // 生产数据动态更新
  if (activeTab.value === 'production') {
    const lastProdTime = prodTime.value[prodTime.value.length - 1];
    const newTime = getNextTimeStr(lastProdTime, 'prod');
    prodTime.value.push(newTime);

    // 生成新的生产数据
    const newTotal = randomInt(100, 50); // 总生产数在50-150之间
    const newQualified = Math.max(newTotal - randomInt(20, 10), 0); // 合格品数
    const newDefect = newTotal - newQualified; // 残次品数
    const newDefectRate = parseFloat(((newDefect / newTotal) * 100).toFixed(2)); // 残次品率

    // 更新数据数组
    prodTotal.value.push(newTotal);
    prodQualified.value.push(newQualified);
    prodDefect.value.push(newDefect);
    prodDefectRate.value.push(newDefectRate);

    // 保持最近7条数据
    if (prodTime.value.length > 7) {
      prodTime.value.shift();
      prodTotal.value.shift();
      prodQualified.value.shift();
      prodDefect.value.shift();
      prodDefectRate.value.shift();
    }

    // 更新图表
    updateProductionCharts();
  }

  // 刷新图表
  if (activeTab.value === 'environment') {
    updateEnvironmentCharts();
  }
}

function updateEnvironmentCharts() {
  if (tempChartRef.value) {
    tempChartRef.value.setOption({
      xAxis: { data: timeData.value },
      series: [{ data: tempData.value }]
    });
  }
  if (humiChartRef.value) {
    humiChartRef.value.setOption({
      xAxis: { data: timeData.value },
      series: [{ data: humiData.value }]
    });
  }
}

function updateProductionCharts() {
  if (productionChartRef.value) {
    productionChartRef.value.setOption({
      xAxis: { data: prodTime.value },
      series: [
        { data: prodTotal.value },
        { data: prodQualified.value },
        { data: prodDefect.value }
      ]
    });
  }
  if (defectRateChartRef.value) {
    defectRateChartRef.value.setOption({
      xAxis: { data: prodTime.value },
      series: [{ data: prodDefectRate.value }]
    });
  }
}

// 初始化环境监控图表
function initEnvironmentCharts() {
  nextTick(() => {
    setTimeout(() => {
      // 温度
      const tempDom = document.getElementById('tempChart');
      if (tempDom) {
        if (tempChartRef.value) tempChartRef.value.dispose();
        tempChartRef.value = echarts.init(tempDom);
        tempChartRef.value.setOption({
          title: { text: '温度变化趋势', left: 'center' },
          tooltip: {
            trigger: 'axis',
            axisPointer: { type: 'line' },
            formatter: function (params) {
              const p = Array.isArray(params) ? params[0] : params;
              return `${p.name}<br/>温度: ${p.value}°C`;
            }
          },
          legend: { data: ['温度 (°C)'], top: 40 },
          xAxis: { type: 'category', data: timeData, axisLabel: { rotate: 30 } },
          yAxis: { type: 'value', name: '温度 (°C)', min: 30, max: 34 },
          series: [{
            name: '温度 (°C)',
            type: 'line',
            data: tempData,
            smooth: true,
            symbol: 'circle',
            itemStyle: { color: '#ff6688' },
            lineStyle: { color: '#ff6688' },
            areaStyle: { color: 'rgba(255,102,136,0.1)' }
          }]
        });
        tempChartRef.value.resize();
      }
    }, 100);
    setTimeout(() => {
      // 湿度
      const humiDom = document.getElementById('humiChart');
      if (humiDom) {
        if (humiChartRef.value) humiChartRef.value.dispose();
        humiChartRef.value = echarts.init(humiDom);
        humiChartRef.value.setOption({
          title: { text: '湿度变化趋势', left: 'center' },
          tooltip: {
            trigger: 'axis',
            axisPointer: { type: 'line' },
            formatter: function (params) {
              const p = Array.isArray(params) ? params[0] : params;
              return `${p.name}<br/>湿度: ${p.value}%`;
            }
          },
          legend: { data: ['湿度 (%)'], top: 40 },
          xAxis: { type: 'category', data: timeData, axisLabel: { rotate: 30 } },
          yAxis: { type: 'value', name: '湿度 (%)', min: 54, max: 66 },
          series: [{
            name: '湿度 (%)',
            type: 'line',
            data: humiData,
            smooth: true,
            symbol: 'circle',
            itemStyle: { color: '#3399ff' },
            lineStyle: { color: '#3399ff' },
            areaStyle: { color: 'rgba(51,153,255,0.1)' }
          }]
        });
        humiChartRef.value.resize();
      }
    }, 200);
  });
}

// 初始化生产数据图表
function initProductionCharts() {
  nextTick(() => {
    setTimeout(() => {
      // 生产数据统计
      const prodDom = document.getElementById('productionChart');
      if (prodDom) {
        if (productionChartRef.value) productionChartRef.value.dispose();
        productionChartRef.value = echarts.init(prodDom);
        productionChartRef.value.setOption({
          tooltip: { trigger: 'axis' },
          legend: {
            data: ['总生产数', '合格品数', '残次品数'],
            top: 10
          },
          grid: { left: 60, right: 20, top: 60, bottom: 40 },
          xAxis: {
            type: 'category',
            data: prodTime.value,
            axisLabel: { rotate: 0 }
          },
          yAxis: {
            type: 'value',
            name: '生产数量',
            min: 0,
            max: 200
          },
          series: [
            {
              name: '总生产数',
              type: 'line',
              data: prodTotal,
              smooth: true,
              symbol: 'circle',
              itemStyle: { color: '#7ee6e6' },
              lineStyle: { color: '#7ee6e6' },
              areaStyle: { color: 'rgba(126,230,230,0.08)' }
            },
            {
              name: '合格品数',
              type: 'line',
              data: prodQualified,
              smooth: true,
              symbol: 'circle',
              itemStyle: { color: '#5bb3ff' },
              lineStyle: { color: '#5bb3ff' },
              areaStyle: { color: 'rgba(91,179,255,0.08)' }
            },
            {
              name: '残次品数',
              type: 'line',
              data: prodDefect,
              smooth: true,
              symbol: 'circle',
              itemStyle: { color: '#ffb3c6' },
              lineStyle: { color: '#ffb3c6' },
              areaStyle: { color: 'rgba(255,179,198,0.08)' }
            }
          ]
        });
        productionChartRef.value.resize();
      }
    }, 100);
    setTimeout(() => {
      // 残次品率
      const defectDom = document.getElementById('defectRateChart');
      if (defectDom) {
        if (defectRateChartRef.value) defectRateChartRef.value.dispose();
        defectRateChartRef.value = echarts.init(defectDom);
        defectRateChartRef.value.setOption({
          tooltip: { trigger: 'axis' },
          legend: {
            data: ['残次品率 (%)'],
            top: 10
          },
          grid: { left: 60, right: 20, top: 60, bottom: 40 },
          xAxis: {
            type: 'category',
            data: prodTime,
            axisLabel: { rotate: 0 }
          },
          yAxis: {
            type: 'value',
            name: '残次品率 (%)',
            min: 2,
            max: 7
          },
          series: [
            {
              name: '残次品率 (%)',
              type: 'line',
              data: prodDefectRate,
              smooth: true,
              symbol: 'circle',
              itemStyle: { color: '#ffa726' },
              lineStyle: { color: '#ffa726', width: 4 },
              areaStyle: { color: 'rgba(255,167,38,0.08)' }
            }
          ]
        });
        defectRateChartRef.value.resize();
      }
    }, 200);
  });
}

// 监听 tab 切换
watch(activeTab, (val) => {
  if (val === 'environment') {
    initEnvironmentCharts();
  } else if (val === 'production') {
    initProductionCharts();
    fetchProductionData(); // 切换到生产数据tab时立即获取数据
  }
});

// 新增：获取生产数据
async function fetchProductionData() {
  try {
    const response = await axios.get('http://121.36.36.111:5006/inspections');
    const data = response.data;

    // 对数据按时间排序，确保最新数据在最后
    data.sort((a, b) => new Date(a.created_at).getTime() - new Date(b.created_at).getTime());

    // 取最近7条数据用于图表和卡片
    const recentData = data.slice(-7);

    prodTime.value = recentData.map(item => item.created_at.split(' ')[0]);
    prodTotal.value = recentData.map(item => item.qualified + item.defective);
    prodQualified.value = recentData.map(item => item.qualified);
    prodDefect.value = recentData.map(item => item.defective);
    prodDefectRate.value = recentData.map(item => parseFloat((100 - parseFloat(item.quality_rate)).toFixed(2)));

    // 计算卡片数据 (近7天总和/平均值)
    totalProductionCard.value = recentData.reduce((sum, item) => sum + item.qualified + item.defective, 0);
    qualifiedProductsCard.value = recentData.reduce((sum, item) => sum + item.qualified, 0);
    defectiveProductsCard.value = recentData.reduce((sum, item) => sum + item.defective, 0);

    const totalDefectRateSum = recentData.reduce((sum, item) => sum + (100 - parseFloat(item.quality_rate)), 0);
    averageDefectRateCard.value = recentData.length > 0 ? parseFloat((totalDefectRateSum / recentData.length).toFixed(2)) : 0;

    if (activeTab.value === 'production') {
      updateProductionCharts();
    }

  } catch (error) {
    console.error('获取生产数据失败:', error);
    if (error.response) {
      ElMessage.error('获取生产数据失败：' + (error.response.data.message || error.message));
    } else if (error.request) {
      ElMessage.error('获取生产数据失败：服务器无响应或网络错误，请检查后端服务和网络连接。');
    } else {
      ElMessage.error('获取生产数据失败：' + error.message);
    }
  }
}

// 新增：获取噪音数据
async function fetchNoiseData() {
  try {
    const response = await axios.get('http://192.168.31.30:5002/noise_data');
    const noiseData = response.data;
    // 如果接口返回 { NoiseVolume: xxx } 或 { factoryId: value }，都兼容
    let noiseValue = 0;
    if (typeof noiseData === 'object') {
      if ('NoiseVolume' in noiseData) {
        noiseValue = noiseData.NoiseVolume;
      } else {
        // 兼容多工厂格式
        const firstKey = Object.keys(noiseData)[0];
        noiseValue = noiseData[firstKey];
      }
    }
    // 分配到所有工厂
    factories.value.forEach(factory => {
      factory.noise = noiseValue;
    });
  } catch (error) {
    console.error('获取噪音数据失败:', error);
    if (error.request) {
      ElMessage.error('获取噪音数据失败：服务器无响应或网络错误，请检查后端服务和网络连接。');
    } else {
      ElMessage.error('获取噪音数据失败：' + error.message);
    }
  }
}

// 新增：获取 PM2.5 数据
async function fetchPM25Data() {
  try {
    const response = await axios.get('http://192.168.31.30:5002/pm25_data');
    const pm25Data = response.data;
    // 如果接口返回 { PM25Data: xxx } 或 { factoryId: value }，都兼容
    let pm25Value = 0;
    if (typeof pm25Data === 'object') {
      if ('PM25Data' in pm25Data) {
        pm25Value = pm25Data.PM25Data;
      } else {
        // 兼容多工厂格式
        const firstKey = Object.keys(pm25Data)[0];
        pm25Value = pm25Data[firstKey];
      }
    }
    // 分配到所有工厂
    factories.value.forEach(factory => {
      factory.pm25 = pm25Value;
    });
  } catch (error) {
    console.error('获取 PM2.5 数据失败:', error);
    if (error.request) {
      ElMessage.error('获取 PM2.5 数据失败：服务器无响应或网络错误，请检查后端服务和网络连接。');
    } else {
      ElMessage.error('获取 PM2.5 数据失败：' + error.message);
    }
  }
}

// 在 onMounted 中调用获取噪音数据和 PM2.5 数据
onMounted(() => {
  fetchNoiseData();
  fetchPM25Data();
  if (activeTab.value === 'environment') {
    initEnvironmentCharts();
  } else if (activeTab.value === 'production') {
    initProductionCharts();
    fetchProductionData(); // 初始加载时获取生产数据
  }
  timer = setInterval(() => {
    updateChartsData();
  }, 2000);
  // 新增：每5秒拉取一次PM2.5和噪音
  setInterval(() => {
    fetchNoiseData();
    fetchPM25Data();
  }, 5000);
  // 新增：每5秒拉取一次生产数据
  setInterval(() => {
    if (activeTab.value === 'production') {
      fetchProductionData();
    }
  }, 5000);
});

// 清理定时器
onUnmounted(() => {
  if (timer) clearInterval(timer);
});

// 操作按钮方法
const generateReport = () => {
  console.log('生成详细报表');
};

const exportData = () => {
  console.log('导出数据');
};

// 导航到厂区详情页
const navigateToFactoryDetail = (factoryId) => {
  router.push(`/factory-detail/${factoryId}`);
};
</script>

<style scoped>
.monitor-center {
  padding: 20px;
}

.filter-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.filters {
  display: flex;
  gap: 10px;
}

.factory-card {
  height: auto;
  min-height: 320px;
  padding: 12px 0 18px 0;
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.factory-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.factory-header {
  margin-bottom: 6px;
}

.card-content,
.factory-data,
.factory-data-grid {
  margin-top: 0;
  margin-bottom: 0;
}

.factory-data-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-gap: 8px 0;
  margin-top: 8px;
}

.factory-data-grid .data-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2px 0;
  margin-top: -30px;
}

.factory-data-grid .data-value {
  font-size: 18px;
  font-weight: bold;
  color: #409eff;
  margin-bottom: 0;
}

.factory-data-grid .data-label {
  font-size: 13px;
  color: #888;
  margin-top: 0;
}

.factory-info p,
.factory-info .data-label {
  margin-bottom: 0;
}

.environment-warning,
.environment-alert {
  margin-bottom: 20px;
}

.stats-card {
  text-align: center;
}

.card-header {
  font-size: 16px;
  color: #666;
  margin-bottom: 10px;
}

.card-content {
  padding: 10px 0;
}

.large-number {
  font-size: 36px;
  font-weight: bold;
  color: #409eff;
}
</style>