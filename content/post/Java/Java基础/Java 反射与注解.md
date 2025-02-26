---
title: "1 Java 反射与注解"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Java 反射与注解

## 1.1 反射基础[[反射机制]]

### 1.1.1 什么是反射？

```ascii
反射机制：
┌─────────────────┐
│    编译时       │ ──→ 静态加载类
└────────┬────────┘
         │
         v
┌─────────────────┐
│    运行时       │ ──→ 动态加载类
└────────┬────────┘     动态访问/修改属性
         │             动态调用方法
         v
┌─────────────────┐
│   反射操作      │
└─────────────────┘
```

### 1.1.2 获取 Class 对象

```java
// 1. 通过类名
Class<?> class1 = String.class;

// 2. 通过对象
String str = "Hello";
Class<?> class2 = str.getClass();

// 3. 通过完整类名
Class<?> class3 = Class.forName("java.lang.String");

// 4. 通过类加载器
ClassLoader loader = ClassLoader.getSystemClassLoader();
Class<?> class4 = loader.loadClass("java.lang.String");
```

## 1.2 反射操作

### 1.2.1 类信息操作

```java
Class<?> clazz = MyClass.class;

// 1. 获取类名
String className = clazz.getName();          // 完整类名
String simpleName = clazz.getSimpleName();   // 简单类名

// 2. 获取修饰符
int modifiers = clazz.getModifiers();
boolean isPublic = Modifier.isPublic(modifiers);

// 3. 获取包信息
Package pkg = clazz.getPackage();

// 4. 获取父类
Class<?> superClass = clazz.getSuperclass();

// 5. 获取接口
Class<?>[] interfaces = clazz.getInterfaces();
```

### 1.2.2 构造方法操作

```java
// 1. 获取构造方法
Constructor<?>[] constructors = clazz.getConstructors();           // 公共构造方法
Constructor<?>[] allConstructors = clazz.getDeclaredConstructors();// 所有构造方法

// 2. 获取特定构造方法
Constructor<?> constructor = clazz.getConstructor(String.class, int.class);

// 3. 创建实例
Object instance = constructor.newInstance("Hello", 42);
```

### 1.2.3 字段操作

```java
// 1. 获取字段
Field[] fields = clazz.getFields();           // 公共字段
Field[] allFields = clazz.getDeclaredFields();// 所有字段

// 2. 获取特定字段
Field field = clazz.getDeclaredField("name");

// 3. 访问字段
field.setAccessible(true);  // 设置可访问
Object value = field.get(instance);  // 获取值
field.set(instance, "newValue");     // 设置值
```

### 1.2.4 方法操作

```java
// 1. 获取方法
Method[] methods = clazz.getMethods();           // 公共方法
Method[] allMethods = clazz.getDeclaredMethods();// 所有方法

// 2. 获取特定方法
Method method = clazz.getDeclaredMethod("myMethod", String.class);

// 3. 调用方法
method.setAccessible(true);  // 设置可访问
Object result = method.invoke(instance, "parameter");
```

## 1.3 注解基础

^e9934b

### 1.3.1 注解定义

```java
// 1. 基本注解
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAnnotation {
    String value() default "";
    int count() default 0;
}

// 2. 元注解说明
@Target - 注解使用位置
@Retention - 注解保留策略
@Documented - 是否生成文档
@Inherited - 是否可继承
```

### 1.3.2 注解使用

```java
// 1. 类注解
@MyAnnotation(value = "class", count = 1)
public class MyClass {

    // 2. 方法注解
    @MyAnnotation("method")
    public void myMethod() {}

    // 3. 字段注解
    @MyAnnotation
    private String field;
}
```

## 1.4 注解处理

### 1.4.1 运行时注解处理

```java
// 1. 获取类上的注解
MyAnnotation annotation = clazz.getAnnotation(MyAnnotation.class);
String value = annotation.value();
int count = annotation.count();

// 2. 获取方法上的注解
Method method = clazz.getDeclaredMethod("myMethod");
MyAnnotation methodAnnotation = method.getAnnotation(MyAnnotation.class);

// 3. 获取字段上的注解
Field field = clazz.getDeclaredField("field");
MyAnnotation fieldAnnotation = field.getAnnotation(MyAnnotation.class);
```

