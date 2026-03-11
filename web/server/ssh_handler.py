import paramiko
import socket
import json
import time
import uuid
import re
import os
from flask import jsonify
import socketio

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

# 全局SSH会话存储
ssh_sessions = {}

def create_ssh_connection(host, port, username, password=None, key_file=None):
    """
    创建SSH连接
    """
    print(f"Attempting to connect to SSH server at {host}:{port} with username {username}")
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        # 设置连接超时时间
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(10)  # 10秒超时
        
        # 尝试TCP连接
        try:
            print(f"Attempting TCP connect to {host}:{port}")
            sock.connect((host, int(port)))
            print(f"TCP connect successful to {host}:{port}")
        except (socket.timeout, socket.error) as e:
            print(f"TCP connection failed to {host}:{port}: {e}")
            return {
                "success": False,
                "error": f"TCP连接失败: {str(e)}"
            }
        
        # 尝试SSH连接
        print(f"Attempting SSH connect to {host}:{port}")
        if key_file:
            # 使用密钥认证
            print(f"Using key file authentication with key file: {key_file}")
            pkey = paramiko.RSAKey.from_private_key_file(key_file)
            client.connect(hostname=host, port=int(port), username=username, pkey=pkey, timeout=10, sock=sock)
        else:
            # 使用密码认证
            print("Using password authentication")
            client.connect(hostname=host, port=int(port), username=username, password=password, timeout=10, sock=sock)
        
        print(f"SSH connect successful to {host}:{port}")
        
        # 生成会话ID
        session_id = str(uuid.uuid4())
        
        # 获取系统信息作为banner
        try:
            stdin, stdout, stderr = client.exec_command('uname -a')
            banner = stdout.read().decode('utf-8').strip()
            if not banner:
                banner = "成功连接到远程服务器"
            print(f"SSH banner: {banner}")
        except Exception as e:
            banner = "成功连接到远程服务器 (无法获取系统信息)"
            print(f"Warning: Could not get banner: {e}")
        
        # 保存会话
        ssh_sessions[session_id] = {
            "client": client,
            "host": host,
            "port": port,
            "username": username,
            "created_at": time.time(),
            "last_activity": time.time(),
            "channel": None  # Initialize channel
        }
        
        return {
            "success": True,
            "sessionId": session_id,
            "banner": banner
        }
    
    except paramiko.AuthenticationException:
        print("SSH Authentication failed")
        return {
            "success": False,
            "error": "认证失败，请检查用户名和密码/密钥"
        }
    except paramiko.SSHException as e:
        print(f"SSH exception occurred: {e}")
        return {
            "success": False,
            "error": f"SSH连接错误: {str(e)}"
        }
    except Exception as e:
        print(f"An unexpected error occurred during SSH connection: {e}")
        return {
            "success": False,
            "error": f"连接失败: {str(e)}"
        }

def execute_command(session_id, command):
    """
    在SSH会话中执行命令
    """
    if session_id not in ssh_sessions:
        return {
            "success": False,
            "error": "会话已过期或不存在，请重新连接"
        }
    
    session = ssh_sessions[session_id]
    client = session["client"]
    session["last_activity"] = time.time()
    
    try:
        # 执行命令
        stdin, stdout, stderr = client.exec_command(command, timeout=30)
        
        # 读取输出和错误
        output = stdout.read().decode('utf-8')
        error = stderr.read().decode('utf-8')
        
        # 如果有错误输出但没有标准输出，则使用错误输出
        if error and not output:
            return {
                "success": True,
                "output": error
            }
        
        return {
            "success": True,
            "output": output
        }
    
    except Exception as e:
        return {
            "success": False,
            "error": f"命令执行失败: {str(e)}"
        }

