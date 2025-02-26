---
title: "1 IOC"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 IOC

^d2fdd3

## 1.1 什么是 IOC

**控制反转（IoC）是面向对象编程中的一种设计原则，用于减少类之间的耦合。它通过将对象的创建和依赖关系的管理交给容器来实现。

## 1.2 实现方式

**依赖注入（Dependency Injection，简称 DI）是控制反转（IoC）的一种实现方式。它通过将对象的创建和依赖关系的管理交给容器来实现。

### 1.2.1 依赖注入的实现方式

依赖注入的实现方式有三种：

- **构造器注入**
- **Setter 注入**
- **字段注入**

#### 1.2.1.1 构造器注入（推荐，可保证依赖不可变）

构造器注入是通过构造器将依赖传入。它通常用于要求依赖是不可变的场景，或者要求依赖关系在对象创建时就被确定的情况。

```java
public class Car {
    private final Engine engine;

    // 通过构造器注入
    public Car(Engine engine) {
        this.engine = engine;
    }

    public void start() {
        engine.run();
        System.out.println("Car started");
    }
}
```

构造器注入的特点:

1. **优点**

   - 保证依赖不可变（final 修饰）
   - 保证依赖不为空（避免 NPE）
   - 保证完全初始化状态（构造完成就可用）
   - 避免循环依赖
   - 提高代码可测试性

2. **缺点**

   - 当依赖过多时,构造器参数列表过长
   - 不能实现可选依赖
   - 不支持循环依赖

3. **使用场景**
   - 强制依赖的注入
   - 不变对象的创建
   - 需要保证线程安全的对象

#### 1.2.1.2 Setter 注入（灵活但不能保证依赖完整性）

Setter 注入是**通过 Setter 方法来注入依赖**。它适用于依赖关系是可选的，或者需要在对象创建后再进行注入的情况。Setter 注入不如构造器注入那么安全，因为依赖可以在对象创建之后再注入。

```java
public class Car {
    private Engine engine;

    // Setter方法注入
    public void setEngine(Engine engine) {
        this.engine = engine;
    }

    public void start() {
        engine.run();
        System.out.println("Car started");
    }
}
```

Setter 注入的特点:

1. **优点**

   - 灵活性高,可以随时注入依赖
   - 支持可选依赖
   - 支持循环依赖

2. **缺点**

   - 依赖对象需要有 Setter 方法
   - 依赖对象需要有默认构造器

3. **使用场景**
   - 可选依赖的注入
   - 需要灵活配置的依赖
   - 依赖对象有多个实现

#### 1.2.1.3 字段注入（简单，违反封装原则）

字段注入是通过直接在字段上使用 `@Autowired` 注解来注入依赖。这是一种最简洁的方式，但它也有一些缺点，主要是耦合性比较强，且不利于单元测试。

```java
public class Car {
    // 字段注入
    @Autowired
    private Engine engine;

    public void start() {
        engine.run();
        System.out.println("Car started");
    }
}
```

字段注入的特点:

1. **优点**

   - 简洁,不需要显式调用 Setter 方法
   - 支持可选依赖
   - 支持循环依赖

2. **缺点**

   - 代码耦合性比较强
   - 不利于单元测试

3. **使用场景**
   - 可选依赖的注入
   - 需要灵活配置的依赖
   - 依赖对象有多个实现

## 1.3 IOC 容器

IOC 容器是 Spring 框架的核心组件，用于管理对象的创建、依赖注入和生命周期等。它提供了多种配置方式，包括 XML 配置、注解配置和 Java 配置。它的主要作用是：

- 通过**依赖注入（DI）自动管理对象之间的依赖关系。
- 使应用程序从手动创建对象和管理依赖的过程解耦，提高代码的可维护性和可测试性。

### 1.3.1 Spring IOC 容器的两种主要类型

Spring 提供了两大类 IOC 容器：

- **BeanFactory**：基本容器，轻量级，提供最基本的 IOC 功能。
- **ApplicationContext**：高级容器，功能更强大，提供更多高级特性。

### 1.3.2 BeanFactory（基本容器）

**BeanFactory 是 Spring 最基本的 IOC 容器**，它是 org.springframework.beans.factory.BeanFactory 接口的实现。

特点：

- 延迟加载（Lazy Loading）：当需要某个 Bean 时，才会去实例化它，而不是在启动时就创建。
- 轻量级，适用于资源受限的环境（如嵌入式系统或小型应用）。
- 只提供最基本的 IOC 功能，不具备事件发布、国际化、AOP 等高级特性。

