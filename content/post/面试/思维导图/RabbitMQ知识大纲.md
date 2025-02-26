---
mindmap-plugin: basic
---

# 1 RabbitMQ 知识大纲

## 1.1 消息队列[[消息队列]]
- 什么是消息队列
	- 定义与作用
	- 消息队列的应用场景
	- 消息队列的优缺点
- 为什么需要消息队列
	- 解耦
	- 异步
	- 削峰
- AMQP 协议[[消息队列#^5196aa]]
	- 什么是 AMQP
	- AMQP 的主要组件
	- AMQP 工作流程

## 1.2 RabbitMQ 简介
- RabbitMQ 定义
	- 开源的消息代理和队列服务器
	- 使用 Erlang 语言开发
	- AMQP 协议的标准实现
- 主要特点
	- 可靠性
	- 灵活的路由
	- 支持多种协议
	- 高可用性
	- 管理界面
	- 插件机制
- 消息队列对比
	- RabbitMQ vs Kafka
		- RabbitMQ：
			- 优点：延迟低，支持复杂路由，管理界面友好
			- 缺点：吞吐量相对较低，消息堆积能力一般
		- Kafka：
			- 优点：超高吞吐量，消息持久化，高堆积能力
			- 缺点：延迟较高，不支持复杂路由
	- RabbitMQ vs RocketMQ
		- RocketMQ：
			- 优点：金融级可靠性，海量堆积能力
			- 缺点：社区相对不够活跃，运维成本高
	- RabbitMQ vs ActiveMQ
		- ActiveMQ：
			- 优点：JMS 支持完善，成熟稳定
			- 缺点：性能相对较差，社区活跃度低

## 1.3 RabbitMQ 核心概念
- Exchange（交换机）
	- Direct Exchange
	- Fanout Exchange
	- Topic Exchange
	- Headers Exchange
- Queue（队列）
	- 队列属性
	- 队列持久化
	- 队列绑定
- Binding（绑定）
- Virtual Host（虚拟主机）
- Channel（信道）
- Connection（连接）

## 1.4 RabbitMQ 工作模式
- Simple 模式（简单模式）
- Work 模式（工作模式）
- Publish/Subscribe 模式（发布订阅模式）
- Routing 模式（路由模式）
- Topics 模式（主题模式）
- RPC 模式（远程调用模式）

## 1.5 消息可靠性保证
- 生产者确认机制
	- Publisher Confirm
		- 单条确认
		- 批量确认
		- 异步确认
	- Publisher Return
		- 处理无法路由的消息
		- Return Listener 实现
- 消费者确认机制
	- Consumer Ack
		- 自动确认（autoAck=true）
		- 手动确认（autoAck=false）
		- 批量确认
	- Consumer Reject
		- Basic.Reject（单条拒绝）
		- Basic.Nack（批量拒绝）
		- 重回队列机制
- 持久化机制
	- Exchange 持久化
		- durable 属性设置
	- Queue 持久化
		- durable 属性设置
		- 队列持久化注意事项
	- Message 持久化
		- deliveryMode 设置
		- 持久化性能影响
- 死信队列
	- 死信产生原因
		- 消息被拒绝（reject/nack）
		- 消息过期（TTL）
		- 队列达到最大长度
	- 死信处理机制
		- DLX（Dead Letter Exchange）配置
		- 死信队列监控和处理
- 延迟队列实现
	- TTL + DLX 实现
	- 插件实现（rabbitmq-delayed-message-exchange）
	- 实现注意事项

## 1.6 高可用机制
- 集群模式
	- 普通集群
	- 镜像集群
	- Quorum 队列
- HAProxy 负载均衡
- Federation 跨机房数据复制
- Shovel 数据转发

## 1.7 性能优化
- 生产者优化
	- 批量发送
		- 合适的批次大小
		- 批量发送超时设置
	- 异步发送
		- ConfirmCallback 处理
		- ReturnCallback 处理
	- 合理配置 Channel
		- Channel 复用
		- 并发数量控制
		- 连接池使用
- 消费者优化
	- 合理的 prefetch 数量
		- 消费者处理能力评估
		- prefetch 动态调整
	- 批量确认
		- 批量大小设置
		- 确认超时处理
	- 并发消费
		- 多线程消费
		- 消费者数量控制
		- 消费者负载均衡
- 队列优化
	- 队列数量控制
		- 单个 Virtual Host 队列数限制
		- 队列命名规范
	- 消息大小控制
		- 消息体积优化
		- 大消息处理策略
	- TTL 设置
		- 消息 TTL
		- 队列 TTL
		- 过期消息清理策略

## 1.8 最佳实践
- 架构设计
	- 集群规划
	- 容量评估
	- 灾备方案
- 开发规范
	- 命名规范
	- 代码规范
	- 异常处理
- 运维管理
	- 监控告警
	- 日志管理
	- 备份恢复
- 安全管理
	- 访问控制
	- 认证授权
	- 网络安全

## 1.9 常见问题与解决方案
- 消息堆积问题
- 消息丢失问题
- 重复消费问题
- 顺序消费问题
- 事务与性能平衡

## 1.10 监控与运维
- 管理界面使用
- 监控指标
	- 队列监控
	- 连接监控
	- 性能监控
- 常用运维命令
- 日志管理