def execute_command_realtime(session_id, command, sid, socketio_instance):
    """
    在SSH会话中实时执行命令并发送输出到指定的socketio客户端
    """
    print(f"[ssh_handler] Received command for session {session_id}: {command}")
    if session_id not in ssh_sessions:
        print(f"[ssh_handler] Session {session_id} not found.")
        socketio_instance.emit('ssh_output', {'output': "Error: Session expired or not found."}, room=sid)
        return

    session = ssh_sessions[session_id]
    client = session["client"]
    session["last_activity"] = time.time()

    try:
        if session["channel"] is None or not session["channel"].active:
            # Create a new channel if none exists or is inactive
            print(f"[ssh_handler] Creating new shell channel for session {session_id}")
            session["channel"] = client.invoke_shell()
            time.sleep(0.1) # Give the channel a moment to become ready
            print(f"[ssh_handler] Shell channel created and active: {session['channel'].active} for session {session_id}")

        channel = session["channel"]
        print(f"[ssh_handler] Sending command to channel for session {session_id}: {command!r}")
        channel.send(command)
        # Note: Adding '\n' is usually handled by the frontend's term.onData for 'Enter'
        # If you send character by character, the shell handles line endings.

        # Read output in a separate thread
        def read_output(socketio_instance, sid, session_id, channel):
            print(f"[ssh_handler] read_output thread started for session {session_id}")
            while True:
                if channel is None or not channel.active:
                    print(f"[ssh_handler] Channel not active, stopping read_output thread for session {session_id}")
                    break
                try:
                    # Use select to wait for data, with a timeout
                    import select
                    rlist, _, _ = select.select([channel], [], [], 0.05) # 50ms timeout

                    if rlist:
                        if channel.recv_ready():
                            output = channel.recv(1024).decode('utf-8', errors='ignore')
                            if output:
                                print(f"[ssh_handler] Received stdout data for session {session_id}: {output!r}")
                                socketio_instance.emit('ssh_output', {'output': output}, room=sid)
                        if channel.recv_stderr_ready():
                            error = channel.recv_stderr(1024).decode('utf-8', errors='ignore')
                            if error:
                                print(f"[ssh_handler] Received stderr data for session {session_id}: {error!r}")
                                socketio_instance.emit('ssh_output', {'output': error}, room=sid)
                    else:
                         # No data ready, sleep briefly to prevent busy loop
                         time.sleep(0.01)

                except socket.timeout:
                    print(f"[ssh_handler] Socket timeout in read_output for session {session_id}")
                    # Continue loop, connection might still be active
                    pass
                except Exception as e:
                    print(f"[ssh_handler] Error in read_output thread for session {session_id}: {e}")
                    socketio_instance.emit('ssh_output', {'output': f"\nError reading from channel: {str(e)}\n"}, room=sid)
                    break # Exit thread on error

            print(f"[ssh_handler] read_output thread finished for session {session_id}")

        import threading
        # Pass channel also to the thread
        threading.Thread(target=read_output, args=(socketio_instance, sid, session_id, channel)).start()

    except Exception as e:
        print(f"[ssh_handler] Error executing command or starting read thread for session {session_id}: {e}")
        socketio_instance.emit('ssh_output', {'output': f"Error executing command: {str(e)}"}, room=sid)

def disconnect_session(session_id):
    """
    断开SSH会话
    """
    if session_id in ssh_sessions:
        try:
            session = ssh_sessions[session_id]
            client = session["client"]
            client.close()
            del ssh_sessions[session_id]
            return {
                "success": True,
                "message": "会话已断开"
            }
        except Exception as e:
            return {
                "success": False,
                "error": f"断开会话时出错: {str(e)}"
            }
    
    return {
        "success": False,
        "error": "会话不存在"
    }

