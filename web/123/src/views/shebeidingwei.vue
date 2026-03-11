<template>
  <div class="device-location">
    <h1>设备定位</h1>
    <div class="map-video-row">
      <!-- 地图卡片 -->
      <el-card class="map-card">
        <template #header>
          <div class="card-header">
            <span>设备位置地图</span>
            <div class="map-controls">
              <el-select v-model="selectedDeviceType" placeholder="设备类型" class="filter-select">
                <el-option label="全部" value="all"></el-option>
                <el-option label="机械臂" value="robot"></el-option>
                <el-option label="传感器" value="sensor"></el-option>
                <el-option label="监控设备" value="camera"></el-option>
              </el-select>
              <el-select v-model="selectedStatus" placeholder="状态" class="filter-select">
                <el-option label="全部" value="all"></el-option>
                <el-option label="运行中" value="running"></el-option>
                <el-option label="空闲" value="idle"></el-option>
                <el-option label="离线" value="offline"></el-option>
              </el-select>
              <el-button type="primary" @click="refreshMap">刷新地图</el-button>
            </div>
          </div>
        </template>
        
        <!-- 百度地图容器 -->
        <div class="map-container" ref="mapContainer">
          <iframe v-if="useExternalMap" :src="externalMapUrl" frameborder="0" style="width: 100%; height: 100%;"></iframe>
        </div>
        
        <!-- 设备列表 -->
        <el-table :data="filteredDevices" style="width: 100%; margin-top: 20px;">
          <el-table-column prop="name" label="设备名称" width="150"></el-table-column>
          <el-table-column prop="type" label="类型" width="120">
            <template #default="scope">
              <el-tag :type="getDeviceTypeTag(scope.row.type)">{{ getDeviceTypeName(scope.row.type) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="location" label="位置" width="200"></el-table-column>
          <el-table-column prop="status" label="状态" width="100">
            <template #default="scope">
              <el-tag :type="getStatusType(scope.row.status)">{{ getStatusName(scope.row.status) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="lastUpdate" label="最后更新" width="180"></el-table-column>
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button type="primary" size="small" @click="locateDevice(scope.row)">定位</el-button>
              <el-button type="info" size="small" @click="showDeviceDetail(scope.row)">详情</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
      <!-- 摄像头窗口卡片 -->
      <el-card class="video-card">
        <template #header>
          <div class="card-header">
            <span>摄像头实时画面</span>
          </div>
        </template>
        <div class="video-container">
          <iframe src="http://192.168.31.30:5000/video_feed" frameborder="0" allowfullscreen style="width: 100%; height: 100%;"></iframe>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import axios from 'axios';
import { notifySuccess, notifyWarning } from '../utils/alertNotificationManager';

const router = useRouter();
const mapContainer = ref(null);
let map = null; // 百度地图实例
let markers = []; // 标记点
let deviceOverlays = []; // 设备图标覆盖物

// 外部地图设置
const useExternalMap = ref(true); // 使用外部地图服务
const externalMapUrl = ref('http://192.168.31.181:5000'); // 外部地图服务地址

// 设备数据
const devices = ref([
  { 
    id: 1, 
    name: '机械臂一', 
    type: 'robot', 
    location: '车间A区域1', 
    status: 'running', 
    lastUpdate: '2023-05-15 14:30:22',
    lat: 30.593651, 
    lng: 114.305393 
  },
  { 
    id: 2, 
    name: '机械臂二', 
    type: 'robot', 
    location: '车间A区域2', 
    status: 'idle', 
    lastUpdate: '2023-05-15 13:22:10',
    lat: 30.594651, 
    lng: 114.306393 
  },
  { 
    id: 3, 
    name: '温度传感器1', 
    type: 'sensor', 
    location: '车间B区域1', 
    status: 'running', 
    lastUpdate: '2023-05-15 14:45:33',
    lat: 30.592651, 
    lng: 114.304393 
  },
  { 
    id: 4, 
    name: '监控摄像头1', 
    type: 'camera', 
    location: '车间入口', 
    status: 'running', 
    lastUpdate: '2023-05-15 14:50:22',
    lat: 30.595651, 
    lng: 114.307393 
  },
  { 
    id: 5, 
    name: '监控摄像头2', 
    type: 'camera', 
    location: '车间出口', 
    status: 'offline', 
    lastUpdate: '2023-05-15 10:15:42',
    lat: 30.591651, 
    lng: 114.303393 
  },
]);

// 过滤条件
const selectedDeviceType = ref('all');
const selectedStatus = ref('all');

// 过滤设备数据
const filteredDevices = computed(() => {
  return devices.value.filter(device => {
    const typeMatch = selectedDeviceType.value === 'all' || device.type === selectedDeviceType.value;
    const statusMatch = selectedStatus.value === 'all' || device.status === selectedStatus.value;
    return typeMatch && statusMatch;
  });
});

// 获取设备类型标签
const getDeviceTypeTag = (type) => {
  if (type === 'robot') return 'primary';
  if (type === 'sensor') return 'success';
  if (type === 'camera') return 'info';
  return '';
};

// 获取设备类型名称
const getDeviceTypeName = (type) => {
  if (type === 'robot') return '机械臂';
  if (type === 'sensor') return '传感器';
  if (type === 'camera') return '监控设备';
  return type;
};

// 获取状态标签类型
const getStatusType = (status) => {
  if (status === 'running') return 'success';
  if (status === 'idle') return 'warning';
  if (status === 'offline') return 'danger';
  return '';
};

// 获取状态名称
const getStatusName = (status) => {
  if (status === 'running') return '运行中';
  if (status === 'idle') return '空闲';
  if (status === 'offline') return '离线';
  return status;
};

// 初始化百度地图
const initMap = () => {
  // 如果使用外部地图服务，则不需要初始化本地地图
  if (useExternalMap.value) {
    notifySuccess('已连接到设备定位系统', '地图加载成功', 3000);
    return;
  }
  
  // 以下是本地百度地图初始化代码
  if (!window.BMap) {
    loadBaiduMapApi();
    return;
  }
  
  // 创建地图实例
  map = new window.BMapGL.Map(mapContainer.value);
  // 创建点坐标
  const centerPoint = new window.BMapGL.Point(114.305393, 30.593651); // 武汉某处坐标
  // 初始化地图，设置中心点坐标和地图级别
  map.centerAndZoom(centerPoint, 17);
  // 开启鼠标滚轮缩放
  map.enableScrollWheelZoom(true);
  // 添加控件
  map.addControl(new window.BMapGL.ZoomControl());
  map.addControl(new window.BMapGL.ScaleControl());
  map.addControl(new window.BMapGL.MapTypeControl());
  
  // 添加设备标记
  addDeviceMarkers();
};

// 加载百度地图API
const loadBaiduMapApi = () => {
  const script = document.createElement('script');
  script.src = 'https://api.map.baidu.com/api?v=3.0&ak=您的百度地图AK&callback=initBaiduMap';
  script.async = true;
  document.body.appendChild(script);
  
  // 定义全局回调函数
  window.initBaiduMap = () => {
    initMap();
  };
};

// 添加设备标记
const addDeviceMarkers = () => {
  // 清除现有标记
  markers.forEach(marker => {
    map.removeOverlay(marker);
  });
  markers = [];
  
  // 添加新标记
  filteredDevices.value.forEach(device => {
    const point = new window.BMapGL.Point(device.lng, device.lat);
    const marker = new window.BMapGL.Marker(point);
    
    // 设置标记点的图标
    const iconUrl = getDeviceIcon(device.type, device.status);
    const icon = new window.BMapGL.Icon(iconUrl, new window.BMapGL.Size(30, 30));
    marker.setIcon(icon);
    
    // 添加信息窗口
    const infoWindow = new window.BMapGL.InfoWindow(`
      <div style="padding: 8px;">
        <h4 style="margin: 0 0 5px;">${device.name}</h4>
        <p style="margin: 5px 0;">类型: ${getDeviceTypeName(device.type)}</p>
        <p style="margin: 5px 0;">位置: ${device.location}</p>
        <p style="margin: 5px 0;">状态: ${getStatusName(device.status)}</p>
        <p style="margin: 5px 0;">最后更新: ${device.lastUpdate}</p>
      </div>
    `, {
      width: 250,
      height: 160,
      title: `设备信息 - ${device.name}`
    });
    
    // 点击标记点时显示信息窗口
    marker.addEventListener('click', () => {
      map.openInfoWindow(infoWindow, point);
    });
    
    map.addOverlay(marker);
    markers.push(marker);
  });
};

// 获取设备图标
const getDeviceIcon = (type, status) => {
  // 在实际应用中，这里应该返回不同类型和状态的设备图标URL
  // 可以使用本地资源或CDN资源
  return 'https://api.map.baidu.com/images/marker_red.png';
};

// 刷新地图
const refreshMap = () => {
  if (useExternalMap.value) {
    // 重新加载外部地图
    const iframe = mapContainer.value.querySelector('iframe');
    if (iframe) {
      iframe.src = externalMapUrl.value + '?t=' + new Date().getTime();
    }
    notifySuccess('地图已刷新', '系统通知', 3000);
    return;
  }
  
  if (map) {
    addDeviceMarkers();
    notifySuccess('地图已刷新', '系统通知', 3000);
  }
};

// 定位设备
const locateDevice = (device) => {
  if (map) {
    const point = new window.BMapGL.Point(device.lng, device.lat);
    map.centerAndZoom(point, 18);
    map.panTo(point);
    
    // 添加闪烁效果
    const marker = markers.find(m => 
      m.getPosition().lng === device.lng && 
      m.getPosition().lat === device.lat
    );
    
    if (marker) {
      const animation = window.BMapGL ? window.BMapGL.Animation.BMAP_ANIMATION_BOUNCE : 2;
      marker.setAnimation(animation);
      setTimeout(() => {
        marker.setAnimation(null);
      }, 3000);
    }
    
    notifySuccess(`已定位到设备: ${device.name}`, '设备定位', 2000);
  }
};

// 显示设备详情
const showDeviceDetail = (device) => {
  // 如果是机械臂类型，跳转到机械臂详情页
  if (device.type === 'robot') {
    router.push({
      path: '/framework/robot-detail',
      query: {
        name: device.name,
        status: device.status === 'running' ? '运行中' : '空闲',
        ip: `192.168.1.${device.id}`
      }
    });
  } else {
    // 其他类型的设备显示弹窗信息
    ElMessage({
      message: `设备详情功能开发中: ${device.name}`,
      type: 'info'
    });
  }
};

onMounted(() => {
  // 初始化地图
  initMap();
  // 通知
  notifySuccess('设备定位系统已加载', '系统通知', 3000);
});

onUnmounted(() => {
  // 清理地图资源
  if (map) {
    map = null;
  }
});
</script>

<style scoped>
.device-location {
  padding: 20px;
}

.map-video-row {
  display: flex;
  flex-direction: column;
  gap: 20px;
  margin-bottom: 20px;
}

.map-card, .video-card {
  width: 100%;
  min-width: 0;
  display: flex;
  flex-direction: column;
  height: 540px;
}

.map-container, .video-container {
  width: 100%;
  height: 500px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.map-controls {
  display: flex;
  align-items: center;
  gap: 10px;
}

.filter-select {
  width: 120px;
}
</style>