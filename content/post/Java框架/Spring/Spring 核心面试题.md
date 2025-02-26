---
title: "1 Spring 拦截链的实现？"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Spring 拦截链的实现？

在 Spring 中，**拦截链**通过一系列拦截器对请求或方法调用进行分层处理，常用于日志记录、权限校验、事务管理等横切关注点。

---

### 1.1.1 **拦截链的组成**
Spring 拦截链主要包含以下两类拦截器：
1. **Servlet 过滤器（Filter）**  
   - 属于 Servlet 规范，优先级最高，对所有请求生效。
   - 通过 `javax.servlet.Filter` 接口实现。
2. **Spring MVC 拦截器（HandlerInterceptor）**  
   - 属于 Spring MVC 框架，在 DispatcherServlet 处理请求时生效。
   - 通过实现 `HandlerInterceptor` 接口或继承 `HandlerInterceptorAdapter`。
3. **AOP 切面（Aspect）**  
   - 通过动态代理实现方法级别的拦截。
   - 使用 `@Aspect` 注解和通知类型（如 `@Around`）。

---

### 1.1.2 **HandlerInterceptor 接口方法**
在 Spring MVC 中，拦截器的核心方法是：
- **`preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)`**  
  - **执行时机**：Controller 方法调用前。  
  - **用途**：权限校验、参数预处理。  
  - **返回值**：`true` 表示放行，`false` 终止请求。  

- **`postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView)`**  
  - **执行时机**：Controller 方法执行后，视图渲染前。  
  - **用途**：修改 ModelAndView 数据。  

- **`afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)`**  
  - **执行时机**：整个请求处理完成后（视图渲染结束）。  
  - **用途**：资源清理、异常处理。  

---

### 1.1.3 **配置拦截器**
通过实现 `WebMvcConfigurer` 接口注册拦截器：
```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AuthInterceptor())
                .addPathPatterns("/**")        // 拦截所有路径
                .excludePathPatterns("/login");// 排除登录页
    }
}
```

---

### 1.1.4 **示例：自定义拦截器**
```java
public class LoggingInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        System.out.println("请求开始: " + request.getRequestURI());
        return true; // 放行
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) {
        System.out.println("请求处理完成，视图未渲染");
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        System.out.println("请求结束，资源已清理");
    }
}
```

---

### 1.1.5 **执行顺序**
1. **过滤器链（Filter）** → **DispatcherServlet** → **MVC 拦截器** → **Controller** → **AOP 切面**  
2. 多个 MVC 拦截器的执行顺序由注册顺序决定，`preHandle` 按注册顺序执行，`postHandle` 和 `afterCompletion` 逆序执行。

---

### 1.1.6 **拦截器 vs AOP 切面**
| **场景**   | **MVC 拦截器**   | **AOP 切面**           |
| -------- | ------------- | -------------------- |
| **作用范围** | HTTP 请求级别     | 方法调用级别               |
| **适用场景** | 权限校验、请求日志     | 事务管理、方法性能监控          |
| **依赖**   | Spring MVC 环境 | 支持非 Web 环境（如普通 Bean） |

---

### 1.1.7 **注意事项**
- **执行顺序**：过滤器 > 拦截器 > AOP 切面。
- **性能优化**：拦截器中避免阻塞操作（如同步 IO）。
- **异常处理**：在 `afterCompletion` 中统一处理异常。
- **路径匹配**：支持 Ant 风格路径（如 `/api/**`）。

# 2 什么是 AOP？

### 2.1.1 **基本定义**
- **AOP（Aspect-Oriented Programming）**：面向切面编程，一种编程范式，通过将**横切关注点**（与业务逻辑无关但需多处重复使用的功能）从业务代码中分离，提升模块化和代码复用性。
- **核心目标**：解决代码分散（如日志、事务、安全等代码遍布多个模块）和代码纠缠（业务逻辑与非业务逻辑混合）的问题。

---

### 2.1.2 **核心思想**
- **横切关注点（Cross-Cutting Concerns）**：  
  指那些影响多个模块的功能，如：  
  - 日志记录  
  - 事务管理  
  - 权限校验  
  - 性能监控  
  - 异常处理  
- **实现方式**：通过**切面（Aspect）**将这些关注点模块化，并动态织入到目标方法中，避免硬编码。

