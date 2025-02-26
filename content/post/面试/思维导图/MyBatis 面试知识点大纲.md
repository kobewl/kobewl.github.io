---
mindmap-plugin: basic
---

# MyBatis 面试知识点大纲

## 1. MyBatis 基础概念

### 1.1 MyBatis 简介

- 什么是 MyBatis
  - 持久层框架
  - ORM（Object-Relational Mapping）框架
  - 对 JDBC 的封装
  - 半自动 ORM 框架（相比 Hibernate）
- 为什么选择 MyBatis
  - 优点
    - 灵活的 SQL 编写
    - 动态 SQL 能力强
    - 学习成本低
    - 性能优秀
  - 与其他框架对比
    - vs Hibernate
    - vs JPA
    - vs JDBC

### 1.2 核心配置

- 全局配置文件（mybatis-config.xml）
  - properties 属性
  - settings 设置
  - typeAliases 类型别名
  - typeHandlers 类型处理器
  - objectFactory 对象工厂
  - plugins 插件
  - environments 环境
    - environment 环境变量
    - transactionManager 事务管理器
    - dataSource 数据源
  - databaseIdProvider 数据库厂商标识
  - mappers 映射器
- 映射配置文件（Mapper.xml）
  - cache – 命名空间的二级缓存配置
  - cache-ref – 其他命名空间缓存配置的引用
  - resultMap – 结果映射
  - sql – 可被其他语句引用的可重用语句块
  - insert – 映射插入语句
  - update – 映射更新语句
  - delete – 映射删除语句
  - select – 映射查询语句

## 2. MyBatis 核心功能

### 2.1 参数处理

- 参数传递方式
  - 单个参数
  - 多个参数
  - POJO 参数
  - Map 参数
- 参数引用
  - #{} 和 ${} 的区别
    - #{} 预编译机制
      - 防 SQL 注入原理
      - 参数类型处理
    - ${} 字符串拼接
      - 使用场景
      - 安全风险
  - 参数名称引用
    - @Param 注解
    - 参数位置引用

### 2.2 结果映射

- ResultMap 详解
  - 基本结果映射
  - 高级结果映射
    - 关联查询
    - 集合查询
    - 鉴别器映射
  - 自动映射
    - autoMappingBehavior 设置
    - 驼峰命名自动映射
- 类型处理器（TypeHandler）
  - 内置类型处理器
  - 自定义类型处理器
  - 枚举类型处理

### 2.3 动态 SQL

- 动态 SQL 标签
  - if 条件判断
  - choose/when/otherwise 选择
  - trim/where/set 条件包装
  - foreach 循环
  - bind 变量绑定
- 动态 SQL 最佳实践
  - 代码复用
  - 性能优化
  - 可维护性

## 3. MyBatis 缓存机制

### 3.1 一级缓存

- 特点
  - SqlSession 级别
  - 默认开启
  - 生命周期
- 使用场景
- 失效情况
  - 不同 SqlSession
  - 增删改操作
  - 手动清除
  - 不同命名空间

### 3.2 二级缓存

- 特点
  - Mapper 级别
  - 需要手动开启
  - 跨 SqlSession
- 配置方式
  - XML 配置
  - 注解配置
- 使用条件
  - POJO 序列化
  - 缓存策略
- 常见问题
  - 脏读问题
  - 缓存更新机制

## 4. MyBatis 插件机制

### 4.1 插件原理

- 拦截器接口
  - Interceptor 接口
  - Invocation 对象
  - Plugin 工具类
- 可拦截对象
  - Executor
  - ParameterHandler
  - ResultSetHandler
  - StatementHandler
- 责任链模式实现
  - 拦截器链
  - 代理对象创建
  - 拦截器执行顺序

### 4.2 常用插件

- 分页插件
  - PageHelper 原理
  - 物理分页 vs 逻辑分页
  - 分页参数处理
- 乐观锁插件
- 性能分析插件
- 自定义插件开发
  - 插件注解配置
  - 拦截点选择
  - 代码实现步骤

## 5. MyBatis 工作原理

### 5.1 核心组件

- Configuration 配置信息
- SqlSessionFactory 会话工厂
- SqlSession 会话
- Executor 执行器
  - BaseExecutor
  - CachingExecutor
- StatementHandler 语句处理器
- ParameterHandler 参数处理器
- ResultSetHandler 结果集处理器

### 5.2 工作流程

- 初始化阶段
  - 配置文件解析
  - 创建 Configuration 对象
  - 构建 SqlSessionFactory
- 执行阶段
  - 获取 SqlSession
  - 获取 Mapper 代理
  - SQL 解析执行
  - 结果映射返回

## 6. MyBatis 性能优化

### 6.1 SQL 优化

- 批量操作
  - 批量新增
  - 批量更新
  - 批量删除
- 延迟加载
  - 原理
  - 配置方式
  - 使用场景

### 6.2 配置优化

- 缓存使用
  - 合理使用二级缓存
  - 自定义缓存
- 连接池配置
  - 连接池大小
  - 超时设置
- 执行器选择
  - SIMPLE
  - REUSE
  - BATCH

## 7. MyBatis 与 Spring 集成

- Spring 集成配置
  - SqlSessionFactoryBean
  - MapperScannerConfigurer
- 事务管理
  - Spring 事务接入
  - 事务传播行为
- 实践经验
  - 最佳实践
  - 常见问题
  - 性能优化

## 8. MyBatis 常见问题

- N+1 查询问题
  - 问题描述
  - 解决方案
- 关联查询性能
  - 延迟加载
  - 关联查询优化
- 大数据量处理
  - 分页处理
  - 批量处理
  - 游标查询
