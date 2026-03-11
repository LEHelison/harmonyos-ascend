# 智慧工厂系统

这是一个智慧工厂管理系统，包含用户认证、人员监测、远程控制等功能。

## 系统要求

- Node.js (v14+)
- MongoDB (v4+)
- npm 或 yarn

## 安装说明

### 前端安装

1. 安装依赖

```bash
npm install
```

2. 开发模式运行

```bash
npm run dev
```

3. 构建生产版本

```bash
npm run build
```

### 后端安装

1. 进入server目录

```bash
cd server
```

2. 安装依赖

```bash
npm install
```

3. 运行服务器

```bash
npm run dev
```

## 功能说明

- 用户注册/登录：支持用户账号创建和登录认证
- 验证码功能：使用svg-captcha生成图形验证码
- JWT认证：实现安全的用户会话管理
- 权限控制：通过路由守卫实现页面访问控制

## 技术栈

### 前端
- Vue 3
- Vue Router
- Element Plus
- Axios

### 后端
- Express.js
- MongoDB (Mongoose)
- JSON Web Token
- bcrypt.js (密码加密)

## 目录结构

```
├── public/             # 静态资源
├── server/             # 后端服务
│   ├── config/         # 配置文件
│   ├── models/         # 数据模型
│   ├── routes/         # 路由控制器
│   └── index.js        # 服务入口
├── src/                # 前端源码
│   ├── api/            # API请求
│   ├── assets/         # 资源文件
│   ├── components/     # 组件
│   ├── router/         # 路由
│   ├── utils/          # 工具函数
│   ├── views/          # 页面
│   ├── App.vue         # 主组件
│   └── main.js         # 入口文件
└── vite.config.js      # Vite配置
```

## 开发注意事项

1. 默认MongoDB连接地址为 `mongodb://localhost:27017/smart_factory`
2. 后端API服务默认运行在3000端口
3. 前端开发服务器会自动代理API请求到后端
