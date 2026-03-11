const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const path = require('path');
const svgCaptcha = require('svg-captcha');
const session = require('express-session');

// 引入路由
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/user');

// 创建Express应用
const app = express();
const PORT = process.env.PORT || 3000;

// 配置中间件
app.use(cors({
  origin: 'http://localhost:5174',
  credentials: true
}));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// 配置会话
app.use(session({
  secret: 'smart-factory-secret',
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false, maxAge: 1000 * 60 * 60 * 24 } // 24小时有效期
}));

// 验证码接口
app.get('/api/captcha', (req, res) => {
  const captcha = svgCaptcha.create({
    size: 4,
    noise: 2,
    color: true,
    background: '#f0f0f0'
  });
  req.session.captcha = captcha.text.toLowerCase(); // 存储验证码文本到会话
  res.type('svg');
  res.status(200).send(captcha.data);
});

// 添加API路由
app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);

// 提供静态文件服务
app.use(express.static(path.join(__dirname, '../dist')));

// 对于所有其他路由，返回index.html
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../dist/index.html'));
});

// 启动服务器
app.listen(PORT, () => {
  console.log(`服务器运行在端口 ${PORT}`);
}); 