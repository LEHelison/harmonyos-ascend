@echo off
echo 正在启动智慧工厂应用...
echo 后端API服务将在端口5000启动
echo 前端服务将在默认端口启动

start cmd /k "python server/app.py"
start cmd /k "npm run dev"

echo 成功启动所有服务! 