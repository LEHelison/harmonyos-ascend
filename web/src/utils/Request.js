import axios from "axios";
import { ElLoading } from 'element-plus';

const contentTypeForm = "application/x-www-form-urlencoded;charset=UTF-8";
const contentTypeJson = "application/json;charset=UTF-8";
const contentTypeFile = "multipart/form-data";
const request = () => {
  const {url,params,ataType,showLoading} = config;
  dataType = dataType?"form": dataType;
  showLoading = showLoading?showLoading:true;
  
  let contentType = contentTypeForm;
  if(dataType === "json"){
    contentType = contentTypeJson;
  }else if(dataType === "file"){
    contentType = contentTypeFile;
    let param = new FormData();
    for (let key in params){
      param.append(key,params[key]);
    }
    params = param;
  }

  const instance = axios.create({
    baseURL: "/api",
    timeout: 10000,
    headers: {
      "Content-Type": contentType,
      "X-Requested-With": "XMLHttpRequest",
    },
  });

  let loading = null;
  instance.interceptors.request.use(
    (config) => {
      if (showLoading) {
        // loading
        ElLoading.service({
          lock: true,
          text: 'Loading',
          background: 'rgba(0, 0, 0, 0.7)',
        })
      }
      return config;
    },
    (error) => {
      if (showLoading && loading) {
        loading.close();
      }
      ElMessage({
        message: '发送请求失败',
        type: 'erroe',
      })
      return Promise.reject("发送请求失败");
    }
  )

  // 请求后拦截
  instance.interceptors.response.use(
    (response) => {
      if (showLoading && loading) {
        loading.close();
      }

      const responseData = response.data;
    },
    (error) => {
      if (showLoading && loading) {
        loading.close();
      }
      return Promise.reject("网络异常");
    }
  )

  return instance.post(url,params).catch(error => {
    ElMessage({
      message: '请求失败',
      type: 'erroe',
    })
    return Promise.reject("请求失败");
  })
}

export default request;