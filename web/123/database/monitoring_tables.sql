-- 环境监控数据表
CREATE TABLE IF NOT EXISTS environment_monitoring (
    id INT AUTO_INCREMENT PRIMARY KEY,
    factory_id INT NOT NULL,
    temperature DECIMAL(5,2) NOT NULL,
    humidity DECIMAL(5,2) NOT NULL,
    pm25 DECIMAL(5,2) NOT NULL,
    noise DECIMAL(5,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (factory_id) REFERENCES factories(id)
);

-- 生产数据统计表
CREATE TABLE IF NOT EXISTS production_statistics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    factory_id INT NOT NULL,
    total_production INT NOT NULL,
    qualified_products INT NOT NULL,
    defective_products INT NOT NULL,
    defect_rate DECIMAL(5,2) NOT NULL,
    date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (factory_id) REFERENCES factories(id)
);

-- 工厂表
CREATE TABLE IF NOT EXISTS factories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status ENUM('normal', 'alert', 'danger') DEFAULT 'normal',
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 插入示例工厂数据
INSERT INTO factories (name) VALUES 
('厂区一'),
('厂区二'),
('厂区三'),
('厂区四'),
('厂区五'),
('厂区六'); 