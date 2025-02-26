---
title: "1 Redis 基础知识"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Redis 基础知识

## 1.1 Redis 基本概念

### 1.1.1 什么是 Redis
- Redis（Remote Dictionary Server）是一个开源的、基于内存的高性能 NoSQL 数据库
- 支持多种数据结构：字符串、哈希、列表、集合、有序集合等
- 支持数据持久化、主从复制、事务等特性

### 1.1.2 Redis 特性
- **基于内存操作**：所有数据都存在内存中，读写性能高
- **单线程模型**：核心操作采用单线程，避免了多线程的竞争问题
- **I/O 多路复用**：通过 epoll 实现高并发处理
- **原子性操作**：单个操作是原子性的，也支持事务

### 1.1.3 Redis 应用场景
- **缓存系统**：缓存热点数据，减轻数据库压力
- **计数器系统**：如文章阅读量、点赞数统计
- **排行榜系统**：利用有序集合实现排名功能
- **消息队列**：利用 List 或 Stream 实现简单的消息队列
- **分布式锁**：利用 SETNX 等命令实现分布式锁

## 1.2 Redis 数据类型

### 1.2.1 String（字符串）
- **底层实现**：SDS（Simple Dynamic String）
- **使用场景**：
  - 缓存对象：SET user:1 {json字符串}
  - 计数器：INCR article:readcount:{id}
  - 分布式锁：SETNX lock:key value
- **常用命令**：
  ```redis
  SET key value
  GET key
  INCR key
  DECR key
  EXPIRE key seconds
  ```

### 1.2.2 Hash（哈希）
- **底层实现**：ziplist 或 hashtable
- **使用场景**：
  - 存储对象：HSET user:1 name Tom age 20
  - 购物车：商品ID为field，数量为value
- **常用命令**：
  ```redis
  HSET key field value
  HGET key field
  HMSET key field1 value1 field2 value2
  HGETALL key
  ```

### 1.2.3 List（列表）
- **底层实现**：quicklist（双向链表）
- **使用场景**：
  - 消息队列：LPUSH + BRPOP
  - 文章列表：最新文章列表
- **常用命令**：
  ```redis
  LPUSH key value
  RPUSH key value
  LPOP key
  LRANGE key start stop
  ```

### 1.2.4 Set（集合）
- **底层实现**：intset 或 hashtable
- **使用场景**：
  - 标签系统
  - 好友关系：共同好友
- **常用命令**：
  ```redis
  SADD key member
  SMEMBERS key
  SINTER key1 key2
  SUNION key1 key2
  ```

### 1.2.5 Sorted Set（有序集合）
- **底层实现**：skiplist + hashtable
- **使用场景**：
  - 排行榜系统
  - 权重排序
- **常用命令**：
  ```redis
  ZADD key score member
  ZRANGE key start stop
  ZREVRANGE key start stop
  ZRANK key member
  ```

## 1.3 Redis 持久化机制

### 1.3.1 RDB（快照持久化）
- **原理**：将某一时刻的所有数据写入磁盘
- **优点**：
  - 文件紧凑，适合备份
  - 恢复速度快
- **缺点**：
  - 可能丢失最后一次快照后的数据
  - fork子进程时可能阻塞服务

### 1.3.2 AOF（日志持久化）
- **原理**：记录每一条写命令
- **优点**：
  - 数据安全性高
  - 可读性强，便于分析
- **缺点**：
  - 文件体积大
  - 恢复速度慢
- **同步策略**：
  - always：每次写入（最安全）
  - everysec：每秒同步（推荐）
  - no：由操作系统决定

### 1.3.3 混合持久化
- **原理**：RDB + AOF 结合
- **优点**：
  - 继承了 RDB 的快速恢复
  - 又兼顾了 AOF 的数据安全

## 1.4 Redis 高可用方案

### 1.4.1 主从复制
- **原理**：
  - 全量同步
  - 增量同步
- **优点**：
  - 读写分离
  - 故障恢复

### 1.4.2 哨兵模式（Sentinel）
- **功能**：
  - 监控主从节点
  - 自动故障转移
  - 配置中心
- **优点**：
  - 高可用
  - 自动故障恢复

### 1.4.3 集群模式（Cluster）
- **特点**：
  - 数据自动分片
  - 去中心化
  - 自动故障转移
- **优点**：
  - 支持水平扩展
  - 高可用性

## 1.5 Redis 性能优化

### 1.5.1 内存优化
- **内存配置**：
  - maxmemory 设置
  - 内存淘汰策略选择
- **数据结构优化**：
  - 合理使用数据类型
  - 避免大key

### 1.5.2 命令使用优化
- **Pipeline**：批量执行命令
- **事务**：原子性操作
- **Lua脚本**：减少网络开销

### 1.5.3 网络优化
- **连接池**：复用连接
- **压缩**：启用压缩算法
- **TCP参数调优**

## 1.6 实践经验

### 1.6.1 开发规范
- **Key命名规范**：
  - 业务名:表名:id
  - 控制key的长度
- **Value大小控制**：
  - 避免存储大对象
  - 合理设计数据结构

### 1.6.2 运维经验
- **监控指标**：
  - 内存使用率
  - QPS
  - 慢查询
- **容量规划**：
  - 内存容量评估
  - 实例个数规划
- **备份策略**：
  - RDB定时备份
  - AOF持久化配置"}}
