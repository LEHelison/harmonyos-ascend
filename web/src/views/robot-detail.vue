<template>
  <div class="robot-detail-flex">
    <div class="robot-detail-main">
      <h2>{{ robotName }} 资源监控</h2>
      <el-row :gutter="20">
        <el-col :span="6"><ResourceCard title="CPU" :value="metrics.cpu" unit="%" /></el-col>
        <el-col :span="6"><ResourceCard title="内存" :value="metrics.memory" unit="%" /></el-col>
        <el-col :span="6"><ResourceCard title="磁盘" :value="metrics.disk" unit="%" /></el-col>
        <el-col :span="6"><ResourceCard title="网络" :value="metrics.network" unit="%" /></el-col>
      </el-row>
      <el-card style="margin-top: 20px;">
        <h3>告警信息</h3>
        <el-alert
          v-for="alert in alerts"
          :key="alert.id"
          :title="alert.message"
          type="error"
          show-icon
          style="margin-bottom: 10px;"
        />
      </el-card>
      <el-card style="margin-top: 20px;">
        <h3>资源趋势</h3>
        <v-chart :option="trendOptions" style="height:300px;" />
      </el-card>
    </div>
    <img src="@/assets/imgs/arm.png" alt="机械臂" class="robot-detail-image" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'
import ResourceCard from '../components/ResourceCard.vue'
import VChart from 'vue-echarts'

const route = useRoute()
const robotName = ref(route.query.name || '未知设备')
const ip = ref(route.query.ip || '')
const metrics = ref({ cpu: 0, memory: 0, disk: 0, network: 0 })
const alerts = ref([])
const trendOptions = ref({})

const fetchMetrics = async () => {
  try {
    const res = await axios.get('/api/robots/monitor/metrics', { params: { ip: ip.value } })
    if (res.data && res.data.metrics) {
      metrics.value = res.data.metrics
      // 这里可以根据阈值生成告警
      alerts.value = []
      if (metrics.value.cpu > 80) alerts.value.push({ id: 1, message: 'CPU使用率过高' })
      if (metrics.value.memory > 80) alerts.value.push({ id: 2, message: '内存使用率过高' })
      if (metrics.value.disk > 90) alerts.value.push({ id: 3, message: '磁盘使用率过高' })
    }
    // 资源趋势图表数据
    trendOptions.value = {
      tooltip: { trigger: 'axis' },
      legend: { data: ['CPU', '内存', '磁盘', '网络'] },
      xAxis: { type: 'category', data: res.data.trend?.timestamps || [] },
      yAxis: { type: 'value', min: 0, max: 100 },
      series: [
        { name: 'CPU', type: 'line', data: res.data.trend?.cpu || [] },
        { name: '内存', type: 'line', data: res.data.trend?.memory || [] },
        { name: '磁盘', type: 'line', data: res.data.trend?.disk || [] },
        { name: '网络', type: 'line', data: res.data.trend?.network || [] }
      ]
    }
  } catch (e) {
    alerts.value = [{ id: 99, message: '资源监控数据获取失败' }]
  }
}

onMounted(() => {
  fetchMetrics()
  setInterval(fetchMetrics, 10000) // 每10秒刷新一次
})
</script>

<style scoped>
.robot-detail-flex {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
}
.robot-detail-main {
  flex: 1;
}
.robot-detail-image {
  width: 220px;
  height: auto;
  margin-left: 40px;
  margin-top: 30px;
  border-radius: 8px;
  box-shadow: 0 2px 8px #eee;
}
</style> 