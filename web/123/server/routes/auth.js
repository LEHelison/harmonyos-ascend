const express = require('express');
const router = express.Router();
const User = require('../models/User');
const jwt = require('jsonwebtoken');

// JWT密钥
const JWT_SECRET = 'smart-factory-jwt-secret';

// 注册接口
router.post('/register', async (req, res) => {
  try {
    const { username, password, confirmPassword, captcha } = req.body;

    // 验证提交的验证码
    if (!req.session.captcha || req.session.captcha !== captcha.toLowerCase()) {
      return res.status(400).json({ code: 400, message: '验证码错误' });
    }

    // 检查密码是否匹配
    if (password !== confirmPassword) {
      return res.status(400).json({ code: 400, message: '两次输入的密码不匹配' });
    }

    // 检查用户名是否已存在
    const existingUser = await User.findByUsername(username);
    if (existingUser) {
      return res.status(400).json({ code: 400, message: '用户名已被使用' });
    }

    // 创建新用户
    const newUser = await User.create({ username, password });

    // 清除验证码
    req.session.captcha = null;

    return res.status(201).json({
      code: 200,
      message: '注册成功',
      data: { username: newUser.username }
    });
  } catch (error) {
    console.error('注册错误:', error);
    return res.status(500).json({ code: 500, message: '服务器错误' });
  }
});

// 登录接口
router.post('/login', async (req, res) => {
  try {
    const { username, password, captcha } = req.body;

    // 验证提交的验证码
    if (!req.session.captcha || req.session.captcha !== captcha.toLowerCase()) {
      return res.status(400).json({ code: 400, message: '验证码错误' });
    }

    // 查找用户
    const user = await User.findByUsername(username);
    if (!user) {
      return res.status(401).json({ code: 401, message: '用户名或密码错误' });
    }

    // 验证密码
    const isMatch = await User.comparePassword(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ code: 401, message: '用户名或密码错误' });
    }

    // 更新最后登录时间
    await User.updateLastLogin(user.id);

    // 创建JWT
    const token = jwt.sign(
      { id: user.id, username: user.username, role: user.role },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    // 清除验证码
    req.session.captcha = null;

    return res.status(200).json({
      code: 200,
      message: '登录成功',
      data: {
        token,
        user: {
          id: user.id,
          username: user.username,
          role: user.role,
          name: user.name,
          email: user.email,
          avatar: user.avatar
        }
      }
    });
  } catch (error) {
    console.error('登录错误:', error);
    return res.status(500).json({ code: 500, message: '服务器错误' });
  }
});

// 获取当前用户信息接口
router.get('/me', async (req, res) => {
  try {
    // 从请求头中获取token
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
      return res.status(401).json({ code: 401, message: '未提供认证令牌' });
    }

    // 验证token
    const decoded = jwt.verify(token, JWT_SECRET);

    // 查找用户
    const user = await User.findById(decoded.id);
    if (!user) {
      return res.status(404).json({ code: 404, message: '用户不存在' });
    }

    // 删除密码字段
    delete user.password;

    return res.status(200).json({
      code: 200,
      data: user
    });
  } catch (error) {
    console.error('获取用户信息错误:', error);

    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ code: 401, message: '无效的认证令牌' });
    }

    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ code: 401, message: '认证令牌已过期' });
    }

    return res.status(500).json({ code: 500, message: '服务器错误' });
  }
});

module.exports = router; 