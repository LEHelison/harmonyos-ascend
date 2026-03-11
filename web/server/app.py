from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import json
import ssh_handler
import requests
from flask_socketio import SocketIO, emit

app = Flask(__name__)
CORS(app)  # 允许所有跨域请求
socketio = SocketIO(app, cors_allowed_origins="*")

# 加载配置
def load_config():
    config_path = os.path.join(os.path.dirname(__file__), 'config', 'config.json')
    try:
        with open(config_path, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading config: {e}")
        return {}

config = load_config()

API_KEY = "app-Mr7yGM55LjGXaGyTPzp39MQr"
API_URL = "http://192.168.1.218:5001/api/query"  # 新AI服务接口

@app.route('/api/robots/test-connection', methods=['GET'])
def test_connection():
    """测试与远程服务器的连接"""
    ip = request.args.get('ip', '')
    port = request.args.get('port', '9100')
    
    if not ip:
        return jsonify({"success": False, "error": "IP地址不能为空"}), 400
    
    result = ssh_handler.test_connection(ip, int(port))
    return jsonify(result)

@app.route('/api/robots/save-robot-config', methods=['POST'])
def save_robot_config():
    """保存机器人配置"""
    data = request.json
    name = data.get('name', '')
    ip = data.get('ip', '')
    
    if not name or not ip:
        return jsonify({"success": False, "error": "名称和IP地址不能为空"}), 400
    
    # 这里可以添加保存到数据库的逻辑
    # 目前仅返回成功状态
    return jsonify({"success": True, "message": f"已保存 {name} 的配置"})

@app.route('/api/robots/ssh-connect', methods=['POST'])
def ssh_connect():
    """建立SSH连接"""
    data = request.json
    host = data.get('host', '')
    port = data.get('port', '22')
    username = data.get('username', 'root')
    auth_type = data.get('authType', 'password')
    password = data.get('password', '')
    key_file = data.get('keyFile', None)
    
    if not host:
        return jsonify({"success": False, "error": "主机地址不能为空"}), 400
    
    if auth_type == 'password' and not password:
        return jsonify({"success": False, "error": "使用密码认证时，密码不能为空"}), 400
    
    if auth_type == 'key' and not key_file:
        return jsonify({"success": False, "error": "使用密钥认证时，密钥文件不能为空"}), 400
    
    result = ssh_handler.create_ssh_connection(host, port, username, password, key_file)
    return jsonify(result)

@app.route('/api/robots/ssh-execute', methods=['POST'])
def ssh_execute():
    """执行SSH命令"""
    data = request.json
    session_id = data.get('sessionId', '')
    command = data.get('command', '')
    
    if not session_id:
        return jsonify({"success": False, "error": "会话ID不能为空"}), 400
    
    if not command:
        return jsonify({"success": False, "error": "命令不能为空"}), 400
    
    result = ssh_handler.execute_command(session_id, command)
    return jsonify(result)

@app.route('/api/robots/ssh-disconnect', methods=['POST'])
def ssh_disconnect():
    """断开SSH连接"""
    data = request.json
    session_id = data.get('sessionId', '')
    
    if not session_id:
        return jsonify({"success": False, "error": "会话ID不能为空"}), 400
    
    result = ssh_handler.disconnect_session(session_id)
    return jsonify(result)

@app.route('/api/robots/monitor/metrics', methods=['GET'])
def get_monitor_metrics():
    """获取监控指标数据"""
    ip = request.args.get('ip', '')
    port = request.args.get('port', '22')
    
    if not ip:
        return jsonify({"success": False, "error": "IP地址不能为空"}), 400
    
    # 从配置中获取凭据
    username = config.get('ssh', {}).get('default_username', 'root')
    password = config.get('ssh', {}).get('default_password', '')
    
    if not password:
        return jsonify({
            "success": False,
            "error": "未配置SSH凭据，请在配置文件中设置"
        }), 400
    
    result = ssh_handler.get_system_metrics(ip, port, username, password)
    return jsonify(result)

@app.route('/api/query', methods=['POST'])
def handle_query():
    data = request.get_json()
    query = data.get('query', '').strip()
    if not query:
        return jsonify({"error": "Query不能为空"}), 400

    payload = {
        "inputs": {},
        "query": query,
        "response_mode": "blocking",
        "user": "abc-123",
        "files": [{
            "type": "image",
            "transfer_method": "remote_url",
            "url": "https://cloud.dify.ai/logo/logo-site.png"
        }]
    }
    headers = {
        'Authorization': f'Bearer {API_KEY}',
        'Content-Type': 'application/json'
    }
    try:
        response = requests.post(API_URL, headers=headers, json=payload)
        response.raise_for_status()
        ai_result = response.json()
        # 适配前端预期格式
        if ai_result.get("choices") and ai_result["choices"][0].get("message"):
            answer = ai_result["choices"][0]["message"].get("content", "")
        else:
            answer = str(ai_result)
        return jsonify({"answer": answer})
    except Exception as e:
        print("AI服务调用失败：", e)
        return jsonify({"error": "AI服务调用失败", "details": str(e)}), 502

@socketio.on('ssh_connect')
def handle_ssh_connect(data):
    print(f"Received ssh_connect event: {data}")
    host = data.get('ip')
    port = data.get('port', '22')
    username = data.get('username', 'root') # Assuming default username is root
    auth_type = data.get('authType', 'password')
    password = data.get('password')
    key_file = data.get('keyFile', None) # Handle key file upload separately if needed

    if not host:
        emit('ssh_error', {'error': '主机地址不能为空'}, room=request.sid)
        return

    if auth_type == 'password' and not password:
         emit('ssh_error', {'error': '使用密码认证时，密码不能为空'}, room=request.sid)
         return

    # Note: Key file handling via Socket.IO requires different approach (e.g., sending file content)
    # For now, assuming password authentication or key file already on server
    if auth_type == 'key' and not key_file:
         # If key file is handled via upload before this, adjust logic.
         # Otherwise, this case might need more robust handling.
         print("Warning: Key file authentication requested but no file data provided.")
         # Optionally emit an error or handle as per your file upload mechanism

    try:
        # Call the function to create SSH connection
        result = ssh_handler.create_ssh_connection(host, port, username, password, key_file) # Assuming ssh_handler can handle keyFile path or content
        if result.get('success'):
            # Store session ID associated with the socket ID
            # This is a simple way; for production, use a more robust session management
            session_id = result.get('sessionId')
            # Assuming ssh_handler stores the session and associates it with session_id
            emit('ssh_connected', {'sessionId': session_id}, room=request.sid)
            print(f"SSH connected, session ID: {session_id}")
        else:
            error_message = result.get('error', '未知连接错误')
            emit('ssh_error', {'error': error_message}, room=request.sid)
            print(f"SSH connection failed: {error_message}")
    except Exception as e:
        print(f"Error during SSH connection attempt: {e}")
        emit('ssh_error', {'error': str(e)}, room=request.sid)

@socketio.on('ssh_command')
def handle_ssh_command(data):
    print(f"Received ssh_command event with data: {data}")
    session_id = data.get('sessionId')
    command = data.get('command')
    if session_id and command:
        # Assuming ssh_handler.execute_command_realtime sends output via emit to request.sid
        ssh_handler.execute_command_realtime(session_id, command, request.sid, socketio)
    else:
        print(f"Invalid data received for ssh_command: {data}")

# 启动服务器
if __name__ == '__main__':
    socketio.run(app=app, debug=True, host='0.0.0.0', port=5000)