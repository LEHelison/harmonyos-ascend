<template>
  <div ref="chart" class="chart"></div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import * as echarts from 'echarts';

const props = defineProps({
  data: {
    type: Object,
    required: true
  },
  options: {
    type: Object,
    default: () => ({})
  }
});

const chart = ref(null);
let chartInstance = null;

onMounted(() => {
  initChart();
});

watch(
  () => props.data,
  () => {
    if (chartInstance) {
      chartInstance.setOption({
        xAxis: {
          data: props.data.labels
        },
        series: props.data.datasets
      });
    }
  },
  { deep: true }
);

const initChart = () => {
  chartInstance = echarts.init(chart.value);
  const chartOptions = {
    xAxis: {
      type: 'category',
      data: props.data.labels
    },
    yAxis: {
      type: 'value'
    },
    series: props.data.datasets,
    ...props.options
  };
  chartInstance.setOption(chartOptions);
};

// 处理窗口大小变化时重新调整图表大小
window.addEventListener('resize', () => {
  if (chartInstance) {
    chartInstance.resize();
  }
});
</script>

<style scoped>
.chart {
  width: 100%;
  height: 400px;
}
</style>