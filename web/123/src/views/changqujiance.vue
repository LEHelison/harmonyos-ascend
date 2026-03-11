<template>
  <div class="overview-container">
    <h2 style="margin-top: -25px;">厂区总览</h2>
    <div class="factory-list-wrapper">
      <el-row :gutter="32" justify="center">
        <el-col :xs="24" :sm="12" :md="8" v-for="(item, index) in factoryAreas" :key="index">
          <el-card class="factory-card" @click="navigateToPersonnelDetail(item.id)">
            <div class="card-content">
              <div class="camera-view">
                <img :src="item.cameraUrl" alt="Camera View" />
              </div>
              <div class="factory-info">
                <h3>{{ item.name }}</h3>
                <p>总人数: {{ item.totalPeople }}</p>
                <el-button type="primary" size="small" @click.stop="navigateToPersonnelDetail(item.id)">查看详情</el-button>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();

// 工厂区域数据（示例数据）
const factoryAreas = ref([
  {
    id: 1,
    name: '厂区一',
    totalPeople: 30,
    cameraUrl: new URL('@/assets/imgs/shexiangtou.jpg', import.meta.url).href // 使用本地图片路径
  },
  {
    id: 2,
    name: '厂区二',
    totalPeople: 30,
    cameraUrl: new URL('@/assets/imgs/shexiangtou.jpg', import.meta.url).href
  },
  {
    id: 3,
    name: '厂区三',
    totalPeople: 30,
    cameraUrl: new URL('@/assets/imgs/shexiangtou.jpg', import.meta.url).href
  }
]);

// 导航到人员检测详情页
const navigateToPersonnelDetail = (factoryId) => {
  router.push(`/personnel-detail/${factoryId}`);
};
</script>

<style scoped>
.overview-container {
  min-height: 100vh;
  padding: 20px;
  background: #f5f7fa;
}

.factory-list-wrapper {
  max-width: 1200px;
  margin: 0 auto;
}

.factory-card {
  height: auto;
  min-height: 340px;
  display: flex;
  flex-direction: column;
  transition: transform 0.3s, box-shadow 0.3s;
  cursor: pointer;
  border-radius: 16px;
  box-shadow: 0 4px 24px rgba(0,0,0,0.10), 0 1.5px 6px rgba(0,0,0,0.08);
  margin-bottom: 32px;
  background: #fff;
}

.factory-card:hover {
  transform: translateY(-8px) scale(1.03);
  box-shadow: 0 12px 32px rgba(64,158,255,0.18), 0 6px 12px rgba(0,0,0,0.10);
}

.card-content {
  padding: 12px 10px 14px 10px;
}

.camera-view {
  width: 100%;
  height: 200px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f7fa;
  border-radius: 10px;
  overflow: hidden;
  margin-bottom: 14px;
}

.camera-view img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.factory-info {
  text-align: center;
  margin-top: 8px;
}

.factory-info h3 {
  margin: 0 0 8px 0;
  font-size: 22px;
  font-weight: 600;
  color: #222;
}

.factory-info p {
  margin: 0 0 12px 0;
  font-size: 16px;
  color: #888;
}

.factory-info .el-button {
  margin-top: 4px;
}
</style>