常见实现：

- DefaultListableBeanFactory
- XmlBeanFactory（已废弃，早期版本使用）

```java
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.ClassPathResource;

// 定义一个简单的类
class Car {
    public void drive() {
        System.out.println("Car is running...");
    }
}

public class BeanFactoryExample {
    public static void main(String[] args) {
        // 创建BeanFactory容器
        BeanFactory factory = new XmlBeanFactory(new ClassPathResource("beans.xml"));

        // 获取Bean
        Car car = (Car) factory.getBean("car");
        car.drive();
    }
}

```

什么时候使用？

- 资源受限的环境（如小型项目）。
- 需要懒加载的情况。

### 1.3.3 ApplicationContext（高级容器）

**ApplicationContext 是 Spring 的高级 IOC 容器**，它是 org.springframework.context.ApplicationContext 接口的实现。ApplicationContext 继承了 BeanFactory，是 Spring 提供的更高级的 IOC 容器，增强了 BeanFactory 的功能。

特点：

- 预加载：容器在启动时就会实例化所有的单例 Bean（除非指定懒加载 lazy-init="true"）。
- 支持事件监听：可以发布和订阅应用事件（ApplicationEvent）。
- 支持国际化：可以使用 MessageSource 进行多语言支持。
  - 支持 AOP：可以和 Spring AOP 无缝集成。
  - 支持 Web 应用：可以和 Spring MVC 结合使用。

常见实现：

- ClassPathXmlApplicationContext
- FileSystemXmlApplicationContext
- AnnotationConfigApplicationContext

常见实现

| ApplicationContext 实现            | 适用场景                                         |
| ---------------------------------- | ------------------------------------------------ |
| ClassPathXmlApplicationContext     | 适用于读取 classpath 下的 XML 配置文件           |
| FileSystemXmlApplicationContext    | 适用于读取 文件系统 目录下的 XML 配置文件        |
| AnnotationConfigApplicationContext | 适用于**基于 Java 配置（@Configuration）**的应用 |
| WebApplicationContext              | **适用于 Web 环境（Spring MVC）**                |

## 1.4 BeanFactory vs ApplicationContext

| **关键点**   | **BeanFactory** | **ApplicationContext**  |
| ------------ | --------------- | ----------------------- |
| 懒加载       | 默认懒加载      | 默认预加载所有单例 Bean |
| 事件机制     | 不支持          | 支持事件发布和监听      |
| 国际化       | 不支持          | 支持（MessageSource）   |
| AOP 支持     | 需要手动配置    | 内置支持 AOP            |
| Web 应用支持 | 不适合          | 适用于 Web 环境         |

适用场景：

- **BeanFactory**：适用于资源受限的环境（如小型项目）。
- **ApplicationContext**：适用于需要更多高级特性的场景（如国际化、AOP、Web 应用）。

## 1.5 Bean 的定义

Bean 是 Spring 容器中的一个核心概念，它指的是 **由 Spring IoC 容器创建和管理的 Java 对象**。Bean 可以是应用程序的组件，如服务、DAO、控制器等。Spring 通过 IoC（控制反转）机制来管理 Bean 的创建、依赖关系、生命周期等。

### 1.5.1 Bean 的定义方式

Bean 的定义方式有三种：

- 使用 XML 配置文件定义 Bean
- 使用注解定义 Bean
- Java 配置（@Configuration）

#### 1.5.1.1 使用 XML 配置文件定义 Bean

传统方式，通过 XML 文件来配置 Bean。

```xml
<bean id="userService" class="com.example.service.UserService"/>

```

获取 Bean（基于 XML 配置）：

```java
ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
UserService userService = (UserService) context.getBean("userService");
```

#### 1.5.1.2 使用注解定义 Bean（@Component, @Service, @Repository, @Controller）

Spring 4.x 以后，更推荐使用基于 注解 的方式定义 Bean。

```java
import org.springframework.stereotype.Service;

@Service // 让 Spring 扫描并管理这个 Bean
public class UserService {
    public void registerUser() {
        System.out.println("User registered!");
    }
}

```

获取 Bean（基于注解）：

```java
ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
UserService userService = context.getBean(UserService.class);

```

> 注意：使用注解定义 Bean 时，需要在配置类或 XML 中启用 组件扫描（@ComponentScan） 让 Spring 发现这些 Bean。

