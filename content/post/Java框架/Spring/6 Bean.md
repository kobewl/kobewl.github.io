---
title: "1 什么是Spring Bean？"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 什么是Spring Bean？

在Spring框架中，Bean是指一个由Spring容器管理的对象。这个对象可以是任何一个Java类的实例，例如数据库连接、业务逻辑类、控制器等等。Bean实例的创建和管理是由Spring容器负责的，而不是由应用程序本身负责。

Bean的主要优势是可以将对象的创建和管理与业务逻辑分离。这使得应用程序更加灵活和易于维护。例如，在一个Web应用程序中，我们可以将数据库连接的创建和管理交给Spring容器，而业务逻辑则由应用程序本身负责。这样，当我们需要切换到另一个数据库时，只需要修改Spring配置文件即可，而不需要修改应用程序的代码。

# 2 怎样创建Bean?

^0f0a97

Spring容器中的Bean实例是通过IoC（Inversion of Control，控制反转）机制来创建和管理的。控制反转是一种面向对象编程的设计模式，它可以将程序的控制权从应用程序本身转移到一个外部容器中，由容器来负责管理对象的创建和销毁。

Spring容器提供了三种主要方式来创建和管理Bean：

## 2.1 XML配置方式
- 通过在XML文件中使用<bean>标签定义Bean
- 配置Bean的属性、依赖关系和作用域
- 示例：
```xml
<bean id="userService" class="com.example.UserService">
    <property name="userDao" ref="userDao"/>
</bean>
```

## 2.2 注解配置方式
- 使用@Component、@Service、@Repository、@Controller等注解
- 使用@Autowired、@Resource等注解进行依赖注入
- 示例：
```java
@Service
public class UserService {
    @Autowired
    private UserDao userDao;
}
```

### 2.2.1 @Autowired 和 @Resource 的区别

^c5c993

1. **来源不同**：
   - @Autowired 是 Spring 框架提供的注解
   - @Resource 是 JDK 提供的注解（javax.annotation.Resource）

2. **装配方式**：
   - @Autowired 默认按照**类型**装配（byType），如果想使用按照名称装配，需要结合@Qualifier注解
   - @Resource 默认按照**名称**装配（byName），当找不到与名称匹配的bean才会按照类型装配

3. **属性**：
   - @Autowired 只有一个 required 属性，默认为 true，表示注入失败会抛出异常
   - @Resource 有 name 和 type 属性，可以通过这两个属性精确指定注入的 bean

4. **使用范围**：
   - @Autowired 可用于构造函数、方法、参数、字段和注解上
   - @Resource 只能用于字段和方法上

5. **推荐使用场景**：
   - @Autowired：推荐在 Spring 项目中使用，特别是需要与其他 Spring 特性配合时
   - @Resource：推荐在 Java EE 项目中使用，特别是需要遵循 JDK 规范的场景

示例：
```java
@Service
public class UserService {
    // 按类型注入
    @Autowired
    private UserDao userDao;
    
    // 按名称注入
    @Resource(name = "orderDao")
    private OrderDao orderDao;
    
    // 按类型注入并指定名称
    @Autowired
    @Qualifier("specificUserDao")
    private UserDao specificUserDao;
}
```

# 3 Spring Bean 相关面试题

## 3.1 Bean 的循环依赖问题

### 3.1.1 什么是循环依赖？
循环依赖指的是多个 Bean 之间相互依赖，形成了一个闭环。例如：A 依赖 B，B 依赖 C，C 又依赖 A。

### 3.1.2 Spring 如何解决循环依赖？
Spring 主要通过三级缓存机制来解决循环依赖：

1. **一级缓存**（singletonObjects）：存放完全初始化好的 bean
2. **二级缓存**（earlySingletonObjects）：存放原始的 bean 对象（尚未填充属性）
3. **三级缓存**（singletonFactories）：存放 bean 的工厂对象

### 3.1.3 循环依赖的限制条件
- 只能解决单例作用域的 bean 循环依赖
- 构造器注入的循环依赖无法解决
- 使用@Async的循环依赖无法解决

## 3.2 Bean 的延迟加载

### 3.2.1 什么是延迟加载？
延迟加载（Lazy Loading）指的是 Spring 容器启动时不会立即创建 bean，而是在第一次使用时才创建。

### 3.2.2 如何实现延迟加载？
1. **XML配置方式**：使用 lazy-init 属性
```xml
<bean id="lazyBean" class="com.example.LazyBean" lazy-init="true"/>
```

2. **注解方式**：使用 @Lazy 注解
```java
@Lazy
@Component
public class LazyBean {
    // ...
}
```

## 3.3 Bean 的线程安全问题

### 3.3.1 Spring Bean 是线程安全的吗？
Spring 容器本身并不能保证 Bean 的线程安全，需要开发者自己来保证：

1. **Singleton Bean**：
   - 默认是单例的，可能存在线程安全问题
   - 解决方案：使用 ThreadLocal、使用同步机制、或改为 Prototype 作用域

