---
title: "1 Java 8 新特性"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Java 8 新特性

## 1.1 Lambda 表达式

### 1.1.1 基本语法

```ascii
Lambda 表达式结构：
┌─────────────────────────┐
│ (参数) -> { 表达式 }    │
└─────────────────────────┘

简化形式：
1. 单参数无括号：  x -> x * x
2. 无参数空括号：  () -> 42
3. 多参数要括号：  (x, y) -> x + y
```

### 1.1.2 函数式接口

```java
// 1. 内置函数式接口
Predicate<Integer> isPositive = x -> x > 0;
Consumer<String> printer = x -> System.out.println(x);
Function<String, Integer> lengthFunc = x -> x.length();
Supplier<Double> random = () -> Math.random();

// 2. 自定义函数式接口
@FunctionalInterface
interface Calculator {
    int calculate(int x, int y);
}

Calculator add = (x, y) -> x + y;
Calculator multiply = (x, y) -> x * y;
```

## 1.2 Stream API

### 1.2.1 创建流

```java
// 1. 从集合创建
List<String> list = Arrays.asList("a", "b", "c");
Stream<String> stream1 = list.stream();

// 2. 从数组创建
String[] array = {"a", "b", "c"};
Stream<String> stream2 = Arrays.stream(array);

// 3. 使用 Stream.of
Stream<Integer> stream3 = Stream.of(1, 2, 3);

// 4. 无限流
Stream<Integer> infiniteStream = Stream.iterate(0, n -> n + 2);
```

### 1.2.2 中间操作

```ascii
Stream 操作流程：
源数据 ──→ [过滤] ──→ [转换] ──→ [排序] ──→ 结果
         filter    map     sorted   collect

┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ 原始数据    │ ──→│ 中间操作    │ ──→│ 终止操作    │
└─────────────┘    └─────────────┘    └─────────────┘
```

```java
List<String> result = list.stream()
    .filter(s -> s.length() > 3)    // 过滤
    .map(String::toUpperCase)       // 转换
    .sorted()                       // 排序
    .collect(Collectors.toList());  // 收集
```

### 1.2.3 终止操作

```java
// 1. 收集
Map<Boolean, List<Integer>> groups = numbers.stream()
    .collect(Collectors.partitioningBy(n -> n > 0));

// 2. 归约
int sum = numbers.stream()
    .reduce(0, Integer::sum);

// 3. 匹配
boolean allPositive = numbers.stream()
    .allMatch(n -> n > 0);

// 4. 查找
Optional<Integer> first = numbers.stream()
    .findFirst();
```

## 1.3 Optional 类

### 1.3.1 创建 Optional

```java
// 1. 空的 Optional
Optional<String> empty = Optional.empty();

// 2. 非空值的 Optional
Optional<String> opt = Optional.of("Hello");

// 3. 可能为空的 Optional
Optional<String> nullable = Optional.ofNullable(null);
```

### 1.3.2 使用 Optional

```java
// 1. 安全获取值
Optional<String> name = Optional.ofNullable(getName());
String result = name.orElse("Unknown");

// 2. 条件执行
name.ifPresent(System.out::println);

// 3. 转换值
Optional<Integer> length = name.map(String::length);

// 4. 链式调用
String value = Optional.ofNullable(user)
    .map(User::getAddress)
    .map(Address::getCity)
    .orElse("Unknown");
```

## 1.4 新的日期时间 API

### 1.4.1 主要类

```ascii
日期时间类关系：
┌─────────────┐
│ LocalDate   │──→ 日期（2024-01-01）
├─────────────┤
│ LocalTime   │──→ 时间（12:30:45）
├─────────────┤
│ LocalDateTime│──→ 日期时间（2024-01-01T12:30:45）
├─────────────┤
│ ZonedDateTime│──→ 带时区的日期时间
└─────────────┘
```

### 1.4.2 使用示例

```java
// 1. 创建日期时间
LocalDate date = LocalDate.now();
LocalTime time = LocalTime.now();
LocalDateTime dateTime = LocalDateTime.now();

// 2. 日期计算
LocalDate tomorrow = date.plusDays(1);
LocalDate nextMonth = date.plusMonths(1);

// 3. 日期比较
boolean isBefore = date1.isBefore(date2);
Period period = Period.between(date1, date2);

// 4. 格式化
DateTimeFormatter formatter =
    DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
String formatted = dateTime.format(formatter);
```

## 1.5 接口默认方法

### 1.5.1 默认方法

```java
interface Vehicle {
    // 默认方法
    default void start() {
        System.out.println("Vehicle starting");
    }

    // 静态方法
    static int getWheels() {
        return 4;
    }
}

class Car implements Vehicle {
    // 可以选择重写默认方法
    @Override
    public void start() {
        System.out.println("Car starting");
    }
}
```

### 1.5.2 多重继承问题

```java
interface A {
    default void foo() { System.out.println("A"); }
}

interface B {
    default void foo() { System.out.println("B"); }
}

// 必须解决冲突
class C implements A, B {
    @Override
    public void foo() {
        A.super.foo();  // 选择调用 A 的实现
    }
}
```

## 1.6 方法引用

### 1.6.1 四种类型

```ascii
方法引用类型：
┌─────────────────┐
│ 静态方法引用    │ Class::staticMethod
├─────────────────┤
│ 实例方法引用    │ object::instanceMethod
├─────────────────┤
│ 类方法引用      │ Class::instanceMethod
├─────────────────┤
│ 构造方法引用    │ Class::new
└─────────────────┘
```

### 1.6.2 使用示例

```java
// 1. 静态方法引用
Function<String, Integer> parser = Integer::parseInt;

// 2. 实例方法引用
String str = "Hello";
Supplier<Integer> lengthSupplier = str::length;

// 3. 类方法引用
Function<String, String> upper = String::toUpperCase;

// 4. 构造方法引用
Supplier<ArrayList<String>> listCreator = ArrayList::new;
```

## 1.7 并行流

### 1.7.1 创建并行流

```java
// 1. 从集合创建
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
Stream<Integer> parallelStream = numbers.parallelStream();

// 2. 将顺序流转换为并行流
Stream<Integer> parallel = numbers.stream().parallel();
```

### 1.7.2 性能考虑

```ascii
适合并行的场景：
┌─────────────────┐
│ 数据量大        │
│ 计算密集型      │
│ 元素独立        │
└─────────────────┘

不适合并行的场景：
┌─────────────────┐
│ 数据量小        │
│ IO 密集型       │
│ 元素有依赖      │
└─────────────────┘
```

