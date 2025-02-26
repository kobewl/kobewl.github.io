---
title: "1 Linux 系统调优"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Linux 系统调优

## 1.1 性能监控

### 1.1.1 系统负载

```bash
uptime      # 系统负载
top/htop    # 进程监控
vmstat      # 虚拟内存统计
mpstat      # CPU统计
```

### 1.1.2 内存监控

```bash
free        # 内存使用
vmstat      # 虚拟内存统计
pmap        # 进程内存映射
slabtop     # 内核slab缓存信息
```

### 1.1.3 IO 监控

```bash
iostat      # IO统计
iotop       # IO使用top
pidstat     # 进程统计
```

## 1.2 CPU 调优

### 1.2.1 CPU 频率调节

```bash
cpufreq-info    # CPU频率信息
cpufreq-set     # 设置CPU频率
```

### 1.2.2 进程优先级

```bash
nice        # 启动时设置优先级
renice      # 运行时调整优先级
chrt        # 实时进程优先级
```

### 1.2.3 CPU 亲和性

```bash
taskset     # 设置CPU亲和性
```

## 1.3 内存调优

### 1.3.1 系统参数

```bash
# /proc/sys/vm/
swappiness              # 交换区使用倾向
dirty_ratio             # 脏页比例
dirty_background_ratio  # 后台刷新脏页比例
```

### 1.3.2 内存管理

```bash
echo 3 > /proc/sys/vm/drop_caches    # 清理缓存
ulimit -m                            # 限制进程内存
```

## 1.4 磁盘 IO 调优

### 1.4.1 IO 调度器

```bash
# /sys/block/设备名/queue/scheduler
noop        # 电梯算法
deadline    # 截止时间调度
cfq         # 完全公平队列
```

### 1.4.2 文件系统优化

```bash
tune2fs     # ext文件系统调优
xfs_info    # xfs文件系统信息
```

## 1.5 网络调优

### 1.5.1 TCP 参数

```bash
# /proc/sys/net/ipv4/
tcp_wmem                # 发送缓冲区
tcp_rmem                # 接收缓冲区
tcp_keepalive_time      # keepalive时间
```

### 1.5.2 网络接口

```bash
ethtool     # 网卡参数调整
tc          # 流量控制
```

## 1.6 内核参数调优

### 1.6.1 sysctl 参数

```bash
# /etc/sysctl.conf
fs.file-max             # 最大文件句柄
net.core.somaxconn      # 最大连接队列
vm.overcommit_memory    # 内存分配策略
```

### 1.6.2 系统限制

```bash
# /etc/security/limits.conf
nofile      # 文件描述符限制
nproc       # 进程数限制
memlock     # 锁定内存限制
```

## 1.7 应用级调优

### 1.7.1 JVM 调优

```bash
-Xms        # 初始堆大小
-Xmx        # 最大堆大小
-XX:+UseG1GC # 使用G1垃圾收集器
```

### 1.7.2 Web 服务器

```bash
worker_processes    # Nginx工作进程
worker_connections  # 最大连接数
keepalive_timeout  # 保持连接超时
```

## 1.8 性能测试

### 1.8.1 压力测试工具

```bash
ab          # Apache压测工具
siege       # HTTP压测
stress      # 系统压力测试
sysbench    # 系统基准测试
```

### 1.8.2 性能分析工具

```bash
perf        # 性能分析
strace      # 系统调用跟踪
ltrace      # 库函数调用跟踪
```

## 1.9 最佳实践

1. **系统配置**

   - 合理配置 swap
   - 优化文件系统
   - 调整系统限制

2. **应用优化**
   - 合理分配资源
   - 选择适当的配置
   - 定期维护和清理

## 1.10 面试重点

1. **性能指标**

   - Load Average 解释
   - CPU 使用率分析
   - 内存使用情况
   - IO 等待时间

2. **调优方法**

   - CPU 调度优化
   - 内存管理策略
   - IO 调度选择
   - 网络参数调整

3. **问题排查**

   - 性能瓶颈定位
   - 系统参数分析
   - 调优工具使用

4. **实际案例**

   - 高负载处理
   - 内存泄漏定位
   - IO 性能优化
   - 网络延迟优化

5. **最佳实践**
   - 性能监控方案
   - 调优流程
   - 参数选择依据
   - 优化效果评估