2. **Prototype Bean**：
   - 每次请求都创建新实例，不存在线程安全问题
   - 但会增加系统开销

### 3.3.2 如何保证线程安全？
1. 将 Bean 设置为 prototype 作用域
2. 使用 ThreadLocal
3. 使用同步机制（synchronized、Lock等）
4. 使用无状态的 Bean

## 3.4 Java配置方式
- 使用@Configuration和@Bean注解
- 通过Java代码显式配置Bean
- 示例：
```java
@Configuration
public class AppConfig {
    @Bean
    public UserService userService() {
        UserService service = new UserService();
        service.setUserDao(userDao());
        return service;
    }
}
```

## 3.5 三种配置方式对比

### 3.5.1 XML配置方式
- **优点**：
  - 集中管理，便于统一配置
  - 修改配置不需要重新编译代码
  - 适合第三方类库的Bean配置
- **缺点**：
  - 配置文件较大时难以维护
  - 无法在编译时检查配置正确性
  - 重构代码时XML配置容易出错

### 3.5.2 注解配置方式
- **优点**：
  - 配置简单，开发效率高
  - 代码和配置放在一起，直观
  - 适合项目自身的业务类配置
- **缺点**：
  - 配置分散在各个类中
  - 修改配置需要重新编译代码

### 3.5.3 Java配置方式
- **优点**：
  - 类型安全，编译时可以检查
  - 支持代码补全和重构
  - 适合复杂Bean的配置
- **缺点**：
  - 配置代码量较大
  - 修改配置需要重新编译

### 3.5.4 最佳实践建议
1. **混合使用**：
   - XML配置：适用于第三方库的Bean
   - 注解配置：适用于业务组件
   - Java配置：适用于需要编程方式创建的Bean

2. **选择依据**：
   - 项目规模和复杂度
   - 团队对Spring的熟悉程度
   - 是否需要运行时修改配置
   - 是否涉及第三方库的集成


# 4 Bean 的作用域？

^341556

除了创建和管理Bean实例外，Spring还支持为Bean实例指定作用域。Bean的作用域决定了Bean实例的生命周期，例如何时创建、何时销毁等。

Spring支持以下几种作用域：

* ==Singleton==：在整个应用程序中只创建一个Bean实例。(默认)
* ==Prototype==：每次获取Bean实例时都创建一个新的实例。
* ==request==：每次http请求都会创建一个bean，仅在基于web的Spring应用程序中有效。
* ==session==：在一个HTTP Session中，一个bean定义对应一个实例，仅在基于web的Spring应用程序中有效。
* ==global-session==：在一个全局的HTTP Session中，一个bean定义对应一个实例并共享给其他porltet，仅在基于porltet的web应用中使用Spring时有效。

# 5 Bean 的生命周期？

^4579b8

1. 实例化：为 Bean 分配内存空间；
2. 设置属性：将当前类依赖的 Bean 属性，进行注入和装配；
3. 初始化：
    1. 执行各种通知；
    2. 执行初始化的前置方法；
    3. 执行初始化方法；
    4. 执行初始化的后置方法。
4. 使用 Bean：在程序中使用 Bean 对象；
5. 销毁 Bean：将 Bean 对象进行销毁操作。


# 6 FactoryBean是什么？BeanFactory 是什么？

### 6.1.1 什么是FactoryBean？

- **定义**：`FactoryBean` 是 Spring 提供的一个接口，用于**自定义复杂对象的创建逻辑**。它是一个“工厂Bean”，作用是生成其他 Bean 的实例，而非自身。
    
- **核心方法**：
    
    - `getObject()`：返回工厂生产的对象实例。
        
    - `getObjectType()`：定义生产对象的类型。
        
    - `isSingleton()`：控制对象是否为单例。
        
- **关键特性**：
    
    - 从容器中获取 FactoryBean 时（如 `getBean("myFactoryBean")`），返回的是其生产的对象（即 `getObject()` 的结果）。
        
    - 若要获取 FactoryBean 本身，需在 Bean 名称前加 `&`（如 `getBean("&myFactoryBean")`）。
        
- **使用场景**：
    
    - 创建过程复杂的 Bean（如 MyBatis 的 `SqlSessionFactoryBean`）。
        
    - 需要动态生成非单例 Bean。

### 6.1.2 如何使用FactoryBean？

使用FactoryBean的情况一般是：

当我们注册的bean需要一系列复杂的初始化步骤。
我们需要创建一个非单例的bean，并且需要在运行时彻底实现某些操作，或者我们需要对bean实例进行精细控制。
实现FactoryBean非常简单，只需要：

6. 声明一个类**实现FactoryBean接口**。
7. **实现getObject()方法**来定义创建对象的逻辑。
8. 实现getObjectType()方法**返回创建对象的类型**。
9. 通过**实现isSingleton()方法**来决定你的bean是原型还是单例。


### 6.1.3 BeanFactory 是什么？

- **定义**：`BeanFactory` 是 Spring **IoC 容器的核心接口**，负责 Bean 的**生命周期管理**（创建、配置、装配）。
    
