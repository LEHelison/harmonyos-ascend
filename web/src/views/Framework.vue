<template>
  <div class="layout">
    <el-container>
      <el-header class="header">
        <div class="logo">
          <img src="../assets/imgs/z.png" alt="Logo" class="logo-img" />
          <h3 style="color: white;margin-left: -60px;">"云昇数鸿"智慧工厂</h3>
        </div>
        <div class="user-info">
          <el-dropdown @command="handleCommand">
            <span class="el-dropdown-link">
              <el-avatar :src="user.avatar" :size="40" style="margin-right: 8px;" />
              <span style="font-size: 16px;color: white;">{{ user.username }}</span>
              <el-icon style="font-size: 16px; color: white;"><arrow-down /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="settings">设置</el-dropdown-item>
                <el-dropdown-item command="switch">切换账号</el-dropdown-item>
                <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>
      <el-container class="container">
        <el-aside width="200px" class="left-aside">
          <el-menu style="background-color: #304156;">
            <el-menu-item index="1">
              <img src="../assets/imgs/1.png" alt="" style="width: 30px; height: 30px; margin-right: 20px; color: white;">
              <RouterLink :to="{ path: '/framework/changqujiance' }">厂区监测</RouterLink>
            </el-menu-item>
            <el-menu-item index="2">
              <img src="../assets/imgs/2.png" alt="" style="width: 30px; height: 30px; margin-right: 20px;">
              <RouterLink :to="{ path: '/framework/chanxianguanli' }">产线管理</RouterLink>
            </el-menu-item>
            <el-menu-item index="3">
              <img src="../assets/imgs/3.png" alt="" style="width: 30px; height: 30px; margin-right: 20px;">
              <RouterLink :to="{ path: '/framework/chanxianjiance' }">产线监测</RouterLink>
            </el-menu-item>
            <el-menu-item index="4">
              <img src="../assets/imgs/4.png" alt="" style="width: 30px; height: 30px; margin-right: 20px;">
              <RouterLink :to="{ path: '/framework/zhinengzhushou' }">智能助手</RouterLink>
            </el-menu-item>
            <el-menu-item index="5" @click="navigateToStarComm">
              <img src="../assets/imgs/5.png" alt="" style="width: 30px; height: 30px; margin-right: 20px;">
              <RouterLink :to="{ path: '/framework/xingshantongxin' }">星闪通信</RouterLink>
            </el-menu-item>
            <el-menu-item index="6">
              <img src="../assets/imgs/6.png" alt="" style="width: 30px; height: 30px; margin-right: 20px;">
              <RouterLink :to="{ path: '/framework/shebeidingwei' }">设备定位</RouterLink>
            </el-menu-item>
            <el-menu-item index="7">
              <img src="../assets/imgs/7.png" alt="" style="width: 30px; height: 30px; margin-right: 20px;">
              <RouterLink :to="{ path: '/framework/renyuanguanli' }">人员管理</RouterLink>
            </el-menu-item>
          </el-menu>
        </el-aside>
        <div class="main-flex" :class="{ 'assistant-open': isAssistantOpen }" style="display: flex; width: 100%; height: 100%;">
          <el-main class="right-main main-content" style="flex: 1; position: relative;">
            <RouterView/>
            <ButtonView @open-assistant="isAssistantOpen = true"/>
          </el-main>
          <div v-if="isAssistantOpen" class="assistant-panel" style="width: 30vw; max-width: 480px; min-width: 340px; background: #fff; position: relative; box-shadow: -2px 0 8px #ccc; z-index: 200;">
            <button class="close-btn" @click="isAssistantOpen = false" style="position: absolute; top: 8px; right: 8px; font-size: 24px; background: none; border: none; cursor: pointer; z-index: 201;">×</button>
            <ZhinengZhushou />
          </div>
        </div>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { RouterLink, RouterView } from 'vue-router';
import { reactive, toRefs } from 'vue'
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ArrowDown } from '@element-plus/icons-vue'
import ButtonView from '../views/chat/ButtonView.vue'
import ZhinengZhushou from './zhinengzhushou.vue'

