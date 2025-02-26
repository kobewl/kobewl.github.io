---
mindmap-plugin: basic
---

# Linux 知识大纲

## 1. Linux 基础概念

### 1.1 Linux 发展史

- Unix 与 Linux 的关系
  - Unix 的历史
  - Linux 的诞生
  - GNU 计划
- Linux 发行版
  - RedHat 系列
    - RHEL
    - CentOS
    - Fedora
  - Debian 系列
    - Ubuntu
    - Debian
    - Deepin
  - 其他发行版
    - SUSE
    - Arch Linux
    - Gentoo

### 1.2 Linux 系统特点

- 开源性
  - GPL 协议
  - 开源社区
  - 技术创新
- 多用户多任务
  - 用户权限管理
  - 进程调度
  - 资源分配
- 安全性
  - 权限控制
  - SELinux
  - 防火墙
- 网络功能
  - TCP/IP 协议栈
  - 网络服务
  - 远程管理

## 2. Linux 文件系统

### 2.1 文件系统层次

- 根目录结构
  - /bin：基本命令
  - /sbin：系统命令
  - /etc：配置文件
  - /home：用户目录
  - /var：可变文件
  - /usr：应用程序
  - /tmp：临时文件
  - /proc：进程信息
  - /dev：设备文件
- 文件类型
  - 普通文件
  - 目录文件
  - 链接文件
  - 设备文件
  - 管道文件
  - 套接字文件

### 2.2 文件操作

- 基本操作
  - ls：列出文件
  - cd：切换目录
  - pwd：当前路径
  - mkdir：创建目录
  - rm：删除文件
  - cp：复制文件
  - mv：移动文件
- 文件权限
  - 权限类型
    - 读（r）
    - 写（w）
    - 执行（x）
  - 权限管理
    - chmod：修改权限
    - chown：修改所有者
    - chgrp：修改组
- 文件查找
  - find 命令
    - 按名称查找
    - 按时间查找
    - 按大小查找
  - locate 命令
  - grep 命令
    - 文本搜索
    - 正则表达式
    - 递归搜索

## 3. 进程管理

### 3.1 进程概念

- 进程定义
  - 程序的执行实例
  - 资源分配单位
  - 进程状态
- 进程属性
  - PID
  - PPID
  - 优先级
  - 状态
- 进程间通信
  - 管道
  - 信号
  - 共享内存
  - 消息队列
  - 信号量

### 3.2 进程控制

- 进程管理命令
  - ps：查看进程
  - top：动态监控
  - kill：终止进程
  - nice：调整优先级
- 作业控制
  - 前台作业
  - 后台作业
  - jobs 命令
  - bg/fg 命令
- 服务管理
  - systemctl
  - service
  - init.d 脚本

## 4. 系统管理

### 4.1 用户管理

- 用户操作
  - useradd：添加用户
  - userdel：删除用户
  - usermod：修改用户
  - passwd：密码管理
- 组管理
  - groupadd：添加组
  - groupdel：删除组
  - groupmod：修改组
  - gpasswd：组密码
- 权限管理
  - sudo 机制
  - su 命令
  - visudo 配置

### 4.2 系统监控

- 资源监控
  - CPU 使用率
  - 内存使用
  - 磁盘空间
  - 网络流量
- 日志管理
  - 系统日志
  - 应用日志
  - 日志轮转
- 性能优化
  - 系统调优
  - 服务优化
  - 资源限制

## 5. 网络管理

### 5.1 网络配置

- 网络参数
  - IP 地址
  - 子网掩码
  - 网关设置
  - DNS 配置
- 网络工具
  - ifconfig/ip
  - route
  - netstat
  - ss
- 网络服务
  - SSH
  - FTP
  - HTTP
  - NFS

### 5.2 网络安全

- 防火墙
  - iptables
  - firewalld
  - 规则配置
- 安全加固
  - 端口管理
  - 服务管理
  - 访问控制
- 安全工具
  - nmap
  - tcpdump
  - wireshark

## 6. Shell 编程

### 6.1 Shell 基础

- Shell 类型
  - bash
  - sh
  - zsh
  - csh
- 基本语法
  - 变量
  - 条件判断
  - 循环结构
  - 函数定义
- 脚本编写
  - 注释规范
  - 错误处理
  - 调试技巧

### 6.2 Shell 工具

- 文本处理
  - awk
  - sed
  - cut
  - sort
- 正则表达式
  - 基本正则
  - 扩展正则
  - Perl 正则
- 管道和重定向
  - 标准输入输出
  - 管道使用
  - 重定向技巧

## 7. 系统调优

### 7.1 性能优化

- CPU 优化
  - 进程调度
  - 负载均衡
  - 中断处理
- 内存优化
  - 内存分配
  - 交换空间
  - 缓存管理
- I/O 优化
  - 磁盘调度
  - 文件系统
  - I/O 调度器

### 7.2 问题诊断

- 故障排查
  - 系统日志
  - 性能监控
  - 网络诊断
- 调优工具
  - vmstat
  - iostat
  - sar
  - perf
- 最佳实践
  - 性能基准
  - 监控告警
  - 应急响应
