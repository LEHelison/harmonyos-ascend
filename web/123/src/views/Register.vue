<template>
  <div class="bg">
    <div class="box">
      <img src="../assets/imgs/z.png" alt="logo">
      <h2>智慧工厂</h2>
    </div>
    <div class="box1">
      <el-form ref="formRef" :model="data.form" :rules="data.rules">
        <div style="margin: 20px 0; text-align: center;font-weight: bold;font-size: 24px;">注册</div>
        <el-form-item prop="username">
          <el-input size="large" v-model="data.form.username" placeholder="请输入账号" autocomplete="off">
            <template #prefix>
              <span class="iconfont icon-zhanghao"></span>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input size="large" show-password v-model="data.form.password" placeholder="请输入密码" autocomplete="off">
            <template #prefix>
              <span class="iconfont icon-mima"></span>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item prop="confirmPassword">
          <el-input size="large" show-password v-model="data.form.confirmPassword" placeholder="请再次确认密码"
            autocomplete="off">
            <template #prefix>
              <span class="iconfont icon-mima"></span>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item prop="captcha">
          <div style="display: flex; gap: 10px;">
            <el-input size="large" v-model="data.form.captcha" placeholder="请输入验证码" autocomplete="off">
              <template #prefix>
                <span class="iconfont icon-yanzhengma"></span>
              </template>
            </el-input>
            <div @click="refreshCaptcha" class="captcha-container" v-html="captchaSvg"></div>
          </div>
        </el-form-item>
        <div style="margin-bottom: 20px;">
          <el-button style="width: 100%;" size="large" type="primary" @click="register"
            :loading="loading">注册</el-button>
        </div>
        <div style="text-align: center;">
          已有账号 &nbsp; <router-link style="color: blue; text-decoration: none;" to="/login">立即登录</router-link>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ElMessage } from 'element-plus'
import { reactive, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import service from '../api/index.js'

const router = useRouter()
const formRef = ref()
const loading = ref(false)
const captchaSvg = ref('')

const data = reactive({
  form: {
    username: '',
    password: '',
    confirmPassword: '',
    captcha: ''
  },
  rules: {
    username: [
      { required: true, message: '请输入账号', trigger: 'blur' },
      { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
    ],
    password: [
      { required: true, message: '请输入密码', trigger: 'blur' },
      { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
    ],
    confirmPassword: [
      { required: true, message: '请再次输入密码', trigger: 'blur' },
      { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' },
      {
        validator: (rule, value, callback) => {
          if (value !== data.form.password) {
            callback(new Error('两次输入的密码不一致'))
          } else {
            callback()
          }
        },
        trigger: 'blur'
      }
    ],
    captcha: [
      { required: true, message: '请输入验证码', trigger: 'blur' },
      { min: 4, max: 4, message: '验证码为4位字符', trigger: 'blur' }
    ]
  }
})

// 获取验证码
const refreshCaptcha = async () => {
  try {
    const response = await fetch('/api/captcha', {
      method: 'GET',
      headers: {
        'Accept': 'text/html'
      }
    })
    captchaSvg.value = await response.text()
  } catch (error) {
    console.error('获取验证码失败:', error)
    ElMessage.error('获取验证码失败，请稍后重试')
  }
}

// 注册
const register = () => {
  formRef.value.validate(async (valid) => {
    if (!valid) {
      return
    }

    loading.value = true
    try {
      const response = await service.post('/auth/register', data.form)

      ElMessage.success('注册成功')
      router.push('/login')
    } catch (error) {
      console.error('注册错误:', error)
      if (error.response) {
        ElMessage.error(error.response.data.message || '注册失败')
      } else {
        ElMessage.error('注册失败，请检查网络连接')
      }
    } finally {
      loading.value = false
    }
  })
}

onMounted(() => {
  refreshCaptcha()
})
</script>

<style>
.bg {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100vh;
  overflow: hidden;
  /* background-image: url("../assets/imgs/Login.jpg"); */
  background-color: #E5EAF3;
  background-size: cover;
}

.box1 {
  width: 350px;
  height: 500px;
  background-color: rgb(231, 242, 252);
  border-radius: 5px;
  padding: 25px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
}

.box {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.box img {
  width: 60px;
  height: 60px;
}

.box h2 {
  margin: 0;
  color: #333;
}

.captcha-container {
  width: 120px;
  height: 40px;
  cursor: pointer;
  background-color: #f5f7fa;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>