- **核心功能**：
    
    - 通过 `getBean()` 获取 Bean 实例。
        
    - 管理 Bean 的作用域（单例、原型等）。
        
    - 处理 Bean 的依赖注入。
        
- **关键实现**：
    
    - `ApplicationContext`（扩展了 `BeanFactory`，提供企业级功能如事件发布、国际化等）。
        
    - `DefaultListableBeanFactory`（基础实现，可直接编程使用）。
        
- **与 ApplicationContext 的区别**：  
    **与ApplicationContext的区别**：
    
    - `BeanFactory` 是基础容器，默认懒加载 Bean。
        
    - `ApplicationContext` 是高级容器，支持即时加载、AOP 集成等，更常用。


#### 6.1.3.1 **3. FactoryBean 与 BeanFactory 的对比**

| **特性**      | **FactoryBean  工厂Bean**                     | **BeanFactory  Bean工厂**              |
| ----------- | ------------------------------------------- | ------------------------------------ |
| **角色**      | 生产其他 Bean 的“工厂Bean”                         | 管理所有 Bean 的“容器”                      |
| **接口类型**    | 需要实现 `FactoryBean<T>` 接口                    | 是 Spring 容器的根接口                      |
| **获取对象的方式** | 通过 `getBean("factoryBeanName")`             | 通过 `getBean("beanName")`             |
| **自身实例的获取** | 需使用 `&` 前缀（如 `getBean("&factoryBeanName")`） | 直接通过名称获取（如 `getBean("beanFactory")`） |
| **典型应用场景**  | 创建复杂对象（如第三方库集成）                             | 所有 Spring 应用的 Bean 管理基础              |


# 7 什么是**ObjectFactory**？

**ObjectFactory** 是 Spring 框架中一个**延迟对象获取接口**，用于在需要时按需创建或获取 Bean 实例。它是一个函数式接口（`@FunctionalInterface`），核心方法是 `T getObject()`，允许在运行时动态生成对象，常用于解决以下场景：

- **延迟初始化**：避免 Bean 过早初始化。
    
- **原型作用域（Prototype）Bean 的按需获取**：每次调用 `getObject()` 返回新实例。
    
- **解决循环依赖**：通过延迟注入打破某些循环依赖场景。
    

---

#### 7.1.1.1 **ObjectFactory 与 FactoryBean 的区别**

|**特性**|**ObjectFactory  对象工厂**|**FactoryBean  工厂Bean**|
|---|---|---|
|**接口类型**|函数式接口 (`@FunctionalInterface`)|Spring 的特殊 Bean 接口|
|**核心目的**|**延迟获取 Bean 实例**|**定义复杂 Bean 的创建逻辑**|
|**使用场景**|运行时动态生成对象（如原型 Bean）|封装初始化逻辑（如集成第三方库的配置）|
|**Bean 生命周期管理**|不管理 Bean 生命周期，仅按需获取|完全控制 Bean 的创建过程|
|**典型实现方式**|直接通过 Spring 容器注入|需要实现 `FactoryBean` 接口|


# 8 Spring 中的 ApplicationContext 是什么？

#### 8.1.1.1 **ApplicationContext 的定义与核心角色**

**ApplicationContext** 是 Spring 框架中 **IoC 容器的核心接口**，也是 Spring 容器的**高级表现形式**。它继承自 `BeanFactory` 接口，并在此基础上扩展了大量企业级功能（如事件发布、国际化、资源加载等），是 Spring 应用开发中**最常用的容器实现**。

---

#### 8.1.1.2 **ApplicationContext 的核心功能**

|**功能分类**|**具体能力**|
|---|---|
|**Bean 管理**|继承 `BeanFactory`，负责 Bean 的**创建、配置、依赖注入及生命周期管理**。|
|**资源访问**|支持统一资源加载（如 `ClassPathResource`、`FileSystemResource`）。|
|**国际化（i18n）**|通过 `MessageSource` 接口支持多语言消息解析。|
|**事件发布与监听**|提供基于观察者模式的事件机制（`ApplicationEvent` 和 `ApplicationListener`）。|
|**AOP 集成**|自动代理生成，支持面向切面编程。|
|**环境配置**|通过 `Environment` 接口管理配置文件（如 `@PropertySource` 注解）。|
|**注解驱动**|支持 `@ComponentScan`、`@Configuration` 等注解配置。|

---

#### 8.1.1.3 **ApplicationContext 与 BeanFactory 的对比**

|**特性**|**ApplicationContext  应用上下文**|**BeanFactory  Bean工厂**|
|---|---|---|
|**功能定位**|**高级容器**，提供企业级功能|**基础容器**，仅管理 Bean 生命周期|
|**Bean 加载策略**|**即时加载**（启动时初始化所有单例 Bean）|**懒加载**（按需初始化 Bean）|
|**事件机制**|支持事件发布与监听|不支持|
|**国际化支持**|支持|不支持|
|**资源访问**|提供统一资源加载 API|无内置支持|
|**使用场景**|实际生产环境|轻量级场景（如移动端资源受限环境）|

 



