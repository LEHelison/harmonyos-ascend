import axios from 'axios';
import { ElMessage } from 'element-plus';
import router from '../router';

// 创建axios实例
const service = axios.create({
  baseURL: '/api',
  timeout: 10000
});

// 请求拦截器
service.interceptors.request.use(
  config => {
    // 从localStorage获取token
    const token = localStorage.getItem('token');

    // 如果token存在，添加到请求头
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }

    return config;
  },
  error => {
    console.error('请求拦截器错误:', error);
    return Promise.reject(error);
  }
);

// 响应拦截器
service.interceptors.response.use(
  response => {
    const res = response.data;

    // 如果接口返回错误码
    if (res.code !== 200 && res.code !== undefined) {
      ElMessage.error(res.message || '请求失败');

      // 如果是认证问题
      if (res.code === 401 || res.code === 403) {
        // 清除本地token
        localStorage.removeItem('token');
        localStorage.removeItem('user');

        // 跳转到登录页
        router.push('/login');
      }

      return Promise.reject(new Error(res.message || '请求失败'));
    }

    return res;
  },
  error => {
    console.error('响应拦截器错误:', error);

    // 处理请求错误
    if (error.response) {
      // 如果是认证问题
      if (error.response.status === 401 || error.response.status === 403) {
        // 清除本地token
        localStorage.removeItem('token');
        localStorage.removeItem('user');

        // 跳转到登录页
        router.push('/login');

        ElMessage.error('认证失败，请重新登录');
      } else {
        ElMessage.error(error.response.data.message || '请求失败');
      }
    } else {
      ElMessage.error('网络错误，请检查网络连接');
    }

    return Promise.reject(error);
  }
);

export default service; 