#### 1.5.1.3 使用 Java 配置（@Configuration）

Spring 3.x 以后支持基于 Java 配置的方式定义 Bean。
使用 Java 配置（@Configuration），通过 Java 代码来定义 Bean。

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {
    @Bean
    public UserService userService() {
        return new UserService();
    }
}

```

获取 Bean（基于 Java 配置）：

```java
ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
UserService userService = context.getBean(UserService.class);

```

### 1.5.2 Bean 的作用域（Scope）

Bean 的作用域决定了 Bean 在 Spring 容器中的生命周期和可见性。
Spring 容器提供了 5 种作用域，用于控制 Bean 的生命周期和访问方式。

常见的作用域：

| **作用域**            | **说明**                                         |
| --------------------- | ------------------------------------------------ |
| singleton（默认）     | 全局唯一单例，整个 Spring 容器中只存在一个实例。 |
| prototype             | 每次获取都会创建新实例，适用于无状态 Bean。      |
| request（仅 Web）     | 每个 HTTP 请求创建一个 Bean（Web 应用专用）。    |
| session（仅 Web）     | 每个用户会话创建一个 Bean（Web 应用专用）。      |
| application（仅 Web） | 整个 Web 应用范围内共享一个 Bean 实例。          |

示例：

```java
@Component
@Scope("prototype") // 每次获取 Bean 时都会创建一个新的实例
public class OrderService {
}

```

### 1.5.3 Bean 的生命周期

Bean 的生命周期从 Bean 的创建到销毁的整个过程。
Spring 提供了多种方式来管理 Bean 的生命周期。

Spring Bean 的生命周期包括 创建、初始化、使用、销毁，主要流程如下：

1.  **实例化 Bean**
2.  **设置依赖注入**
3.  **执行 @PostConstruct（初始化方法）**
4.  **执行 Bean 业务逻辑**
5.  **执行 @PreDestroy（销毁前回调）**
6.  **销毁 Bean**

定义初始化和销毁方法的方式

- 使用 @PostConstruct 注解定义初始化方法
- 使用 @PreDestroy 注解定义销毁方法

```java
import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import org.springframework.stereotype.Component;

@Component
public class MyBean {

    @PostConstruct // Bean 初始化后执行
    public void init() {
        System.out.println("Bean 初始化...");
    }

    @PreDestroy // Bean 销毁前执行
    public void destroy() {
        System.out.println("Bean 销毁...");
    }
}
```

- 实现 InitializingBean 接口定义初始化方法
- 实现 DisposableBean 接口定义销毁方法

```java
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Component;

@Component
public class MyBean implements InitializingBean, DisposableBean {

    @Override
    public void afterPropertiesSet() throws Exception {
        System.out.println("Bean 初始化...");
    }

    @Override
    public void destroy() throws Exception {
        System.out.println("Bean 销毁...");
    }
}
```

（3）在 XML 配置中指定 init-method 和 destroy-method

```xml
<bean id="myBean" class="com.example.MyBean" init-method="init" destroy-method="destroy"/>
```

### 1.5.4 Bean 的自动装配

Spring 提供了多种方式来实现 Bean 的自动装配。  
Spring 允许自动装配 Bean，而无需手动定义 @Bean。

| **自动装配模式** | **说明**                          |
| ---------------- | --------------------------------- |
| `@Autowired`     | 根据类型自动装配                  |
| `@Qualifier`     | 结合 `@Autowired`，用于按名称装配 |
| `@Primary`       | 指定某个 Bean 为默认 Bean         |
| `@Resource`      | 按名称或类型自动装配              |

```java
@Component
@Primary
public class DieselEngine implements Engine {}

@Component
public class PetrolEngine implements Engine {}

@Component
public class Car {
    @Autowired
    private Engine engine;  // 默认注入 @Primary 的 DieselEngine
}