---

### 2.1.3 **AOP 核心概念**
| **概念**              | **说明**                                                                                                                             | **示例**                                      |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| **切面（Aspect）**      | 封装横切关注点的模块，包含通知和切点定义。                                                                                                              | 日志切面、事务切面。                                  |
| **连接点（Join Point）** | 程序执行过程中可插入切面的点（如方法调用、异常抛出）。                                                                                                        | `UserService.save()` 方法执行时。                 |
| **通知（Advice）**      | 切面在特定连接点执行的动作。分为：<br>- `@Before`（方法前）<br>- `@After`（方法后）<br>- `@Around`（环绕）<br>- `@AfterThrowing`（异常时）<br>- `@AfterReturning`（返回后） | `@Before("execution(* UserService.*(..))")` |
| **切点（Pointcut）**    | 通过表达式定义哪些连接点需要被切面处理。                                                                                                               | `execution(* com.example.service.*.*(..))`  |
| **织入（Weaving）**     | 将切面应用到目标对象的过程，可在编译期、类加载期或运行期实现。                                                                                                    | Spring AOP 使用动态代理实现运行时织入。                   |

---

### 2.1.4 **AOP 的实现方式**
- **动态代理**：基于接口或子类生成代理对象，在方法调用前后插入切面逻辑（Spring AOP 默认使用 JDK 动态代理或 CGLIB）。  
- **字节码增强**：通过修改字节码在编译期或类加载期织入切面（如 AspectJ）。  

---

### 2.1.5 **AOP 的应用场景**
- **事务管理**：通过 `@Transactional` 注解自动管理数据库事务。  
- **统一日志**：记录方法入参、返回值、执行时间等。  
- **权限控制**：拦截请求并校验用户权限。  
- **性能监控**：统计方法耗时并生成报告。  
- **异常处理**：统一捕获异常并记录到日志或发送告警。  

---

### 2.1.6 **AOP 的优势与局限**
| **优势**        | **局限**                     |
| ------------- | -------------------------- |
| 代码复用性高，减少冗余代码 | 过度使用可能增加调试难度（逻辑分散）         |
| 业务逻辑与非业务逻辑解耦  | 对私有方法或静态方法支持有限（依赖代理机制）     |
| 提升可维护性和扩展性    | 某些场景需结合 AspectJ 实现更复杂的切面逻辑 |
|               |                            |

---

### 2.1.7 **示例代码**
```java
@Aspect
@Component
public class LogAspect {
    // 定义切点：拦截所有 Service 类的方法
    @Pointcut("execution(* com.example.service.*.*(..))")
    public void serviceMethods() {}

    // 前置通知：记录方法调用开始
    @Before("serviceMethods()")
    public void logStart(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().getName();
        System.out.println("方法 " + methodName + " 开始执行");
    }

    // 环绕通知：记录方法耗时
    @Around("serviceMethods()")
    public Object logTime(ProceedingJoinPoint pjp) throws Throwable {
        long start = System.currentTimeMillis();
        Object result = pjp.proceed(); // 执行目标方法
        long end = System.currentTimeMillis();
        System.out.println("方法耗时：" + (end - start) + "ms");
        return result;
    }
}
```



# 3 什么是 IOC 和 DI？

### 3.1.1 **基本概念**
- **IOC（Inversion of Control，控制反转）**  
  **核心思想**：将对象的创建、依赖管理和生命周期控制权从代码中转移到外部容器或框架。  
  **传统方式**：开发者手动通过 `new` 关键字创建对象并管理依赖（高耦合）。  
  **IOC 方式**：容器负责对象的创建和依赖注入，开发者只需定义依赖关系（低耦合）。  

- **DI（Dependency Injection，依赖注入）**  
  **定义**：一种实现 IOC 的具体技术，由容器动态地将依赖对象注入到目标对象中，而不是由目标对象自行创建依赖。  
  **目标**：解耦组件，提升代码的可维护性和可测试性。

---

### 3.1.2 **IOC 与 DI 的关系**
- **IOC 是设计原则**，强调控制权的反转。  
- **DI 是实现 IOC 的具体手段**，通过注入依赖来实现控制权的转移。  
- **其他 IOC 实现方式**：服务定位器模式（Service Locator），但 DI 更主流。

