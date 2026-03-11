import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from '@/router'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import './assets/icon/iconfont.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import VueECharts from 'vue-echarts'
localStorage.removeItem('token'); //强制进入登录页面
// import Request from '@/utils/Request'

const app = createApp(App);
app.use(router);
app.use(ElementPlus);
app.component('v-chart', VueECharts);

// 注册所有图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
    app.component(key, component);
}

// 注册全局通知管理器
import notificationManager from './utils/alertNotificationManager';
app.config.globalProperties.$notify = notificationManager;

// app.config.globalProperties.Request = Request;
app.mount('#app')
