---
title: "Linux 进程管理"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# Linux 进程管理

## 1. 进程基础

### 1.1 进程概念

- **定义**：运行中的程序实例
- **特征**：
  - PID（进程 ID）
  - PPID（父进程 ID）
  - 进程优先级
  - 资源占用

### 1.2 进程状态

- **R (Running)**：运行中
- **S (Sleep)**：可中断睡眠
- **D (Disk Sleep)**：不可中断睡眠
- **T (Stopped)**：停止
- **Z (Zombie)**：僵尸进程
- **X (Dead)**：死亡

## 2. 进程管理命令

### 2.1 查看进程

```bash
ps aux     # 查看所有进程
top        # 动态查看进程
htop       # 增强版top
pstree     # 进程树
```

### 2.2 进程控制

```bash
kill       # 发送信号给进程
killall    # 按名称结束进程
pkill      # 按模式匹配结束进程
nice       # 调整优先级
renice     # 修改已运行进程优先级
```

### 2.3 常用信号

- **SIGTERM (15)**：正常终止
- **SIGKILL (9)**：强制终止
- **SIGSTOP**：暂停
- **SIGCONT**：继续
- **SIGHUP**：重新加载

## 3. 进程监控

### 3.1 系统负载

```bash
uptime     # 系统负载
vmstat     # 虚拟内存统计
iostat     # IO统计
sar        # 系统活动报告
```

### 3.2 资源使用

```bash
free       # 内存使用
df         # 磁盘使用
du         # 目录空间
lsof       # 打开的文件
```

## 4. 守护进程

### 4.1 特征

- 后台运行
- 无控制终端
- 独立的会话
- 特定目录为根目录

### 4.2 管理工具

```bash
systemctl  # systemd管理工具
service    # SysV初始化脚本
```

## 5. 进程通信(IPC)

### 5.1 通信方式

- 管道(pipe)
- 信号(signal)
- 消息队列
- 共享内存
- 信号量
- Socket

### 5.2 相关命令

```bash
ipcs       # 查看IPC资源
ipcrm      # 删除IPC资源
```

## 6. 进程调度

### 6.1 调度策略

- **SCHED_OTHER**：默认
- **SCHED_FIFO**：实时
- **SCHED_RR**：实时轮转
- **SCHED_BATCH**：批处理
- **SCHED_IDLE**：空闲

### 6.2 优先级管理

- nice 值范围：-20 到 19
- 实时优先级：1 到 99
- 动态优先级
- 静态优先级

## 7. 面试重点

1. **进程 vs 线程**

   - 区别
   - 使用场景
   - 资源占用

2. **进程状态**

   - 各状态含义
   - 状态转换
   - 僵尸进程处理

3. **系统负载**

   - Load Average 解释
   - 性能问题排查
   - 资源监控方法

4. **进程通信**

   - 各种 IPC 方式比较
   - 使用场景
   - 优缺点分析

5. **实际问题处理**
   - CPU 占用高排查
   - 内存泄漏定位
   - 僵尸进程清理
   - 服务进程管理