---

### 3.1.3 **依赖注入的三种方式**
| **注入方式**        | **说明**                            | **示例**                                                                                                                                                                    |
| --------------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **构造函数注入**      | 通过构造函数传递依赖对象，强制依赖初始化。             | ```java<br>public class UserService {<br>    private UserRepository repo;<br>    public UserService(UserRepository repo) {<br>        this.repo = repo;<br>    }<br>}```  |
| **Setter 方法注入** | 通过 Setter 方法设置依赖对象，可选依赖或需变更依赖时使用。 | ```java<br>public class UserService {<br>    private UserRepository repo;<br>    public void setRepo(UserRepository repo) {<br>        this.repo = repo;<br>    }<br>}``` |
| **接口注入**        | 通过实现特定接口来注入依赖（较少使用）。              | 略                                                                                                                                                                         |

---

### 3.1.4 **Spring 中的 IOC 与 DI**
- **IOC 容器**：Spring 通过 `ApplicationContext` 或 `BeanFactory` 管理 Bean 的生命周期和依赖关系。  
- **配置方式**：  
  - **XML 配置**：传统方式，显式定义 Bean 及其依赖。  
    ```xml
    <bean id="userRepo" class="com.example.UserRepository"/>
    <bean id="userService" class="com.example.UserService">
        <constructor-arg ref="userRepo"/>
    </bean>
    ```
  - **注解配置**：现代方式，使用 `@Component`、`@Autowired` 等注解简化配置。  
    ```java
    @Component
    public class UserService {
        @Autowired
        private UserRepository repo;
    }
    ```

---

### 3.1.5 **为什么需要 IOC 和 DI？**
- **解耦**：减少类之间的直接依赖，修改依赖实现时无需改动业务代码。  
- **可测试性**：通过注入模拟对象（Mock），方便单元测试。  
- **可维护性**：集中管理依赖关系，代码结构更清晰。  
- **灵活性**：动态替换依赖的实现（如切换数据库驱动）。

---

### 3.1.6 **示例：Spring 中的依赖注入**
```java
// 1. 定义依赖类
@Component
public class UserRepository {
    public void save() {
        System.out.println("保存用户数据");
    }
}

// 2. 目标类通过构造函数注入依赖
@Component
public class UserService {
    private final UserRepository userRepo;

    @Autowired // 可省略（Spring 4.3+ 支持隐式构造函数注入）
    public UserService(UserRepository userRepo) {
        this.userRepo = userRepo;
    }

    public void process() {
        userRepo.save();
    }
}

// 3. 测试类
public class App {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext("com.example");
        UserService userService = context.getBean(UserService.class);
        userService.process(); // 输出：保存用户数据
    }
}
```

---

### 3.1.7 **核心概念扩展**
- **Bean**：由 Spring 容器管理的对象。  
- **作用域（Scope）**：  
  - `singleton`（默认）：单例，容器中仅一个实例。  
  - `prototype`：每次请求创建新实例。  
  - `request`、`session`：Web 环境专用。  
- **生命周期回调**：通过 `@PostConstruct` 和 `@PreDestroy` 定义初始化和销毁逻辑。

# 4 Spring 依赖注入有几种？各有什么优缺点？

在 Spring 中实现依赖注入的常见方式有以下 3 种：

- **属性注入（Field Injection）；**
- **Setter 注入（Setter Injection）；**
- **构造方法注入（Constructor Injection）。**


---

### 4.1.1 **Spring 中的依赖注入方式**

在 Spring 框架中，依赖注入（Dependency Injection, DI）是实现控制反转（IOC）的核心技术，主要通过以下 **4种方式** 实现：

---

#### 4.1.1.1 **1. 构造函数注入（Constructor Injection）**
- **实现方式**：通过类的构造函数传递依赖对象。  
- **优点**：  
  - 强制依赖初始化，确保对象创建时所有必需依赖已就位。  
  - 适合注入不可变（`final`）字段。  
- **示例**：  
  ```java
  @Component
  public class UserService {
      private final UserRepository userRepo;
      
      // Spring 4.3+ 可省略 @Autowired
      @Autowired
      public UserService(UserRepository userRepo) {
          this.userRepo = userRepo;
      }
  }
  ```

---

