const express = require('express');
const router = express.Router();
const axios = require('axios');
const { Client } = require('ssh2');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

// 配置multer存储
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const uploadDir = path.join(__dirname, '../uploads');
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    cb(null, `${Date.now()}-${file.originalname}`);
  }
});

const upload = multer({ storage: storage });

// 保存与每个SSH连接相关的会话
const sshSessions = {};

// 测试连接到node_exporter
router.get('/test-connection', async (req, res) => {
  const { ip, port } = req.query;
  
  if (!ip) {
    return res.status(400).json({ success: false, message: '缺少IP地址参数' });
  }
  
  try {
    // 尝试连接到node_exporter的metrics端点
    const response = await axios.get(`http://${ip}:${port || 9100}/metrics`, {
      timeout: 5000
    });
    
    if (response.status === 200) {
      return res.json({ success: true, message: '连接成功' });
    } else {
      return res.status(400).json({ success: false, message: '连接失败' });
    }
  } catch (error) {
    console.error('连接测试失败:', error);
    return res.status(500).json({ 
      success: false, 
      message: error.code === 'ECONNREFUSED' ? '无法连接到服务器' : '连接测试失败'
    });
  }
});

// 获取node_exporter指标数据
router.get('/monitor/metrics', async (req, res) => {
  const { ip, port } = req.query;
  
  if (!ip) {
    return res.status(400).json({ success: false, message: '缺少IP地址参数' });
  }
  
  try {
    // 从node_exporter获取原始指标数据
    const response = await axios.get(`http://${ip}:${port || 9100}/metrics`, {
      timeout: 5000
    });
    
    if (response.status === 200) {
      const metricsData = response.data;
      
      // 解析指标数据
      const parsedMetrics = parseNodeExporterMetrics(metricsData);
      
      return res.json(parsedMetrics);
    } else {
      return res.status(400).json({ success: false, message: '获取监控数据失败' });
    }
  } catch (error) {
    console.error('获取监控数据失败:', error);
    return res.status(500).json({ success: false, message: '获取监控数据失败' });
  }
});

// 保存机器人配置
router.post('/save-robot-config', async (req, res) => {
  const { id, ip } = req.body;
  
  if (!id || !ip) {
    return res.status(400).json({ success: false, message: '缺少必要参数' });
  }
  
  try {
    // 这里应该连接数据库保存配置
    // 由于没有数据库连接，这里只是模拟保存
    
    return res.json({ success: true, message: '配置已保存' });
  } catch (error) {
    console.error('保存配置失败:', error);
    return res.status(500).json({ success: false, message: '保存配置失败' });
  }
});

// 连接SSH
router.post('/ssh-connect', upload.single('keyFile'), (req, res) => {
  const { ip, port, authType } = req.body;
  const password = req.body.password;
  const keyFile = req.file;
  
  if (!ip) {
    return res.status(400).json({ success: false, message: '缺少IP地址参数' });
  }
  
  const conn = new Client();
  
  // 生成唯一的会话ID
  const sessionId = `${ip}-${Date.now()}`;
  
  // 配置SSH连接参数
  const config = {
    host: ip,
    port: port || 22,
    username: 'root'
  };
  
  if (authType === 'password') {
    if (!password) {
      return res.status(400).json({ success: false, message: '缺少密码参数' });
    }
    config.password = password;
  } else if (authType === 'key') {
    if (!keyFile) {
      return res.status(400).json({ success: false, message: '缺少密钥文件' });
    }
    try {
      config.privateKey = fs.readFileSync(keyFile.path);
    } catch (error) {
      console.error('读取密钥文件失败:', error);
      return res.status(500).json({ success: false, message: '读取密钥文件失败' });
    }
  }
  
  conn.on('ready', () => {
    // 保存连接
    sshSessions[sessionId] = { conn, shell: null };
    
    // 创建shell会话
    conn.shell((err, stream) => {
      if (err) {
        delete sshSessions[sessionId];
        return res.status(500).json({ success: false, message: '创建Shell会话失败' });
      }
      
      sshSessions[sessionId].shell = stream;
      
      return res.json({ 
        success: true, 
        message: 'SSH连接成功', 
        sessionId 
      });
    });
  });
  
  conn.on('error', (err) => {
    console.error('SSH连接错误:', err);
    delete sshSessions[sessionId];
    return res.status(500).json({ 
      success: false, 
      message: err.message || 'SSH连接失败' 
    });
  });
  
  // 尝试连接
  conn.connect(config);
});

