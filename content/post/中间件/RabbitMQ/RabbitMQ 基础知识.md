---
title: "1 RabbitMQ 基础知识"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 RabbitMQ 基础知识

## 1.1 核心概念

### 1.1.1 基础组件

1. **Producer（生产者）**

   - 消息的发送者
   - 负责创建消息并发送到 RabbitMQ 服务器
   - 可以设置消息的属性（持久化、过期时间等）

2. **Consumer（消费者）**

   - 消息的接收者
   - 连接到 RabbitMQ 服务器并订阅队列
   - 负责处理接收到的消息
   - 可以配置消息确认模式（自动确认/手动确认）

3. **Queue（队列）**

   - 消息的存储载体
   - FIFO（先进先出）的数据结构
   - 可以设置多种属性：

     ```java
     // 队列属性示例
     Map<String, Object> arguments = new HashMap<>();
     arguments.put("x-message-ttl", 60000);        // 消息过期时间
     arguments.put("x-max-length", 1000);          // 队列最大长度
     arguments.put("x-queue-mode", "lazy");        // 队列模式（懒加载）

     channel.queueDeclare(queueName,     // 队列名称
                         true,           // 持久化
                         false,          // 排他性
                         false,          // 自动删除
                         arguments);     // 其他参数
     ```

4. **Exchange（交换机）**
   - 消息的路由中心
   - 根据规则将消息路由到一个或多个队列
   - 主要属性：
     - Name：交换机名称
     - Type：交换机类型
     - Durability：是否持久化
     - Auto-delete：是否自动删除
     - Arguments：其他参数

### 1.1.2 连接机制

1. **Connection（连接）**

   - TCP 连接，用于连接客户端和 RabbitMQ 服务器
   - 建议长连接使用

   ```java
   // 连接配置示例
   ConnectionFactory factory = new ConnectionFactory();
   factory.setHost("localhost");
   factory.setPort(5672);
   factory.setUsername("guest");
   factory.setPassword("guest");
   factory.setVirtualHost("/");

   // 连接属性设置
   factory.setConnectionTimeout(30000);  // 连接超时时间
   factory.setRequestedHeartbeat(60);    // 心跳检测
   factory.setAutomaticRecoveryEnabled(true);  // 自动重连
   ```

2. **Channel（信道）**

   - 建立在 Connection 上的虚拟连接
   - 复用 TCP 连接，减少性能开销
   - 每个线程使用独立的 Channel

   ```java
   // Channel 使用示例
   Connection connection = factory.newConnection();
   Channel channel = connection.createChannel();

   // 设置 Channel 属性
   channel.basicQos(1);  // 预取数量
   channel.confirmSelect();  // 开启发布确认
   ```

3. **Virtual Host（虚拟主机）**
   - 逻辑隔离的服务单元
   - 包含独立的 Exchange、Queue 和 Binding
   - 权限控制的最小粒度
   ```java
   // 虚拟主机配置
   factory.setVirtualHost("my_vhost");
   ```

### 1.1.3 路由机制

1. **Exchange Types（交换机类型）**

   a) **Direct Exchange（直接交换机）**

   ```java
   // 声明直接交换机
   channel.exchangeDeclare("direct_exchange", BuiltinExchangeType.DIRECT);

   // 发送消息
   String routingKey = "direct_key";
   channel.basicPublish("direct_exchange", routingKey, null, message.getBytes());
   ```

   b) **Fanout Exchange（扇出交换机）**

   ```java
   // 声明扇出交换机
   channel.exchangeDeclare("fanout_exchange", BuiltinExchangeType.FANOUT);

   // 发送消息（忽略 routingKey）
   channel.basicPublish("fanout_exchange", "", null, message.getBytes());
   ```

   c) **Topic Exchange（主题交换机）**

   ```java
   // 声明主题交换机
   channel.exchangeDeclare("topic_exchange", BuiltinExchangeType.TOPIC);

   // 发送消息（使用通配符路由键）
   channel.basicPublish("topic_exchange", "user.create", null, message.getBytes());
   ```

   d) **Headers Exchange（头交换机）**

   ```java
   // 声明头交换机
   channel.exchangeDeclare("headers_exchange", BuiltinExchangeType.HEADERS);

   // 发送消息（使用消息属性匹配）
   Map<String, Object> headers = new HashMap<>();
   headers.put("format", "pdf");
   headers.put("type", "report");
   AMQP.BasicProperties props = new AMQP.BasicProperties.Builder()
       .headers(headers)
       .build();
   channel.basicPublish("headers_exchange", "", props, message.getBytes());
   ```

