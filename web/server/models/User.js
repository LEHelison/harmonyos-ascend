const pool = require('../config/db');
const bcrypt = require('bcryptjs');

const User = {
  async findByUsername(username) {
    const [rows] = await pool.query('SELECT * FROM users WHERE username = ?', [username]);
    return rows[0];
  },
  async findById(id) {
    const [rows] = await pool.query('SELECT * FROM users WHERE id = ?', [id]);
    return rows[0];
  },
  async create({ username, password }) {
    const hash = await bcrypt.hash(password, 10);
    const [result] = await pool.query(
      'INSERT INTO users (username, password) VALUES (?, ?)',
      [username, hash]
    );
    return { id: result.insertId, username };
  },
  async comparePassword(raw, hash) {
    return bcrypt.compare(raw, hash);
  },
  async updateLastLogin(id) {
    await pool.query('UPDATE users SET lastLogin = NOW() WHERE id = ?', [id]);
  },
  async updateProfile(id, { name, email, phone, department }) {
    await pool.query(
      'UPDATE users SET name=?, email=?, phone=?, department=? WHERE id=?',
      [name, email, phone, department, id]
    );
  },
  async updatePassword(id, newPassword) {
    const hash = await bcrypt.hash(newPassword, 10);
    await pool.query('UPDATE users SET password=? WHERE id=?', [hash, id]);
  }
};

module.exports = User; 