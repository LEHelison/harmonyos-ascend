//import path from 'path'
import { createRouter, createWebHistory } from 'vue-router'
// import FactoryDetail from '../views/factoryDetail.vue'

const routes = [
  {
    name: '登录',
    path: '/login',
    component: () => import('../views/Login.vue'),
    meta: { requiresAuth: false }
  },
  {
    name: '注册',
    path: '/register',
    component: () => import('../views/Register.vue'),
    meta: { requiresAuth: false }
  },
  {
    name: '首页',
    path: '/framework',
    component: () => import('../views/Framework.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        name: '厂区监测',
        path: 'changqujiance', // 注意这里不需要加斜杠
        component: () => import('../views/changqujiance.vue')
      },
      {
        name: '产线管理',
        path: 'chanxianguanli', // 注意这里不需要加斜杠
        component: () => import('../views/chanxianguanli.vue')
      },
      {
        name: '产线监测',
        path: 'chanxianjiance', // 注意这里不需要加斜杠
        component: () => import('../views/chanxianjiance.vue')
      },
      {
        name: '智能助手',
        path: 'zhinengzhushou', // 注意这里不需要加斜杠
        component: () => import('../views/zhinengzhushou.vue')
      },
      {
        name: '设备定位',
        path: 'shebeidingwei', // 注意这里不需要加斜杠
        component: () => import('../views/shebeidingwei.vue')
      },
      {
        name: '星闪通信',
        path: 'xingshantongxin', // 注意这里不需要加斜杠
        component: () => import('../views/xingshantongxin.vue'),
        // meta: { keepAlive: true }
      },
      {
        name: '人员管理',
        path: 'renyuanguanli', // 注意这里不需要加斜杠
        component: () => import('../views/renyuanguanli.vue')
      },
      {
        name: '远程连接',
        path: 'remote-connection',
        component: () => import('../views/RemoteConnection.vue')
      },
      {
        name: '设备详情',
        path: 'robot-detail',
        component: () => import('../views/RobotDetail.vue')
      }
    ]
  },
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/login'
  },
  {
    path: '/personnel-detail/:id',
    name: 'PersonnelDetail',
    component: () => import('../views/personnelDetail.vue'),
    props: true,
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  // 检查路由是否需要认证
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth !== false);

  // 获取用户token
  const token = localStorage.getItem('token');

  if (requiresAuth && !token) {
    // 如果需要认证但没有token，重定向到登录页
    next('/login');
  } else if ((to.path === '/login' || to.path === '/register') && token) {
    // 如果已登录但尝试访问登录或注册页，重定向到首页
    next('/framework');
  } else {
    // 其他情况正常导航
    next();
  }
});

export default router