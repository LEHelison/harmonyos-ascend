const express = require('express');
const router = express.Router();
const User = require('../models/User');
const jwt = require('jsonwebtoken');

// JWT密钥
const JWT_SECRET = 'smart-factory-jwt-secret';

// 中间件：验证token
const authenticateToken = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      return res.status(401).json({ code: 401, message: '未提供认证令牌' });
    }

    const token = authHeader.split(' ')[1];
    jwt.verify(token, JWT_SECRET, (err, user) => {
      if (err) {
        if (err.name === 'TokenExpiredError') {
          return res.status(401).json({ code: 401, message: '认证令牌已过期' });
        }
        return res.status(403).json({ code: 403, message: '无效的认证令牌' });
      }

      req.user = user;
      next();
    });
  } catch (error) {
    console.error('Token验证错误:', error);
    return res.status(500).json({ code: 500, message: '服务器错误' });
  }
};

// 获取用户信息
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ code: 404, message: '用户不存在' });
    }
    delete user.password;
    return res.status(200).json({ code: 200, data: user });
  } catch (error) {
    console.error('获取用户资料错误:', error);
    return res.status(500).json({ code: 500, message: '服务器错误' });
  }
});

// 更新用户信息
router.put('/profile', authenticateToken, async (req, res) => {
  try {
    const { name, email, phone, department } = req.body;
    await User.updateProfile(req.user.id, { name, email, phone, department });
    const updatedUser = await User.findById(req.user.id);
    delete updatedUser.password;
    return res.status(200).json({ code: 200, message: '用户信息更新成功', data: updatedUser });
  } catch (error) {
    console.error('更新用户资料错误:', error);
    return res.status(500).json({ code: 500, message: '服务器错误' });
  }
});

// 修改密码
router.put('/change-password', authenticateToken, async (req, res) => {
  try {
    const { currentPassword, newPassword, confirmPassword } = req.body;
    if (newPassword !== confirmPassword) {
      return res.status(400).json({ code: 400, message: '两次输入的新密码不匹配' });
    }
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ code: 404, message: '用户不存在' });
    }
    const isMatch = await User.comparePassword(currentPassword, user.password);
    if (!isMatch) {
      return res.status(401).json({ code: 401, message: '当前密码不正确' });
    }
    await User.updatePassword(req.user.id, newPassword);
    return res.status(200).json({ code: 200, message: '密码修改成功' });
  } catch (error) {
    console.error('修改密码错误:', error);
    return res.status(500).json({ code: 500, message: '服务器错误' });
  }
});

module.exports = router; 