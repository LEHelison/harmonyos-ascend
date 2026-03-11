const express = require('express');
const router = express.Router();
const db = require('../config/database');

// 获取环境监控数据
router.get('/environment', async (req, res) => {
  try {
    const { factory_id, start_date, end_date } = req.query;
    let query = `
            SELECT em.*, f.name as factory_name 
            FROM environment_monitoring em
            JOIN factories f ON em.factory_id = f.id
            WHERE 1=1
        `;
    const params = [];

    if (factory_id && factory_id !== 'all') {
      query += ' AND em.factory_id = ?';
      params.push(factory_id);
    }

    if (start_date && end_date) {
      query += ' AND em.created_at BETWEEN ? AND ?';
      params.push(start_date, end_date);
    }

    query += ' ORDER BY em.created_at DESC';

    const [rows] = await db.query(query, params);
    res.json(rows);
  } catch (error) {
    console.error('获取环境监控数据失败:', error);
    res.status(500).json({ error: '获取环境监控数据失败' });
  }
});

// 获取生产统计数据
router.get('/production', async (req, res) => {
  try {
    const { factory_id, start_date, end_date } = req.query;
    let query = `
            SELECT ps.*, f.name as factory_name 
            FROM production_statistics ps
            JOIN factories f ON ps.factory_id = f.id
            WHERE 1=1
        `;
    const params = [];

    if (factory_id && factory_id !== 'all') {
      query += ' AND ps.factory_id = ?';
      params.push(factory_id);
    }

    if (start_date && end_date) {
      query += ' AND ps.date BETWEEN ? AND ?';
      params.push(start_date, end_date);
    }

    query += ' ORDER BY ps.date DESC';

    const [rows] = await db.query(query, params);
    res.json(rows);
  } catch (error) {
    console.error('获取生产统计数据失败:', error);
    res.status(500).json({ error: '获取生产统计数据失败' });
  }
});

// 获取工厂列表
router.get('/factories', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM factories');
    res.json(rows);
  } catch (error) {
    console.error('获取工厂列表失败:', error);
    res.status(500).json({ error: '获取工厂列表失败' });
  }
});

// 添加环境监控数据
router.post('/environment', async (req, res) => {
  try {
    const { factory_id, temperature, humidity, pm25, noise } = req.body;
    const [result] = await db.query(
      'INSERT INTO environment_monitoring (factory_id, temperature, humidity, pm25, noise) VALUES (?, ?, ?, ?, ?)',
      [factory_id, temperature, humidity, pm25, noise]
    );
    res.json({ id: result.insertId, message: '环境监控数据添加成功' });
  } catch (error) {
    console.error('添加环境监控数据失败:', error);
    res.status(500).json({ error: '添加环境监控数据失败' });
  }
});

// 添加生产统计数据
router.post('/production', async (req, res) => {
  try {
    const { factory_id, total_production, qualified_products, defective_products, defect_rate, date } = req.body;
    const [result] = await db.query(
      'INSERT INTO production_statistics (factory_id, total_production, qualified_products, defective_products, defect_rate, date) VALUES (?, ?, ?, ?, ?, ?)',
      [factory_id, total_production, qualified_products, defective_products, defect_rate, date]
    );
    res.json({ id: result.insertId, message: '生产统计数据添加成功' });
  } catch (error) {
    console.error('添加生产统计数据失败:', error);
    res.status(500).json({ error: '添加生产统计数据失败' });
  }
});

module.exports = router; 