---
title: "Linux 网络管理"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# Linux 网络管理

## 1. 网络基础配置

### 1.1 网络接口配置

```bash
ifconfig    # 配置网络接口
ip addr     # 现代化的网络配置工具
iwconfig    # 无线网络配置
nmcli       # NetworkManager命令行工具
```

### 1.2 网络配置文件

- **/etc/network/interfaces**
- **/etc/sysconfig/network-scripts/**
- **/etc/resolv.conf**
- **/etc/hosts**

## 2. 网络连接测试

### 2.1 基本测试工具

```bash
ping        # ICMP测试
traceroute  # 路由跟踪
mtr         # 网络诊断工具
nslookup    # DNS查询
dig         # DNS查询工具
```

### 2.2 端口和服务

```bash
netstat     # 网络统计
ss          # Socket统计
lsof -i     # 查看网络相关文件
nmap        # 端口扫描
```

## 3. 网络监控

### 3.1 流量监控

```bash
iftop       # 实时流量监控
nethogs     # 进程网络流量监控
iptraf      # IP流量监控
tcpdump     # 数据包抓取
wireshark   # 图形化抓包工具
```

### 3.2 带宽测试

```bash
iperf3      # 带宽测试工具
speedtest   # 网速测试
```

## 4. 防火墙管理

### 4.1 iptables

```bash
iptables -L # 查看规则
iptables -A # 添加规则
iptables -D # 删除规则
iptables-save # 保存规则
```

### 4.2 firewalld

```bash
firewall-cmd --list-all    # 查看所有规则
firewall-cmd --add-port    # 添加端口
firewall-cmd --remove-port # 删除端口
firewall-cmd --reload      # 重载规则
```

## 5. 网络服务配置

### 5.1 常见服务

- **SSH**
- **FTP**
- **HTTP/HTTPS**
- **DNS**
- **DHCP**

### 5.2 服务管理

```bash
systemctl status sshd      # 查看服务状态
systemctl start nginx      # 启动服务
systemctl enable httpd     # 设置开机启动
```

## 6. 网络故障排查

### 6.1 常见问题

1. **连接问题**

   - DNS 解析
   - 路由配置
   - 防火墙规则

2. **性能问题**
   - 带宽使用
   - 延迟高
   - 丢包

### 6.2 排查工具

```bash
ping        # 连通性测试
traceroute  # 路由跟踪
tcpdump     # 抓包分析
netstat     # 连接状态
```

## 7. 高级网络特性

### 7.1 网络桥接

```bash
brctl show  # 查看网桥
brctl addbr # 添加网桥
brctl delbr # 删除网桥
```

### 7.2 网络虚拟化

- **Docker 网络**
- **KVM 网络**
- **OpenVSwitch**

## 8. 面试重点

1. **网络协议**

   - TCP/IP 协议栈
   - 常见端口号
   - 三次握手/四次挥手

2. **网络安全**

   - 防火墙配置
   - SSH 安全
   - 常见攻击防范

3. **故障排查**

   - 网络连接问题
   - 性能问题
   - DNS 问题

4. **网络工具**

   - 常用命令使用
   - 监控工具
   - 调试方法

5. **实际场景**
   - 负载均衡配置
   - VPN 搭建
   - 网络性能优化
   - 安全加固方案

