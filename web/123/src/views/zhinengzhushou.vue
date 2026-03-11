<template>
  <div class="ai-chat" :class="{'has-messages': messages.length > 0}">
    <!-- 主聊天区域 -->
    <div class="chat-main">
      <!-- 顶部导航 -->
      <nav class="chat-nav">
        <div class="nav-left">
          <el-button class="menu-btn" @click="toggleMenu">
            <el-icon><Menu /></el-icon>
          </el-button>
          <h1>AI 助理</h1>
        </div>
        <div class="nav-right">
          <el-button class="test-btn" @click="testApiConnection">
            <el-icon><Connection /></el-icon>
            测试API
          </el-button>
        </div>
      </nav>

      <!-- 欢迎区域 -->
      <div v-if="!messages.length" class="welcome-screen">
        <div class="welcome-content">
          <div class="welcome-icon">
            <el-icon :size="48"><ChatRound /></el-icon>
          </div>
          <h2 class="welcome-title">欢迎使用 AI 助理</h2>
          <p class="welcome-description">我可以帮助您解答问题、分析数据、编写代码等</p>
        </div>
      </div>

      <!-- 消息区域 -->
      <div v-else class="chat-messages" ref="messagesRef">
        <div 
          v-for="(message, index) in messages" 
          :key="index"
          class="message-item"
          :class="message.role"
        >
          <div class="message-content">
            <div class="message-header">
              <el-avatar 
                :size="32" 
                :src="message.role === 'user' ? userAvatar : aiAvatar"
              />
              <span class="sender-name">
                {{ message.role === 'user' ? '你' : 'AI 助理' }}
              </span>
            </div>
            <div class="message-body">
              <!-- 思考过程 -->
              <div v-if="message.thought" class="ai-thought">
                {{ message.thought }}
              </div>
              <!-- 正式回复 -->
              <div class="message-text">
                {{ message.content }}
                <span v-if="message.isTyping" class="typing-cursor"></span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 输入区域 -->
      <div class="chat-input" :class="{'has-messages': messages.length > 0}">
        <div class="input-wrapper">
          <div class="input-container">
            <el-input
              v-model="inputMessage"
              type="textarea"
              :rows="3"
              placeholder="输入消息..."
              resize="none"
              @keydown.enter.exact.prevent="sendMessage"
              @keydown.shift.enter.prevent="newLine"
            />
            <div class="input-actions">
              <div class="action-buttons">
                <el-button class="function-btn test-api-btn" @click="testApiConnection">
                  <el-icon><Connection /></el-icon>
                  测试API
                </el-button>
              </div>
              <el-button 
                type="primary" 
                class="send-btn"
                :disabled="!inputMessage.trim() || isGenerating"
                @click="sendMessage"
              >
                {{ isGenerating ? '生成中...' : '发送' }}
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, onUnmounted } from 'vue'
import { ElMessage } from 'element-plus'
import {
  Menu,
  Moon,
  User,
  Setting,
  SwitchButton,
  CopyDocument,
  RefreshRight,
  Paperclip,
  Microphone,
  Loading,
  ChatRound,
  ChatLineRound,
  Connection,
  Search
} from '@element-plus/icons-vue'
import { createChatCompletion } from '../api/chat'

// 状态变量
const inputMessage = ref('')
const inputRows = ref(1)
const messages = ref([])
const isGenerating = ref(false)
const isRecording = ref(false)
const messagesRef = ref(null)
const apiKey = ref('sk-dbacblydtxseicrrcehhghtbybnyxkwwklkyobobsszvlwpy')
const requestTimeout = ref(null)

// 用户信息
const userAvatar = ref('https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png')
const aiAvatar = ref('https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png')

// 建议提示语
const suggestions = [
  { id: 1, text: '你能帮我做什么？' },
  { id: 2, text: '如何提高工作效率？' },
  { id: 3, text: '帮我分析一下这个问题' },
  { id: 4, text: '给我一些创意建议' }
]

// 方法
const sendMessage = async () => {
  if (!inputMessage.value.trim() || isGenerating.value) return
  
  messages.value.push({
    role: 'user',
    content: inputMessage.value,
    timestamp: new Date()
  })
  
  const userInput = inputMessage.value
  inputMessage.value = ''
  
  await nextTick()
  scrollToBottom()
  
  isGenerating.value = true
  
  try {
    // 先插入一个"AI正在思考"的消息
    const aiMessage = {
      role: 'assistant',
      content: '',
      timestamp: new Date(),
      isTyping: true
    }
    messages.value.push(aiMessage)
    const aiIndex = messages.value.length - 1
    
    const response = await createChatCompletion({
      model: 'Qwen/QwQ-32B',
      messages: messages.value.map(msg => ({
        role: msg.role,
        content: msg.content
      })),
      apiKey: apiKey.value
    })
    
    if (response.choices && response.choices[0]) {
      // 替换整个对象，确保响应式
      messages.value[aiIndex] = {
        ...aiMessage,
        content: response.choices[0].message.content,
        isTyping: false,
        thought: response.choices[0].message.thought // 如果有思考过程
      }
      await nextTick()
      scrollToBottom()
    } else {
      throw new Error('API响应格式不正确')
    }
  } catch (error) {
    console.error('API错误:', error)
    ElMessage.error('生成回复失败：' + error.message)
    messages.value.pop()
  } finally {
    isGenerating.value = false
  }
}

const scrollToBottom = () => {
  if (!messagesRef.value) return
  messagesRef.value.scrollTop = messagesRef.value.scrollHeight
}

const adjustInputHeight = () => {
  const lines = inputMessage.value.split('\n').length
  inputRows.value = Math.min(Math.max(lines, 1), 5)
}

const newLine = () => {
  inputMessage.value += '\n'
  adjustInputHeight()
}

