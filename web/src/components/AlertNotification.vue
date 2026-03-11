<template>
  <div class="alert-container" v-if="visible">
    <div 
      class="alert-notification" 
      :class="alertType"
      @click="handleClose"
    >
      <div class="alert-icon">
        <el-icon :size="24">
          <Warning v-if="alertType === 'warning'" />
          <InfoFilled v-else-if="alertType === 'info'" />
          <WarningFilled v-else-if="alertType === 'error'" />
          <CircleCheckFilled v-else />
        </el-icon>
      </div>
      <div class="alert-content">
        <div class="alert-title">{{ title }}</div>
        <div class="alert-message">{{ message }}</div>
        <div class="alert-time">{{ time }}</div>
      </div>
      <div class="alert-close" @click.stop="handleClose">
        <el-icon><Close /></el-icon>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { Warning, InfoFilled, WarningFilled, CircleCheckFilled, Close } from '@element-plus/icons-vue';

const props = defineProps({
  title: {
    type: String,
    default: '系统通知'
  },
  message: {
    type: String,
    required: true
  },
  type: {
    type: String,
    default: 'success',
    validator: (value) => ['success', 'warning', 'info', 'error'].includes(value)
  },
  duration: {
    type: Number,
    default: 5000 // 5秒后自动关闭
  },
  visible: {
    type: Boolean,
    default: true
  }
});

const emit = defineEmits(['close']);

const alertType = ref(props.type);
const time = ref(new Date().toLocaleTimeString());
let timer = null;

const handleClose = () => {
  emit('close');
};

onMounted(() => {
  // 设置定时器，自动关闭提示
  if (props.duration > 0) {
    timer = setTimeout(() => {
      handleClose();
    }, props.duration);
  }
});

onBeforeUnmount(() => {
  // 清除定时器
  if (timer) {
    clearTimeout(timer);
  }
});
</script>

<style scoped>
.alert-container {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 9999;
}

.alert-notification {
  display: flex;
  align-items: flex-start;
  padding: 15px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  width: 350px;
  background-color: white;
  animation: slideIn 0.3s ease-out, fadeOut 0.5s ease-out forwards;
  animation-delay: 0s, calc(v-bind('props.duration') - 500)ms;
  position: relative;
  margin-bottom: 10px;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

@keyframes fadeOut {
  from {
    opacity: 1;
    transform: translateX(0);
  }
  to {
    opacity: 0;
    transform: translateX(100%);
  }
}

.alert-icon {
  margin-right: 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 40px;
  width: 40px;
  border-radius: 50%;
}

.alert-content {
  flex: 1;
}

.alert-title {
  font-weight: bold;
  margin-bottom: 5px;
  font-size: 16px;
}

.alert-message {
  margin-bottom: 5px;
  color: #606266;
}

.alert-time {
  font-size: 12px;
  color: #909399;
}

.alert-close {
  cursor: pointer;
  padding: 5px;
  color: #909399;
}

.alert-close:hover {
  color: #606266;
}

/* 不同类型的警报样式 */
.success .alert-icon {
  color: #67c23a;
  background-color: rgba(103, 194, 58, 0.1);
}

.warning .alert-icon {
  color: #e6a23c;
  background-color: rgba(230, 162, 60, 0.1);
}

.info .alert-icon {
  color: #909399;
  background-color: rgba(144, 147, 153, 0.1);
}

.error .alert-icon {
  color: #f56c6c;
  background-color: rgba(245, 108, 108, 0.1);
}
</style> 