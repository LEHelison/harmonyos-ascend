import { createVNode, render } from 'vue';
import AlertNotification from '../components/AlertNotification.vue';

// 用于存储所有活动通知的数组
const notifications = [];
// 最大通知数量
const MAX_NOTIFICATIONS = 3;
// 已显示通知的ID，用于防止重复显示
const shownNotifications = new Set();

/**
 * 创建并显示一个新的通知
 * @param {Object} options - 通知选项
 * @param {string} options.title - 通知标题
 * @param {string} options.message - 通知消息
 * @param {string} options.type - 通知类型 ('success', 'warning', 'info', 'error')
 * @param {number} options.duration - 通知持续时间（毫秒），0表示不自动关闭
 * @param {string} options.id - 通知唯一ID，用于防止重复显示
 * @returns {Object} 包含close方法的通知对象
 */
const createNotification = (options) => {
  // 生成通知ID
  const notificationId = options.id || `${options.type}-${options.title}-${options.message}`;
  
  // 检查通知是否已经显示过
  if (shownNotifications.has(notificationId)) {
    return null;
  }
  
  // 记录已显示通知
  shownNotifications.add(notificationId);
  
  // 如果已达到最大通知数，移除最旧的通知
  if (notifications.length >= MAX_NOTIFICATIONS) {
    const oldestNotification = notifications.shift();
    oldestNotification.close();
  }

  // 创建一个挂载点
  const container = document.createElement('div');
  
  // 创建VNode
  const vNode = createVNode(AlertNotification, {
    ...options,
    visible: true,
    onClose: () => {
      // 关闭并移除通知
      render(null, container);
      // 在移除DOM之前检查container是否仍然有父节点且父节点是body
      if (container.parentNode === document.body) {
        document.body.removeChild(container);
      }
      // 从通知数组中移除
      const index = notifications.indexOf(notificationInstance);
      if (index !== -1) {
        notifications.splice(index, 1);
      }
      // 从已显示记录中移除
      shownNotifications.delete(notificationId);
    }
  });
  
  // 渲染到容器
  render(vNode, container);
  
  // 添加到DOM
  document.body.appendChild(container);
  
  // 创建通知实例
  const notificationInstance = {
    close: () => {
      vNode.component.props.visible = false;
      // 使用setTimeout给动画留时间
      setTimeout(() => {
        // 在移除DOM之前检查container是否仍然有父节点且父节点是body
        if (container.parentNode === document.body) {
           render(null, container); // 先unmount Vue组件
           document.body.removeChild(container);
        }
        // 从通知数组中移除 (这里可能已经移除，加个检查)
        const index = notifications.indexOf(notificationInstance);
        if (index !== -1) {
          notifications.splice(index, 1);
        }
         // 从已显示记录中移除 (这里可能已经移除，加个检查)
        shownNotifications.delete(notificationId);
      }, 300); // 假设动画是300ms
    }
  };
  
  // 添加到通知数组
  notifications.push(notificationInstance);
  
  // 如果设置了自动关闭时间，则自动关闭
  if (options.duration > 0) {
    setTimeout(() => {
      notificationInstance.close();
    }, options.duration);
  }
  
  return notificationInstance;
};

/**
 * 创建一个成功通知
 * @param {string} message - 通知消息
 * @param {string} title - 通知标题（可选）
 * @param {number} duration - 持续时间（可选）
 * @param {string} id - 通知唯一ID（可选）
 * @returns {Object} 通知实例
 */
export const notifySuccess = (message, title = '成功', duration = 3000, id = null) => {
  return createNotification({
    title,
    message,
    type: 'success',
    duration,
    id
  });
};

/**
 * 创建一个警告通知
 * @param {string} message - 通知消息
 * @param {string} title - 通知标题（可选）
 * @param {number} duration - 持续时间（可选）
 * @param {string} id - 通知唯一ID（可选）
 * @returns {Object} 通知实例
 */
export const notifyWarning = (message, title = '警告', duration = 4000, id = null) => {
  return createNotification({
    title,
    message,
    type: 'warning',
    duration,
    id
  });
};

/**
 * 创建一个信息通知
 * @param {string} message - 通知消息
 * @param {string} title - 通知标题（可选）
 * @param {number} duration - 持续时间（可选）
 * @param {string} id - 通知唯一ID（可选）
 * @returns {Object} 通知实例
 */
export const notifyInfo = (message, title = '信息', duration = 3000, id = null) => {
  return createNotification({
    title,
    message,
    type: 'info',
    duration,
    id
  });
};

/**
 * 创建一个错误通知
 * @param {string} message - 通知消息
 * @param {string} title - 通知标题（可选）
 * @param {number} duration - 持续时间（可选）
 * @param {string} id - 通知唯一ID（可选）
 * @returns {Object} 通知实例
 */
export const notifyError = (message, title = '错误', duration = 5000, id = null) => {
  return createNotification({
    title,
    message,
    type: 'error',
    duration,
    id
  });
};

/**
 * 关闭所有通知
 */
export const closeAllNotifications = () => {
  while (notifications.length) {
    const notification = notifications.pop();
    notification.close();
  }
};

/**
 * 清除已显示的通知记录（在重要场景需要再次显示通知时使用）
 */
export const clearShownNotifications = () => {
  shownNotifications.clear();
};

export default {
  success: notifySuccess,
  warning: notifyWarning,
  info: notifyInfo,
  error: notifyError,
  closeAll: closeAllNotifications,
  clearShown: clearShownNotifications
}; 