2. **Binding（绑定）**

   - 定义 Exchange 和 Queue 之间的路由规则

   ```java
   // 绑定示例
   channel.queueBind(queueName,     // 队列名称
                    exchangeName,   // 交换机名称
                    routingKey);    // 路由键

   // 带参数的绑定
   Map<String, Object> arguments = new HashMap<>();
   arguments.put("x-match", "all");  // 匹配模式
   channel.queueBind(queueName, exchangeName, "", arguments);
   ```

### 1.1.4 消息确认机制

1. **Producer Confirms（生产者确认）**

   ```java
   // 单条确认
   channel.confirmSelect();
   channel.basicPublish(exchange, routingKey, null, message.getBytes());
   if (channel.waitForConfirms()) {
       System.out.println("消息发送成功");
   }

   // 异步确认
   channel.addConfirmListener(
       (sequenceNumber, multiple) -> {
           // 确认成功回调
       },
       (sequenceNumber, multiple) -> {
           // 确认失败回调
       }
   );
   ```

2. **Consumer Acknowledgements（消费者确认）**

   ```java
   // 自动确认模式
   channel.basicConsume(queueName, true, deliverCallback, cancelCallback);

   // 手动确认模式
   channel.basicConsume(queueName, false, (consumerTag, delivery) -> {
       try {
           // 处理消息
           channel.basicAck(delivery.getEnvelope().getDeliveryTag(), false);
       } catch (Exception e) {
           // 处理失败，拒绝消息
           channel.basicNack(delivery.getEnvelope().getDeliveryTag(), false, true);
       }
   }, consumerTag -> {});
   ```

## 1.2 最佳实践

### 1.2.1 连接管理

- 使用连接池管理连接
- 一个进程维护一个 Connection
- 每个线程使用独立的 Channel
- 避免频繁创建和销毁连接

### 1.2.2 消息可靠性

- 开启生产者确认机制
- 使用手动消息确认
- 重要消息需要持久化
- 配置死信队列处理失败消息

### 1.2.3 性能优化

- 合理设置预取数量
- 批量确认消息
- 使用合适的交换机类型
- 控制队列长度和消息大小

### 1.2.4 监控告警

- 配置队列告警阈值
- 监控连接数和 Channel 数
- 监控消息积压情况
- 设置资源使用告警

## 1.3 高级特性

### 1.3.1 死信队列（Dead Letter Queue）

死信队列用于处理无法被正常消费的消息。当一个消息变成死信后，会被重新发送到另一个交换机，这个交换机就是 DLX（Dead Letter Exchange）。

#### 1.3.1.1 死信产生的条件

1. **消息被拒绝（Basic.Reject/Basic.Nack）且不重新入队（requeue=false）**
2. **消息过期（TTL 到期）**
3. **队列达到最大长度**

#### 1.3.1.2 死信队列配置

```java
// 1. 声明死信交换机
channel.exchangeDeclare("dlx.exchange", "direct");

// 2. 声明死信队列
channel.queueDeclare("dlx.queue", true, false, false, null);

// 3. 绑定死信队列到死信交换机
channel.queueBind("dlx.queue", "dlx.exchange", "dlx.routing.key");

// 4. 为普通队列指定死信交换机
Map<String, Object> args = new HashMap<>();
args.put("x-dead-letter-exchange", "dlx.exchange");
args.put("x-dead-letter-routing-key", "dlx.routing.key");
// 可选：设置消息过期时间
args.put("x-message-ttl", 30000); // 30秒
// 可选：设置队列最大长度
args.put("x-max-length", 1000);

channel.queueDeclare("normal.queue", true, false, false, args);
```

#### 1.3.1.3 死信消息处理

```java
// 消费死信队列
channel.basicConsume("dlx.queue", false, (consumerTag, delivery) -> {
    try {
        // 获取死信消息的原始信息
        Map<String, Object> headers = delivery.getProperties().getHeaders();
        String originalExchange = (String) headers.get("x-first-death-exchange");
        String originalQueue = (String) headers.get("x-first-death-queue");
        String deathReason = (String) headers.get("x-first-death-reason");

        // 处理死信消息
        String message = new String(delivery.getBody(), "UTF-8");
        System.out.println("处理死信消息: " + message);
        System.out.println("原交换机: " + originalExchange);
        System.out.println("原队列: " + originalQueue);
        System.out.println("死亡原因: " + deathReason);

        // 确认消息
        channel.basicAck(delivery.getEnvelope().getDeliveryTag(), false);
    } catch (Exception e) {
        // 处理失败，拒绝消息
        channel.basicNack(delivery.getEnvelope().getDeliveryTag(), false, false);
    }
}, consumerTag -> {});
```

### 1.3.2 延迟队列（Delayed Queue）

延迟队列用于实现消息的延迟投递，常用于定时任务、延迟处理等场景。

