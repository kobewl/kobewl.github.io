---
title: "Python 网络编程"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# Python 网络编程

## 一、网络编程基础
### 1. 网络通信模型

- TCP/IP协议族
  - 应用层（HTTP、FTP、SMTP等）
  - 传输层（TCP、UDP）
  - 网络层（IP）
  - 链路层（以太网等）

- 套接字（Socket）
  - 网络通信端点
  - IP地址和端口号
  - 支持TCP和UDP协议

### 2. 网络地址

- IP地址
  ```python
  import socket
  
  # 获取主机名
  hostname = socket.gethostname()
  # 获取IP地址
  ip_address = socket.gethostbyname(hostname)
  ```

- 端口
  - 0-1023：系统保留端口
  - 1024-65535：用户可用端口

## 二、Socket编程
### 1. TCP Socket

- 服务器端
  ```python
  import socket

  # 创建TCP Socket
  server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  # 绑定地址和端口
  server_socket.bind(('localhost', 8000))
  # 开始监听
  server_socket.listen(5)

  while True:
      # 接受客户端连接
      client_socket, address = server_socket.accept()
      print(f"Connection from {address}")
      
      # 接收数据
      data = client_socket.recv(1024)
      if not data:
          break
          
      # 发送响应
      client_socket.send(b"Hello from server")
      
      # 关闭连接
      client_socket.close()
  ```

- 客户端
  ```python
  import socket

  # 创建客户端Socket
  client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  # 连接服务器
  client_socket.connect(('localhost', 8000))
  
  # 发送数据
  client_socket.send(b"Hello from client")
  
  # 接收响应
  response = client_socket.recv(1024)
  print(response.decode())
  
  # 关闭连接
  client_socket.close()
  ```

### 2. UDP Socket

- 服务器端
  ```python
  import socket

  # 创建UDP Socket
  server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  server_socket.bind(('localhost', 8000))

  while True:
      # 接收数据和客户端地址
      data, address = server_socket.recvfrom(1024)
      print(f"Received from {address}: {data.decode()}")
      
      # 发送响应
      server_socket.sendto(b"Hello from server", address)
  ```

- 客户端
  ```python
  import socket

  # 创建UDP Socket
  client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  
  # 发送数据
  client_socket.sendto(b"Hello from client", ('localhost', 8000))
  
  # 接收响应
  data, server = client_socket.recvfrom(1024)
  print(f"Received: {data.decode()}")
  ```

## 三、HTTP编程
### 1. HTTP客户端

- requests库
  ```python
  import requests

  # GET请求
  response = requests.get('https://api.example.com/data')
  print(response.json())

  # POST请求
  data = {'key': 'value'}
  response = requests.post('https://api.example.com/create', json=data)
  ```

- urllib库
  ```python
  from urllib import request

  # 发送GET请求
  with request.urlopen('https://api.example.com/data') as response:
      data = response.read()
      print(data.decode())
  ```

### 2. HTTP服务器

- http.server模块
  ```python
  from http.server import HTTPServer, BaseHTTPRequestHandler

  class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
      def do_GET(self):
          self.send_response(200)
          self.send_header('Content-type', 'text/html')
          self.end_headers()
          self.wfile.write(b"Hello, World!")

  # 启动服务器
  httpd = HTTPServer(('localhost', 8000), SimpleHTTPRequestHandler)
  httpd.serve_forever()
  ```

- Flask框架
  ```python
  from flask import Flask, jsonify

  app = Flask(__name__)

  @app.route('/api/data')
  def get_data():
      return jsonify({'message': 'Hello, World!'})

  if __name__ == '__main__':
      app.run(port=8000)
  ```

## 四、异步网络编程
### 1. asyncio

- 异步TCP服务器
  ```python
  import asyncio

  async def handle_client(reader, writer):
      data = await reader.read(100)
      message = data.decode()
      addr = writer.get_extra_info('peername')
      
      print(f"Received {message} from {addr}")
      
      response = f"Message received"
      writer.write(response.encode())
      await writer.drain()
      
      writer.close()

  async def main():
      server = await asyncio.start_server(
          handle_client, 'localhost', 8000)
      
      async with server:
          await server.serve_forever()

  asyncio.run(main())
  ```

### 2. aiohttp

- 异步HTTP客户端
  ```python
  import aiohttp
  import asyncio

  async def fetch_data(url):
      async with aiohttp.ClientSession() as session:
          async with session.get(url) as response:
              return await response.text()

  async def main():
      urls = [
          'http://api.example.com/data1',
          'http://api.example.com/data2'
      ]
      tasks = [fetch_data(url) for url in urls]
      results = await asyncio.gather(*tasks)
      print(results)

  asyncio.run(main())
  ```

## 五、网络安全
### 1. SSL/TLS

- 安全Socket层
  ```python
  import ssl
  import socket

  context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
  context.load_cert_chain(certfile="server.crt", keyfile="server.key")

  with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
      with context.wrap_socket(sock, server_side=True) as ssock:
          ssock.bind(('localhost', 8000))
          ssock.listen(5)
  ```

### 2. 数据加密

- 使用cryptography
  ```python
  from cryptography.fernet import Fernet

  # 生成密钥
  key = Fernet.generate_key()
  f = Fernet(key)

  # 加密数据
  message = b"Secret message"
  encrypted = f.encrypt(message)

  # 解密数据
  decrypted = f.decrypt(encrypted)
  ```

## 六、最佳实践

1. 错误处理
   - 捕获网络异常
   - 实现重试机制
   - 超时处理

2. 性能优化
   - 使用连接池
   - 实现并发处理
   - 合理设置缓冲区大小

3. 安全考虑
   - 输入验证
   - 加密传输
   - 访问控制

4. 调试技巧
   - 使用wireshark抓包
   - 日志记录
   - 性能分析