const copyText = async (text) => {
  try {
    await navigator.clipboard.writeText(text)
    ElMessage.success('已复制到剪贴板')
  } catch (err) {
    ElMessage.error('复制失败')
  }
}

const regenerateResponse = (index) => {
  // 实现重新生成响应的逻辑
}

const toggleRecording = () => {
  isRecording.value = !isRecording.value
  // 实现语音输入逻辑
}

const handleFileUpload = (file) => {
  // 实现文件上传逻辑
  return false
}

const usePrompt = (text) => {
  inputMessage.value = text
  sendMessage()
}

const toggleMenu = () => {
  // 实现菜单切换逻辑
}

const toggleTheme = () => {
  // 实现主题切换逻辑
}

const formatTime = (time) => {
  return new Date(time).toLocaleTimeString()
}

// 测试API连接
const testApiConnection = async () => {
  ElMessage.info('正在测试API连接...')
  
  try {
    const response = await createChatCompletion({
      model: 'Qwen/QwQ-32B',
      messages: [
        { role: 'user', content: '测试消息' }
      ],
      max_tokens: 10,
      apiKey: apiKey.value
    })
    
    console.log('API测试响应:', response)
    
    if (response.choices && response.choices[0]) {
      ElMessage.success('API连接成功!')
    } else {
      ElMessage.warning('API响应格式不正确')
    }
  } catch (error) {
    console.error('API测试错误:', error)
    ElMessage.error('API连接失败: ' + error.message)
  }
}

const toggleDeepThinking = () => {
  // 实现深度思考功能
}

const toggleWebSearch = () => {
  // 实现联网搜索功能
}

// 生命周期钩子
onMounted(() => {
  // 初始化逻辑
  console.log('Component mounted, API key:', apiKey.value ? '已设置' : '未设置')
})

// 组件卸载时清理
onUnmounted(() => {
  if (requestTimeout.value) {
    clearTimeout(requestTimeout.value)
  }
})
</script>

<style scoped>
.ai-chat {
  height: 100vh;
  background-color: #ffffff;
  display: flex;
  flex-direction: column;
}

.chat-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  position: relative;
  height: 100%;
  padding-bottom: 0;
}

.chat-nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 20px;
  border-bottom: 1px solid var(--el-border-color-lighter);
  background-color: var(--el-bg-color);
}

.nav-left, .nav-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.nav-left h1 {
  font-size: 18px;
  font-weight: 600;
  margin: 0;
}

.welcome-screen {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 0;
  margin-top: 15vh;
}

.welcome-content {
  text-align: center;
  max-width: 600px;
  margin-bottom: 32px;
}

.welcome-icon {
  width: 64px;
  height: 64px;
  margin: 0 auto 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f0f7ff;
  border-radius: 50%;
  color: #4b5563;
}

.welcome-title {
  font-size: 28px;
  font-weight: 600;
  color: #111827;
  margin-bottom: 12px;
}

.welcome-description {
  font-size: 16px;
  color: #6b7280;
  line-height: 1.6;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  margin-top: 20px;
}

.message-item {
  margin-bottom: 24px;
}

.message-content {
  max-width: 800px;
  margin: 0 auto;
}

.message-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.sender-name {
  font-size: 14px;
  color: #4b5563;
}

.message-text {
  padding: 16px;
  border-radius: 8px;
  background-color: #f9fafb;
  font-size: 14px;
  line-height: 1.6;
  color: #111827;
}

.message-item.user .message-text {
  background-color: #f0f7ff;
}

.chat-input {
  position: relative;
  padding: 0 20px;
  background: transparent;
}

.input-wrapper {
  max-width: 800px;
  margin: 0 auto;
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.input-container {
  background-color: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  padding: 16px;
}

.el-textarea {
  margin-bottom: 12px;
}

.el-textarea__inner {
  border: none !important;
  padding: 0 !important;
  background-color: transparent !important;
  font-size: 14px !important;
  line-height: 1.6 !important;
  color: #111827 !important;
}

.input-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 12px;
}

.action-buttons {
  display: flex;
  gap: 8px;
}

.function-btn {
  height: 36px;
  padding: 0 16px;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  color: #4b5563;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 6px;
  transition: all 0.2s;
}

.function-btn:hover {
  background-color: #f9fafb;
  border-color: #d1d5db;
}

.test-api-btn {
  color: #2563eb;
  border-color: #bfdbfe;
  background-color: #eff6ff;
}

.test-api-btn:hover {
  background-color: #dbeafe;
  border-color: #93c5fd;
}

.send-btn {
  height: 36px;
  padding: 0 24px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
}

@media (max-width: 768px) {
  .chat-input {
    padding: 12px;
  }
  
  .input-container {
    padding: 12px;
  }
  
  .function-btn {
    padding: 0 12px;
  }
  
  .message-content {
    max-width: 100%;
  }
}

.test-btn {
  margin-right: 8px;
}

.settings-btn {
  margin-right: 8px;
}

.slider-label {
  text-align: center;
  margin-top: 5px;
  color: var(--el-text-color-secondary);
  font-size: 12px;
}

.has-messages .welcome-screen {
  display: none;
}

.has-messages .chat-input {
  margin-top: 0;
  padding: 12px 20px;
  background: linear-gradient(to bottom, rgba(255,255,255,0) 0%, #ffffff 20%);
}

.ai-thought {
  border: 1px dashed #aaa;
  background: #f8f8f8;
  color: #888;
  font-style: italic;
  padding: 6px 10px;
  margin-bottom: 4px;
  border-radius: 8px;
  font-size: 14px;
  line-height: 1.6;
}

.message-text {
  background: #f9fafb;
  color: #111827;
  font-size: 15px;
  border-radius: 8px;
  padding: 16px;
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
</style>