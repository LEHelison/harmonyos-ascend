const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root', // 请替换为你的MySQL用户名
  password: '123456', // 请替换为你的MySQL密码
  database: 'smart_factory',
  port: 3306
});

module.exports = pool; 