#### 4.1.1.2 **2. Setter 方法注入（Setter Injection）**
- **实现方式**：通过 Setter 方法设置依赖对象。  
- **优点**：  
  - 支持可选依赖或需动态变更依赖的场景。  
- **示例**：  
  ```java
  @Component
  public class OrderService {
      private PaymentService paymentService;
      
      @Autowired
      public void setPaymentService(PaymentService paymentService) {
          this.paymentService = paymentService;
      }
  }
  ```

---

#### 4.1.1.3 **3. 字段注入（Field Injection）**
- **实现方式**：直接在字段上添加 `@Autowired` 注解。  
- **优点**：  
  - 代码简洁，无需显式编写构造函数或 Setter 方法。  
- **缺点**：  
  - 无法注入 `final` 字段，不利于单元测试（需依赖容器）。  
- **示例**：  
  ```java
  @Component
  public class ProductService {
      @Autowired
      private InventoryService inventoryService;
  }
  ```

---

#### 4.1.1.4 **4. 方法注入（Method Injection）**
- **实现方式**：在任意方法（非 Setter）上使用 `@Autowired` 注解，Spring 在 Bean 初始化后调用该方法并注入参数。  
- **适用场景**：  
  - 需要根据依赖动态初始化某些资源。  
- **示例**：  
  ```java
  @Component
  public class ReportGenerator {
      private DataSource dataSource;
      
      @Autowired
      public void initDataSource(DataSource dataSource) {
          this.dataSource = dataSource;
      }
  }
  ```

---

### 4.1.2 **对比与最佳实践**
| **注入方式**      | **适用场景**     | **优点**     | **缺点**             |
| ------------- | ------------ | ---------- | ------------------ |
| **构造函数注入**    | 必需依赖、不可变字段   | 强依赖保证，线程安全 | 参数较多时代码冗长          |
| **Setter 注入** | 可选依赖或需动态变更依赖 | 灵活性高       | 依赖可能未完全初始化         |
| **字段注入**      | 快速开发、非关键依赖   | 代码简洁       | 不利于测试，不支持 final 字段 |
| **方法注入**      | 复杂初始化逻辑      | 灵活控制依赖注入时机 | 使用场景有限             |

---

### 4.1.3 **Spring 官方推荐**
1. **优先使用构造函数注入**：确保依赖不可变且完全初始化，符合不可变对象设计原则。  
2. **Setter 注入用于可选依赖**：如配置参数或可替换实现。  
3. **避免过度使用字段注入**：仅在简单场景下使用，避免隐藏依赖关系。  


# 5 Spring AOP默认用的是什么动态代理，两者的区别？

Spring Framework 默认使用的动态代理是 JDK 动态代理，SpringBoot 2.x 版本的默认动态代理是 CGLIB。

### 5.1.1 两者的主要区别

**代理方式**：

- **JDK 动态代理**：基于接口实现，通过 `java.lang.reflect.Proxy` 动态生成代理类。
- **CGLIB 动态代理**：基于类继承，通过字节码技术生成目标类的子类，来实现对目标方法的代理。

# 6 Spring 中的 BeanFactory 和 ApplicationContext 有什么区别？


| **特性**   | **BeanFactory**              | **ApplicationContext**             |
| -------- | ---------------------------- | ---------------------------------- |
| **功能**   | 提供基本的依赖注入功能                  | 提供更丰富的功能，如国际化、事件传播、AOP 等           |
| **加载方式** | 懒加载（Lazy Loading）            | 预加载（Eager Loading）                 |
| **实现类**  | `DefaultListableBeanFactory` | `ClassPathXmlApplicationContext` 等 |
| **适用场景** | 资源受限的环境（如移动设备）               | 企业级应用                              |




# 7 Spring 中的 @Autowired 和 @Resource 有什么区别？

| **特性**   | **@Autowired** | **@Resource**          |
| -------- | -------------- | ---------------------- |
| **来源**   | Spring 框架      | JSR-250 标准             |
| **注入方式** | 按类型注入（默认）      | 按名称注入（默认）              |
| **支持类型** | 支持构造函数、字段、方法注入 | 支持字段、方法注入              |
| **名称匹配** | 不支持名称匹配        | 支持名称匹配（通过 `name` 属性指定） |

[^1]: 

