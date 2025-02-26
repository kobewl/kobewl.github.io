---

mindmap-plugin: basic

---

# 1 Elasticsearch 知识大纲

## 1.1 Elasticsearch 基础概念

- ES 的定义与特点
  - 分布式搜索引擎
  - 近实时搜索
  - RESTful API
  - Schema-free
- 核心概念
  - Index（索引）
  - Type（类型，7.0 后废弃）
  - Document（文档）
  - Mapping（映射）
  - Field（字段）
  - Shards（分片）
  - Replicas（副本）

## 1.2 Elasticsearch 架构原理

- 集群架构
  - Master Node
  - Data Node
  - Client Node
  - Coordinating Node
- 分布式架构
  - 分片机制
  - 副本机制
  - 集群发现机制
- 写入原理
  - 写入流程
  - 数据路由
  - 并发控制
- 搜索原理
  - Query-Then-Fetch
  - 相关性评分
  - 分布式搜索过程

## 1.3 索引管理

- 索引操作
  - 创建索引
  - 删除索引
  - 索引设置
  - 索引模板
- Mapping 管理
  - 字段类型
  - 动态映射
  - 显式映射
  - 字段属性设置
- 分词器
  - 内置分词器
  - 自定义分词器
  - IK 分词器
  - 分词器使用场景

## 1.4 检索与查询

- Query DSL
  - Match Query
  - Term Query
  - Range Query
  - Bool Query
  - Fuzzy Query
- Filter Context
  - 过滤查询
  - 缓存机制
- 聚合分析
  - Bucket 聚合
  - Metric 聚合
  - Pipeline 聚合
- 排序
  - 相关性排序
  - 字段值排序
  - 地理位置排序

## 1.5 性能优化

- 索引优化
  - 合理的分片数
  - 索引刷新间隔
  - 索引缓冲设置
- 查询优化
  - 查询重写
  - 缓存利用
  - 预热查询
- 系统优化
  - JVM 设置
  - 内存管理
  - 磁盘 IO 优化

## 1.6 运维与监控

- 集群管理
  - 节点管理
  - 索引管理
  - 分片管理
- 监控指标
  - 集群健康状态
  - 节点状态
  - 索引状态
  - 性能指标
- 数据备份与恢复
  - Snapshot
  - Restore
  - 跨集群复制

## 1.7 高可用设计

- 集群容错
  - 脑裂问题
  - 选主机制
  - 故障转移
- 数据可靠性
  - 副本机制
  - 一致性保证
  - 数据恢复机制
- 安全机制
  - 认证与授权
  - SSL/TLS 加密
  - 角色权限控制

## 1.8 集成应用

- 与 Spring Boot 集成
  - Spring Data Elasticsearch
  - RestHighLevelClient
  - RestTemplate
- ELK Stack
  - Logstash
  - Kibana
  - Beats
- 常见应用场景
  - 全文检索
  - 日志分析
  - 指标监控
  - 业务搜索
