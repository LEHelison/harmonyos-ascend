<template>
  <div class="personnel-detail">
    <div class="header">
      <h1>人员检测详情 - {{ factoryName }}</h1>
      <el-button type="primary" @click="goBack">返回</el-button>
    </div>

    <!-- 视频监控区域 -->
    <div class="video-section">
      <h2>实时监控</h2>
      <div class="video-grid">
        <div class="video-item" v-for="(camera, index) in cameras" :key="index">
          <div class="video-container">
<img style="display: block; -webkit-user-select: none; user-select: none; margin: auto; background-color: hsl(0, 0%, 25%); height: 300px;" src="http://192.168.28.129:5000/video_feed"
>
            <div class="camera-info">
              <span>{{ camera.name }}</span>
              <el-tag :type="camera.status === 'active' ? 'success' : 'danger'">
                {{ camera.status === 'active' ? '在线' : '离线' }}
              </el-tag>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 人员详情区域 -->
    <div class="personnel-section">
      <h2>人员详情</h2>
      <el-table :data="personnelData" style="width: 100%" border>
        <el-table-column prop="id" label="工号" width="120"></el-table-column>
        <el-table-column prop="name" label="姓名" width="120"></el-table-column>
        <el-table-column prop="department" label="部门" width="150"></el-table-column>
        <el-table-column prop="position" label="职位" width="150"></el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.status === '在岗' ? 'success' : 'warning'">
              {{ scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="lastCheckIn" label="最后打卡时间" width="180"></el-table-column>
        <el-table-column prop="location" label="当前位置"></el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const route = useRoute();
const router = useRouter();
const factoryName = ref('厂区一');

// 模拟摄像头数据
const cameras = ref([
  {
    name: '前门监控',
    feed: 'http://192.168.31.30:5000/video_feed',
    status: 'active'
  },
  {
    name: '后门监控',
    feed: 'http://192.168.31.30:5000/video_feed',
    status: 'active'
  },
  {
    name: '车间监控',
    feed: 'http://192.168.1.172:5000/video_feed',
    status: 'active'
  },
  {
    name: '仓库监控',
    feed: 'http://192.168.1.172:5000/video_feed',
    status: 'offline'
  }
]);

// 模拟人员数据
const personnelData = ref([
  {
    id: 'EMP001',
    name: '张三',
    department: '生产部',
    position: '操作员',
    status: '在岗',
    lastCheckIn: '2024-03-20 08:30:00',
    location: 'A区-生产线1'
  },
  {
    id: 'EMP002',
    name: '李四',
    department: '质检部',
    position: '质检员',
    status: '在岗',
    lastCheckIn: '2024-03-20 08:25:00',
    location: 'B区-质检站'
  },
  {
    id: 'EMP003',
    name: '王五',
    department: '仓储部',
    position: '仓管员',
    status: '休息',
    lastCheckIn: '2024-03-20 08:00:00',
    location: 'C区-仓库'
  }
]);

// 返回上一页
const goBack = () => {
  router.back();
};

onMounted(() => {
  // 这里可以根据路由参数获取工厂ID，并加载相应的数据
  const factoryId = route.params.id;
  // 实际项目中应该调用API获取数据
  console.log('加载工厂ID:', factoryId);
});
</script>

<style scoped>
.personnel-detail {
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.video-section,
.personnel-section {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 30px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.video-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.video-item {
  background: #f5f7fa;
  border-radius: 8px;
  overflow: hidden;
}

.video-container {
  position: relative;
}

.video-feed {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.camera-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px;
  background: rgba(0, 0, 0, 0.7);
  color: white;
}

h2 {
  margin-bottom: 20px;
  color: #303133;
}

.el-table {
  margin-top: 20px;
}
</style>