### 1.4.2 注解处理器示例

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@interface Table {
    String name();
}

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@interface Column {
    String name();
    String type() default "VARCHAR";
}

// 使用注解
@Table(name = "users")
public class User {
    @Column(name = "user_id", type = "INTEGER")
    private int id;

    @Column(name = "user_name")
    private String name;
}

// 处理注解
public class AnnotationProcessor {
    public static String createTable(Class<?> clazz) {
        StringBuilder sql = new StringBuilder();

        // 获取表名
        Table table = clazz.getAnnotation(Table.class);
        String tableName = table.name();

        sql.append("CREATE TABLE ").append(tableName).append(" (");

        // 获取字段
        for (Field field : clazz.getDeclaredFields()) {
            if (field.isAnnotationPresent(Column.class)) {
                Column column = field.getAnnotation(Column.class);
                sql.append(column.name())
                   .append(" ")
                   .append(column.type())
                   .append(",");
            }
        }

        sql.deleteCharAt(sql.length() - 1);
        sql.append(");");

        return sql.toString();
    }
}
```

## 1.5 反射应用场景

### 1.5.1 框架开发

```ascii
框架应用场景：
┌─────────────────┐
│ 依赖注入 (DI)   │ Spring Framework
├─────────────────┤
│ 对象关系映射    │ Hibernate/MyBatis
├─────────────────┤
│ 单元测试        │ JUnit
└─────────────────┘
```

### 1.5.2 动态代理

```java
// 1. 定义接口
interface UserService {
    void save(String data);
}

// 2. 实现类
class UserServiceImpl implements UserService {
    public void save(String data) {
        System.out.println("保存数据: " + data);
    }
}

// 3. 动态代理处理器
class LogHandler implements InvocationHandler {
    private Object target;

    public LogHandler(Object target) {
        this.target = target;
    }

    public Object invoke(Object proxy, Method method, Object[] args)
            throws Throwable {
        System.out.println("开始执行: " + method.getName());
        Object result = method.invoke(target, args);
        System.out.println("执行结束");
        return result;
    }
}

// 4. 创建代理
UserService service = new UserServiceImpl();
UserService proxy = (UserService) Proxy.newProxyInstance(
    service.getClass().getClassLoader(),
    service.getClass().getInterfaces(),
    new LogHandler(service)
);
```

## 1.6 性能优化

### 1.6.1 缓存反射信息

```java
// 缓存 Class 对象
private static final Map<String, Class<?>> CLASS_CACHE =
    new ConcurrentHashMap<>();

// 缓存 Method 对象
private static final Map<String, Method> METHOD_CACHE =
    new ConcurrentHashMap<>();

// 使用缓存
public static Class<?> getClass(String className) {
    return CLASS_CACHE.computeIfAbsent(className, name -> {
        try {
            return Class.forName(name);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    });
}
```

### 1.6.2 避免重复反射操作

```java
// 不推荐
method.setAccessible(true);  // 每次调用都设置
method.invoke(instance, args);

// 推荐
// 一次性设置
Method method = clazz.getDeclaredMethod("myMethod");
method.setAccessible(true);

// 多次使用
for (int i = 0; i < 1000; i++) {
    method.invoke(instance, args);
}
```

## 1.7 安全考虑

### 1.7.1 访问控制

```java
// 1. 安全管理器
SecurityManager security = System.getSecurityManager();
if (security != null) {
    security.checkPermission(
        new ReflectPermission("suppressAccessChecks")
    );
}

// 2. 访问控制
try {
    field.setAccessible(true);
} catch (SecurityException e) {
    // 处理访问被拒绝的情况
}
```

### 1.7.2 最佳实践

```ascii
安全建议：
┌─────────────────┐
│ 限制反射访问    │ 使用安全管理器
├─────────────────┤
│ 验证输入        │ 防止注入攻击
├─────────────────┤
│ 最小权限        │ 只开放必要访问
└─────────────────┘
```