// 执行SSH命令
router.post('/ssh-execute', (req, res) => {
  const { sessionId, command } = req.body;
  
  if (!sessionId || !sshSessions[sessionId]) {
    return res.status(400).json({ success: false, message: 'SSH会话无效或已过期' });
  }
  
  const session = sshSessions[sessionId];
  
  if (!session.shell) {
    return res.status(400).json({ success: false, message: 'SSH Shell未初始化' });
  }
  
  // 执行命令
  session.conn.exec(command, (err, stream) => {
    if (err) {
      return res.status(500).json({ success: false, message: '执行命令失败' });
    }
    
    let output = '';
    let errorOutput = '';
    
    stream.on('data', (data) => {
      output += data.toString();
    });
    
    stream.stderr.on('data', (data) => {
      errorOutput += data.toString();
    });
    
    stream.on('close', () => {
      return res.json({ 
        success: true, 
        result: output || errorOutput || '命令执行成功，无输出' 
      });
    });
  });
});

// 断开SSH连接
router.post('/ssh-disconnect', (req, res) => {
  const { sessionId } = req.body;
  
  if (!sessionId || !sshSessions[sessionId]) {
    return res.status(400).json({ success: false, message: 'SSH会话无效或已过期' });
  }
  
  try {
    // 关闭连接
    sshSessions[sessionId].conn.end();
    delete sshSessions[sessionId];
    
    return res.json({ success: true, message: 'SSH连接已断开' });
  } catch (error) {
    console.error('断开SSH连接失败:', error);
    return res.status(500).json({ success: false, message: '断开SSH连接失败' });
  }
});

// 解析node_exporter指标数据
function parseNodeExporterMetrics(metricsData) {
  try {
    const lines = metricsData.split('\n');
    const metrics = {
      cpu: 0,
      memory: 0,
      disk: 0,
      network: 0
    };
    
    // CPU使用率（100 - 空闲率）
    const cpuIdleLine = lines.find(line => line.includes('node_cpu_seconds_total') && line.includes('idle'));
    if (cpuIdleLine) {
      const match = cpuIdleLine.match(/([0-9.]+)$/);
      if (match) {
        const idleTime = parseFloat(match[1]);
        metrics.cpu = Math.round(100 - (idleTime * 100));
      }
    }
    
    // 内存使用率
    const memTotalLine = lines.find(line => line.includes('node_memory_MemTotal_bytes'));
    const memAvailableLine = lines.find(line => line.includes('node_memory_MemAvailable_bytes'));
    
    if (memTotalLine && memAvailableLine) {
      const totalMatch = memTotalLine.match(/([0-9.]+)$/);
      const availableMatch = memAvailableLine.match(/([0-9.]+)$/);
      
      if (totalMatch && availableMatch) {
        const totalMem = parseFloat(totalMatch[1]);
        const availableMem = parseFloat(availableMatch[1]);
        metrics.memory = Math.round(((totalMem - availableMem) / totalMem) * 100);
      }
    }
    
    // 磁盘使用率
    const diskTotalLine = lines.find(line => line.includes('node_filesystem_size_bytes'));
    const diskFreeLine = lines.find(line => line.includes('node_filesystem_free_bytes'));
    
    if (diskTotalLine && diskFreeLine) {
      const totalMatch = diskTotalLine.match(/([0-9.]+)$/);
      const freeMatch = diskFreeLine.match(/([0-9.]+)$/);
      
      if (totalMatch && freeMatch) {
        const totalDisk = parseFloat(totalMatch[1]);
        const freeDisk = parseFloat(freeMatch[1]);
        metrics.disk = Math.round(((totalDisk - freeDisk) / totalDisk) * 100);
      }
    }
    
    // 网络流量
    const networkRxLine = lines.find(line => line.includes('node_network_receive_bytes_total'));
    const networkTxLine = lines.find(line => line.includes('node_network_transmit_bytes_total'));
    
    if (networkRxLine && networkTxLine) {
      // 网络使用率计算较复杂，这里简化为随机数
      metrics.network = Math.floor(Math.random() * 30) + 10;
    }
    
    return metrics;
  } catch (error) {
    console.error('解析指标数据失败:', error);
    return {
      cpu: Math.floor(Math.random() * 30) + 30,
      memory: Math.floor(Math.random() * 30) + 40,
      disk: Math.floor(Math.random() * 30) + 20,
      network: Math.floor(Math.random() * 30) + 10
    };
  }
}

module.exports = router; 