#### 1.3.2.1 TTL + 死信队列实现

```java
// 1. 配置死信交换机和队列（同上死信队列配置）

// 2. 创建延迟队列（设置TTL）
Map<String, Object> args = new HashMap<>();
args.put("x-dead-letter-exchange", "dlx.exchange");
args.put("x-dead-letter-routing-key", "dlx.routing.key");
args.put("x-message-ttl", 5000); // 5秒延迟
channel.queueDeclare("delay.queue", true, false, false, args);

// 3. 发送消息到延迟队列
channel.basicPublish("", "delay.queue",
    MessageProperties.PERSISTENT_TEXT_PLAIN,
    message.getBytes());
```

#### 1.3.2.2 延迟消息插件实现（rabbitmq_delayed_message_exchange）

```java
// 1. 声明延迟交换机
Map<String, Object> args = new HashMap<>();
args.put("x-delayed-type", "direct");
channel.exchangeDeclare("delay.exchange", "x-delayed-message", true, false, args);

// 2. 声明队列并绑定
channel.queueDeclare("delay.queue", true, false, false, null);
channel.queueBind("delay.queue", "delay.exchange", "delay.routing.key");

// 3. 发送延迟消息
Map<String, Object> headers = new HashMap<>();
headers.put("x-delay", 5000); // 5秒延迟
AMQP.BasicProperties properties = new AMQP.BasicProperties.Builder()
    .headers(headers)
    .build();

channel.basicPublish("delay.exchange", "delay.routing.key",
    properties, message.getBytes());
```

### 1.3.3 优先级队列（Priority Queue）

优先级队列允许消息按优先级顺序被消费，优先级高的消息会优先被消费。

```java
// 1. 声明优先级队列
Map<String, Object> args = new HashMap<>();
args.put("x-max-priority", 10); // 设置最大优先级为10
channel.queueDeclare("priority.queue", true, false, false, args);

// 2. 发送带优先级的消息
AMQP.BasicProperties properties = new AMQP.BasicProperties.Builder()
    .priority(5) // 设置消息优先级
    .build();
channel.basicPublish("", "priority.queue", properties, message.getBytes());
```

### 1.3.4 消息追踪（Message Tracing）

#### 1.3.4.1 Firehose 功能

```java
// 1. 启用 Firehose 跟踪
channel.exchangeDeclare("amq.rabbitmq.trace", "topic", true, false, null);

// 2. 创建跟踪队列
channel.queueDeclare("trace.queue", true, false, false, null);
channel.queueBind("trace.queue", "amq.rabbitmq.trace", "#");

// 3. 消费跟踪消息
channel.basicConsume("trace.queue", false, (consumerTag, delivery) -> {
    String routingKey = delivery.getEnvelope().getRoutingKey();
    String message = new String(delivery.getBody(), "UTF-8");
    // 处理跟踪消息
    channel.basicAck(delivery.getEnvelope().getDeliveryTag(), false);
}, consumerTag -> {});
```

#### 1.3.4.2 消息轨迹记录

```java
// 发送消息时添加轨迹信息
Map<String, Object> headers = new HashMap<>();
headers.put("trace_id", UUID.randomUUID().toString());
headers.put("timestamp", System.currentTimeMillis());
headers.put("source", "order_service");

AMQP.BasicProperties properties = new AMQP.BasicProperties.Builder()
    .headers(headers)
    .build();

channel.basicPublish(exchange, routingKey, properties, message.getBytes());
```

### 1.3.5 消息过期时间（TTL）

#### 1.3.5.1 队列级别 TTL

```java
// 为队列设置消息过期时间
Map<String, Object> args = new HashMap<>();
args.put("x-message-ttl", 30000); // 30秒
channel.queueDeclare("ttl.queue", true, false, false, args);
```

#### 1.3.5.2 消息级别 TTL

```java
// 为单个消息设置过期时间
AMQP.BasicProperties properties = new AMQP.BasicProperties.Builder()
    .expiration("30000") // 30秒
    .build();
channel.basicPublish(exchange, routingKey, properties, message.getBytes());
```

## 1.4 使用建议

### 1.4.1 消息可靠性保证

- 使用生产者确认机制
- 使用消费者手动确认
- 关键消息使用持久化
- 配置死信队列处理异常情况
- 实现消息补偿机制

### 1.4.2 性能优化建议

- 合理使用 Connection 和 Channel
- 适当的预取值（prefetch）设置
- 批量确认消息
- 消息压缩（大消息）
- 使用惰性队列（大量消息堆积）

### 1.4.3 监控和运维

- 监控队列长度和消息堆积
- 监控消费者状态
- 设置内存和磁盘告警阈值
- 定期清理无用的队列和交换机
- 备份关键的队列配置