```

**@Autowired 和 @Resource 的区别**

- @Autowired 是 Spring 提供的注解，默认按类型装配，如果需要按名称装配，可以使用 @Qualifier 注解。
- @Resource 是 JSR-250 提供的注解，默认按名称装配，如果需要按类型装配，可以使用 @Primary 注解。

# 2 AOP

## 2.1 AOP 基础概念

### 2.1.1 什么是 AOP

AOP（Aspect-Oriented Programming，面向切面编程）是一种编程范式，它通过**将横切关注点（cross-cutting concerns）从主业务逻辑中分离出来**，以达到解耦的目的。

- 横切关注点
  - 日志记录
  - 性能监控
  - 事务管理
  - 安全控制
  - 异常处理
  - 缓存管理

### 2.1.2 AOP 的核心概念

- 切面（Aspect）

  - 横切关注点的模块化
  - 包含通知和切点
  - 使用 @Aspect 注解

- 连接点（Join Point）

  - 程序执行的某个特定位置
  - 如方法调用、方法执行、字段修改
  - Spring AOP 中只支持方法级别的连接点

- 切点（Pointcut）

  - 匹配连接点的表达式
  - 定义在何处应用通知
  - 使用 AspectJ 表达式语言

- 通知（Advice）

  - 在切点处要执行的代码
  - 定义在何时执行
    - 前置通知（@Before）
    - 后置通知（@After）
    - 返回通知（@AfterReturning）
    - 异常通知（@AfterThrowing）
    - 环绕通知（@Around）

- 目标对象（Target Object）

  - 被代理的对象
  - 真正的业务逻辑对象

- 代理（Proxy）
  - AOP 框架创建的对象
  - 包含通知和目标对象
  - **JDK 动态代理或 CGLIB 代理**

## 2.2 AOP 实现原理

^494af1

### 2.2.1 代理模式[[代理模式]]

^1d29fe

- JDK 动态代理

  - **基于接口的代理**
  - **实现 InvocationHandler 接口**
  - **使用 Proxy.newProxyInstance 创建代理对象**

  ```java
  // 示例代码
  public class JdkProxyExample implements InvocationHandler {
      private Object target;

      public Object bind(Object target) {
          this.target = target;
          return Proxy.newProxyInstance(
              target.getClass().getClassLoader(),
              target.getClass().getInterfaces(),
              this
          );
      }

      @Override
      public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
          // 前置处理
          Object result = method.invoke(target, args);
          // 后置处理
          return result;
      }
  }
  ```

- CGLIB 代理

  - **基于继承的代理**
  - **实现 MethodInterceptor 接口**
  - **使用 Enhancer 创建代理对象**

  ```java
  // 示例代码
  public class CglibProxyExample implements MethodInterceptor {
      private Object target;

      public Object getInstance(Object target) {
          this.target = target;
          Enhancer enhancer = new Enhancer();
          enhancer.setSuperclass(target.getClass());
          enhancer.setCallback(this);
          return enhancer.create();
      }

      @Override
      public Object intercept(Object obj, Method method, Object[] args, MethodProxy proxy) throws Throwable {
          // 前置处理
          Object result = proxy.invokeSuper(obj, args);
          // 后置处理
          return result;
      }
  }
  ```

### 2.2.2 AOP 代理创建过程

1. **代理选择**

   - 有接口使用 JDK 动态代理
   - 无接口使用 CGLIB 代理
   - 可通过配置强制使用 CGLIB

2. **创建代理**

   - 解析切面
   - 创建代理工厂
   - 生成代理对象

3. **调用链处理**
   - 创建方法调用链
   - 按顺序执行通知
   - 调用目标方法

## 2.3 AOP 使用方式

### 2.3.1 注解方式

1. **启用 AOP**

```java
@Configuration
@EnableAspectJAutoProxy
public class AopConfig {
}
```

2. **定义切面**

```java
@Aspect
@Component
public class LoggingAspect {

    // 定义切点
    @Pointcut("execution(* com.example.service.*.*(..))")
    public void serviceLayer() {}

    // 前置通知
    @Before("serviceLayer()")
    public void beforeAdvice(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().getName();
        System.out.println("Before method: " + methodName);
    }

    // 后置通知
    @After("serviceLayer()")
    public void afterAdvice(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().getName();
        System.out.println("After method: " + methodName);
    }

    // 返回通知
    @AfterReturning(pointcut = "serviceLayer()", returning = "result")
    public void afterReturningAdvice(JoinPoint joinPoint, Object result) {
        String methodName = joinPoint.getSignature().getName();
        System.out.println("Method " + methodName + " returned: " + result);
    }

    // 异常通知
    @AfterThrowing(pointcut = "serviceLayer()", throwing = "ex")
    public void afterThrowingAdvice(JoinPoint joinPoint, Exception ex) {
        String methodName = joinPoint.getSignature().getName();
        System.out.println("Method " + methodName + " threw exception: " + ex.getMessage());
    }

