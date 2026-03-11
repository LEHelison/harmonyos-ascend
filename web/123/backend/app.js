const express = require('express');
const path = require('path');
const cors = require('cors');
const app = express();

// 中间件
app.use(cors());
app.use(express.json());

// 静态文件服务
app.use(express.static(path.join(__dirname, '../dist')));

// 路由
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const monitoringRoutes = require('./routes/monitoring');
const robotsRoutes = require('./routes/robots');

app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/monitoring', monitoringRoutes);
app.use('/api/robots', robotsRoutes);

// 所有其他路由都返回index.html
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../dist/index.html'));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
}); 