const router = useRouter()

// 导航到星闪通信页面
const navigateToStarComm = () => {
  router.push({
    path: '/framework/xingshantongxin',
    replace: false
  })
}

const user = ref({
  username: localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')).username : '未登录',
  avatar: localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')).avatar || 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png' : 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png'
})

const handleCommand = (command) => {
  if (command === 'logout') {
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    ElMessage.success('已退出登录')
    router.push('/login')
  } else if (command === 'switch') {
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    ElMessage.info('请重新登录')
    router.push('/login')
  } else if (command === 'settings') {
    ElMessage.info('设置功能开发中')
    // router.push('/settings')
  }
}

// 监听localStorage变化（切换账号后自动更新头像和用户名）
window.addEventListener('storage', () => {
  const u = localStorage.getItem('user')
  if (u) {
    const userObj = JSON.parse(u)
    user.value.username = userObj.username
    user.value.avatar = userObj.avatar || 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png'
  }
})

const isAssistantOpen = ref(false)
</script>

<style>
.layout {
  height: 100vh;
  line-height: 60px;
}

.layout .header {
  display: flex;
  justify-content: space-between;
  align-items: center; /* 确保内部元素垂直居中 */
  height: 65px;
  border-bottom: 0.5px solid #000;
  background-color: #2a598a;
  padding: 0 20px; /* 增加左右内边距 */
}

.logo {
  display: flex;
  align-items: center; /* 垂直居中 */
  justify-content: flex-start; /* 左对齐 */
  width: auto;
}

.logo-img {
  margin-left: -80px;
  width: 200px; /* 调整为合适的宽度 */
  height: auto; /* 自动高度保持比例 */
  max-height: 60px; /* 控制最大高度 */
  object-fit: contain; /* 确保完整显示 */
  transition: transform 0.3s ease; /* 添加平滑过渡 */
}

.logo-img:hover {
  transform: scale(1.05); /* 鼠标悬停时轻微放大 */
}

.user-info {
  display: flex;
  align-items: center; /* 确保内部元素垂直居中 */
  gap: 8px; /* 设置头像、文字和箭头之间的间距 */
}

.el-dropdown-link {
  display: flex;
  align-items: center; /* 用户名与图标垂直居中 */
  gap: 8px; /* 设置头像、文字和箭头之间的间距 */
  cursor: pointer;
}

.el-dropdown-menu__item {
  text-align: center;
}

.user-info > div {
  display: flex; /* 使用 Flexbox */
  align-items: center; /* 垂直居中 */
}

.layout .container {
  height: calc(100vh - 60px);
  /* background: #f5f6f7; */
}

/* 修改 .left-aside 的背景颜色 */
.layout .container .left-aside {
  border-right: 0.5px solid #000;
  background-color: #304156;
}

.layout .container .right-main {
  background-color: #E5EAF3;
}

.el-menu-item a {
  text-decoration: none;
  color: white;
  display: block;
  width: 100%;
  height: 100%;
}

.el-menu-item.is-active {
  background-color: #263445;
}

.el-menu-item.is-active a {
  font-weight: bold;
}

/* 新增：鼠标悬停时无背景色 */
.el-menu-item:hover {
  background-color: #263445;
}

.main-flex {
  display: flex;
  width: 100%;
  height: 100%;
  min-width: 0;
  overflow: hidden;
}
.main-content {
  flex: 1 1 0;
  min-width: 400px;
  position: relative;
  overflow: auto;
}
.assistant-panel {
  flex: 0 1 360px;
  width: 28vw;
  max-width: 420px;
  min-width: 280px;
  background: #fff;
  position: relative;
  box-shadow: -2px 0 8px #ccc;
  z-index: 200;
  overflow: auto;
}
.close-btn {
  position: absolute;
  top: 8px;
  right: 8px;
  font-size: 24px;
  background: none;
  border: none;
  cursor: pointer;
  z-index: 201;
}
</style>