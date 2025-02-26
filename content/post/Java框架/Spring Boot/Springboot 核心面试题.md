---
title: "1 Springboot 的启动流程？"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Springboot 的启动流程？

1. 启动 main() 方法：应用从 main() 方法启动，并通过 SpringApplication.run() 引导应用启动。 ^c6b7d4
2. 创建SpringApplication：应用会创建SpringApplication 对象，推断应用类型、设置初始化器、设置启动监听器、确定主应用类。
3. 准备环境：Spring Boot 在启动过程中准备应用环境，加载配置文件、系统环境变量以及命令行参数。
4. 创建并刷新 ApplicationContext：创建应用上下文，加载配置类和自动配置类，注册 Bean 并执行依赖注入等初始化操作[[6 Bean#4 Bean 的生命周期？]]。 ^2ccda7
5. 在刷新上下文时启动嵌入式 Web 服务器：对于 Web 应用，Spring Boot 会自动启动嵌入式 Web 容器（默认 Tomcat），并注册相关的 Servlet 和 Filter。
6. 发布应用已启动事件：对应监听 stated 事件逻辑会被触发。
7. 执行 CommandLineRunner 和 ApplicationRunner：在应用启动完成后，执行实现了 CommandLineRunner 和 ApplicationRunner 接口的初始化逻辑。
8. 发布 ready 事件、应用启动完成：触发 ApplicationReadyEvent，应用进入运行状态，处理业务请求或任务。

```shell
main() → SpringApplication.run()
    ├─ 创建 SpringApplication 对象（推断类型、加载初始化器和监听器）
    ├─ 准备 Environment（加载配置、触发 ApplicationEnvironmentPreparedEvent）
    ├─ 创建 ApplicationContext
    ├─ 刷新 ApplicationContext
    │    ├─ 加载配置类和自动配置类
    │    ├─ 实例化 Bean、依赖注入
    │    ├─ 启动嵌入式 Web 服务器（触发 ServletWebServerInitializedEvent）
    │    └─ 触发 ContextRefreshedEvent
    ├─ 触发 ApplicationStartedEvent
    ├─ 执行 CommandLineRunner/ApplicationRunner
    └─ 触发 ApplicationReadyEvent（应用就绪）
```

# 2 SpringBoot 的核心特性有哪些？

* 开箱即用，内嵌服务器。spring boot 可以省略以前繁琐的 tomcat 配置，快速创建一个 web 容器。
* 自动化配置。在 spring boot 中我们可以按照自动配置的规定（将自动加载的 bean 写在自己jar 包当中的 meta/info/spring.factories 文件中或者通过的注解 @Import 导入时加载指定的类）这样我们的配置类就会被 Springboot 自动加载到容器当中。 同时还支持通过改写yaml 和 propreties来覆盖默认配置
* 支持 jar 包运行。传统部署web 容器都是打成 war 包放在 tomcat 中。spring boot 可以打成 jar 包只要有 java 运行环境即可运行 web 容器。
* 完整的生态支持。spring boot 可以随意整合 spring 全家桶的支持。像 Actuator 健康检查模块，Spring Data JPA 数据库模块，Spring Test 测试模块。这些都可以很优雅的集成在 springboot 当中。
* 监控、健康检查支持。spring boot Actuator 支持开发者监控应用的运行状态，包括性能指标、应用信息和日志级别控制等。

# 3 SpringBoot 是如何实现自动配置的？

Spring Boot 的自动配置是通过 @EnableAutoConfiguration 注解实现，这个注解包含@Import({AutoConfigurationImportSelector.class})注解，导入的这个类会去扫描 classpath 下所有的 META-INF/spring.factories 中的文件，根据文件中指定的配置类加载相应的 Bean 的自动配置。

Spring Boot 的自动配置是通过以下步骤实现的：

1. **触发入口**：`@EnableAutoConfiguration` 注解激活自动配置逻辑。
    
2. **加载候选类**：从 `META-INF/spring.factories` 中读取所有候选配置类。
    
3. **条件筛选**：通过条件注解动态过滤不满足条件的配置类。
    
4. **注册 Bean**：将最终有效的配置类注册到容器中，完成 Bean 的初始化。
    
5. **用户覆盖**：允许通过自定义 Bean 或配置文件覆盖默认配置。

# 4 SpringBoot 默认同时可以处理多少个请求？
SpringBoot 默认是 Tomcat 这个 web 容器，实际上是这取决于 tomcat 的线程池配置。
tomcat 的默认核心线程数是 10，最大线程数 200，队列长度无限。但是它的线程池机制和 JDK 默认线程池不一样，因为主要是 I/O 密集型的任务，所以 tomcat 改造了线程池策略，在核心线程数满了之后，会直接创建线程到最大线程数。
所以，在默认的配置下，同一时刻，可以处理 200 个请求。 其他的请求只能排队了。
可以通过 server.tomcat.max-threads 修改最大最大工作线程数。

# 5 Spring Boot 中如何实现异步处理？

主要有四种方式来实现异步处理：

1. 使用 **@Async** 注解
2. 使用 **CompletableFuture**（Java 8 引入的一个强大的异步编程工具）
3. 使用 **@Scheduled** 注解
4. 使用**线程池**