    // 环绕通知
    @Around("serviceLayer()")
    public Object aroundAdvice(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.currentTimeMillis();
        Object result = joinPoint.proceed();
        long end = System.currentTimeMillis();
        System.out.println("Method execution time: " + (end - start) + "ms");
        return result;
    }
}
```

### 2.3.2 XML 配置方式

```xml
<!-- 启用 AOP -->
<aop:aspectj-autoproxy/>

<!-- 定义切面 -->
<aop:config>
    <aop:aspect ref="loggingAspect">
        <!-- 定义切点 -->
        <aop:pointcut id="serviceLayer"
            expression="execution(* com.example.service.*.*(..))"/>

        <!-- 前置通知 -->
        <aop:before pointcut-ref="serviceLayer" method="beforeAdvice"/>

        <!-- 后置通知 -->
        <aop:after pointcut-ref="serviceLayer" method="afterAdvice"/>

        <!-- 返回通知 -->
        <aop:after-returning pointcut-ref="serviceLayer"
            method="afterReturningAdvice" returning="result"/>

        <!-- 异常通知 -->
        <aop:after-throwing pointcut-ref="serviceLayer"
            method="afterThrowingAdvice" throwing="ex"/>

        <!-- 环绕通知 -->
        <aop:around pointcut-ref="serviceLayer" method="aroundAdvice"/>
    </aop:aspect>
</aop:config>
```

### 2.3.3 AspectJ 表达式

- **常用表达式**

  - execution：匹配方法执行

  ```
  execution(modifiers-pattern? ret-type-pattern declaring-type-pattern?name-pattern(param-pattern) throws-pattern?)
  ```

  - within：匹配包/类型

  ```
  within(com.example.service.*)  // 匹配包下的所有类
  within(com.example.service.UserService)  // 匹配特定类
  ```

  - this：匹配代理对象

  ```
  this(com.example.service.UserService)
  ```

  - target：匹配目标对象

  ```
  target(com.example.service.UserService)
  ```

  - args：匹配参数

  ```
  args(String, ..)  // 第一个参数为 String 的方法
  ```

  - @annotation：匹配注解

  ```
  @annotation(com.example.annotation.LogExecutionTime)
  ```

## 2.4 AOP 最佳实践

### 2.4.1 常见应用场景

1. **日志记录**

```java
@Aspect
@Component
public class LoggingAspect {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Around("@annotation(LogExecutionTime)")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long startTime = System.currentTimeMillis();
        Object result = joinPoint.proceed();
        long endTime = System.currentTimeMillis();
        logger.info("Method {} executed in {}ms",
            joinPoint.getSignature().getName(),
            (endTime - startTime));
        return result;
    }
}
```

2. **性能监控**

```java
@Aspect
@Component
public class PerformanceMonitorAspect {
    private final MetricsService metricsService;

    @Around("execution(* com.example.service.*.*(..))")
    public Object monitorPerformance(ProceedingJoinPoint joinPoint) throws Throwable {
        String methodName = joinPoint.getSignature().getName();
        Timer.Sample sample = Timer.start();
        try {
            return joinPoint.proceed();
        } finally {
            sample.stop(Timer.builder("method.execution")
                .tag("method", methodName)
                .register(meterRegistry));
        }
    }
}
```

3. **事务管理**

```java
@Aspect
@Component
public class TransactionAspect {
    private final TransactionTemplate transactionTemplate;

    @Around("@annotation(Transactional)")
    public Object handleTransaction(ProceedingJoinPoint joinPoint) throws Throwable {
        return transactionTemplate.execute(status -> {
            try {
                return joinPoint.proceed();
            } catch (Throwable throwable) {
                status.setRollbackOnly();
                throw new RuntimeException(throwable);
            }
        });
    }
}
```

### 2.4.2 注意事项

1. **代理对象的限制**

   - 内部方法调用不会触发代理
   - 需要通过代理对象调用方法
   - 可以使用 AopContext.currentProxy() 获取代理对象

2. **性能考虑**

   - 避免过多的切面
   - 合理使用切点表达式
   - 选择合适的通知类型

3. **异常处理**

   - 正确处理通知中的异常
   - 不影响目标方法的异常传播
   - 使用 @AfterThrowing 处理特定异常

4. **线程安全**
   - 切面类默认单例
   - 注意共享变量的处理
   - 使用 ThreadLocal 存储线程相关数据