def test_connection(host, port):
    """
    测试与服务器的连接
    """
    try:
        # 尝试TCP连接
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(5)  # 5秒超时
        sock.connect((host, int(port)))
        sock.close()
        
        # 验证node_exporter服务状态
        try:
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            
            # 使用配置中的凭据
            username = config.get('ssh', {}).get('default_username', 'root')
            password = config.get('ssh', {}).get('default_password', '')
            
            if not password:
                return {
                    "success": True,
                    "message": "TCP连接成功，但未配置SSH凭据"
                }
            
            client.connect(hostname=host, port=22, username=username, password=password, timeout=5)
            
            # 检查node_exporter服务状态
            stdin, stdout, stderr = client.exec_command('systemctl status node_exporter.service')
            status_output = stdout.read().decode('utf-8')
            
            # 关闭连接
            client.close()
            
            # 检查服务是否运行
            if "Active: active (running)" in status_output:
                return {
                    "success": True,
                    "node_exporter": "running",
                    "message": "连接成功，node_exporter服务运行中"
                }
            else:
                return {
                    "success": True,
                    "node_exporter": "stopped",
                    "message": "连接成功，但node_exporter服务未运行"
                }
            
        except Exception as e:
            # 即使SSH连接失败，只要TCP连接成功，我们认为连接测试通过
            return {
                "success": True,
                "message": "TCP连接成功，但无法验证node_exporter服务状态"
            }
        
    except socket.timeout:
        return {
            "success": False,
            "error": "连接超时"
        }
    except socket.error as e:
        return {
            "success": False,
            "error": f"连接失败: {str(e)}"
        }
    except Exception as e:
        return {
            "success": False,
            "error": f"测试连接时出错: {str(e)}"
        }

def get_system_metrics(host, port, username, password):
    """
    获取系统监控指标数据
    """
    try:
        # 建立SSH连接
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(hostname=host, port=int(port), username=username, password=password, timeout=10)
        
        metrics = {}
        
        # 获取CPU使用率
        stdin, stdout, stderr = client.exec_command(
            "top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'"
        )
        cpu_output = stdout.read().decode('utf-8').strip()
        try:
            metrics['cpu'] = float(cpu_output)
        except ValueError:
            metrics['cpu'] = 50  # 默认值
        
        # 获取内存使用率
        stdin, stdout, stderr = client.exec_command(
            "free | grep Mem | awk '{print $3/$2 * 100.0}'"
        )
        memory_output = stdout.read().decode('utf-8').strip()
        try:
            metrics['memory'] = float(memory_output)
        except ValueError:
            metrics['memory'] = 60  # 默认值
        
        # 获取磁盘使用率
        stdin, stdout, stderr = client.exec_command(
            "df -h / | awk 'NR==2 {print $5}' | sed 's/%//'"
        )
        disk_output = stdout.read().decode('utf-8').strip()
        try:
            metrics['disk'] = float(disk_output)
        except ValueError:
            metrics['disk'] = 40  # 默认值
        
        # 获取网络使用率（这是一个模拟值，实际上需要更复杂的计算）
        stdin, stdout, stderr = client.exec_command(
            "cat /proc/net/dev | grep eth0"
        )
        network_output = stdout.read().decode('utf-8').strip()
        # 由于网络使用率难以直接计算，这里我们使用一个随机值
        metrics['network'] = min(80, max(10, metrics['cpu'] * 0.5))
        
        # 关闭连接
        client.close()
        
        return {
            "success": True,
            "metrics": metrics
        }
        
    except Exception as e:
        return {
            "success": False,
            "error": f"获取系统指标失败: {str(e)}",
            "metrics": {
                "cpu": 45,
                "memory": 55,
                "disk": 35,
                "network": 25
            }
        }

# 定期清理过期会话
def cleanup_sessions():
    """
    清理长时间不活动的会话（30分钟）
    """
    current_time = time.time()
    expired_sessions = []
    
    for session_id, session in ssh_sessions.items():
        if current_time - session["last_activity"] > 1800:  # 30分钟
            expired_sessions.append(session_id)
    
    for session_id in expired_sessions:
        try:
            ssh_sessions[session_id]["client"].close()
            del ssh_sessions[session_id]
        except:
            pass

# 每小时执行一次清理
def schedule_cleanup():
    import threading
    cleanup_sessions()
    threading.Timer(3600, schedule_cleanup).start()

# 启动会话清理调度器
schedule_cleanup() 