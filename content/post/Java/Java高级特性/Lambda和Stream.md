---
title: "Lambda和Stream"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---

# 1 Lambda 表达式

## 1.1 什么是 Lambda？

想象一下，Lambda 就像是一个简单的公式：输入一些东西 → 处理 → 输出结果

```ascii
传统方式 vs Lambda：

传统方式：
┌─────────────────────┐
│ public int add(int a, int b) {
│     return a + b;
│ }                   │
└─────────────────────┘

Lambda 方式：
┌─────────────┐
│ (a, b) -> a + b
└─────────────┘

更简洁，对吧？😊
```

## 1.2 Lambda 的基本写法

```ascii
Lambda 写法模板：

1. 无参数：
() -> System.out.println("Hello")
┬  ┬  ┬
│  │  └── 要做的事
│  └────── 箭头
└───────── 空参数

2. 一个参数：
name -> System.out.println(name)
┬    ┬  ┬
│    │  └── 要做的事
│    └────── 箭头
└─────────── 参数

3. 多个参数：
(a, b) -> a + b
┬     ┬  ┬
│     │  └── 要做的事
│     └────── 箭头
└──────────── 参数列表
```

## 1.3 实际例子

```java
// 1. 打印东西
Runnable printer = () -> System.out.println("Hi");  // 无参数

// 2. 检查数字
Predicate<Integer> isPositive = x -> x > 0;  // 一个参数

// 3. 计算总和
BinaryOperator<Integer> add = (a, b) -> a + b;  // 两个参数
```

# 2 Stream 流

^708003

## 2.1 什么是 Stream？

想象 Stream 就像一条生产线，数据就像产品一样在上面流动，可以经过各种处理：

```ascii
数据流水线：

原始数据 ——→ [清洗] ——→ [加工] ——→ [包装] ——→ 成品
  数组         过滤      转换      收集     结果
  集合        filter     map     collect   List

示例：
numbers ——→ [>0] ——→ [×2] ——→ [收集] ——→ 结果
 [1,-2,3]    [1,3]   [2,6]    [2,6]
```

### 2.1.1 常用 Stream 操作

```ascii
1. 过滤 (filter)：
[1, -2, 3, -4, 5] ——→ [1, 3, 5]
     保留大于0的数

2. 转换 (map)：
[1, 2, 3] ——→ [2, 4, 6]
     每个数乘以2

3. 排序 (sorted)：
[3, 1, 4] ——→ [1, 3, 4]
     从小到大排序

4. 去重 (distinct)：
[1, 2, 2, 3, 3] ——→ [1, 2, 3]
     删除重复元素
```

### 2.1.2 简单示例

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

// 1. 找出长度大于3的名字，转大写，然后排序
List<String> result = names.stream()           // 创建流
    .filter(name -> name.length() > 3)         // 过滤长名字
    .map(String::toUpperCase)                  // 转大写
    .sorted()                                  // 排序
    .collect(Collectors.toList());             // 收集结果

// 结果：[ALICE, CHARLIE]
```

### 2.1.3 实际应用场景

```ascii
1. 处理集合：
┌─────────────┐
│ 商品列表     │ ──→ [过滤价格] ──→ [排序] ──→ [前3个]
└─────────────┘

2. 文件处理：
┌─────────────┐
│ 日志文件     │ ──→ [过滤错误] ──→ [提取时间] ──→ [统计]
└─────────────┘

3. 数据统计：
┌─────────────┐
│ 订单数据     │ ──→ [按类型分组] ──→ [求和] ──→ [统计]
└─────────────┘
```

### 2.1.4 最佳实践

```ascii
✅ 推荐做法：
1. 链式操作，保持代码整洁
2. 先 filter 再 map，提高效率
3. 使用合适的终端操作

❌ 避免做法：
1. 过长的处理链
2. 重复创建流
3. 过度使用并行流
```

## 2.2 练习示例

```java
// 1. 简单的购物车示例
class Product {
    String name;
    double price;
}

List<Product> products = getProducts();

// 计算购物车中超过100元商品的总价
double total = products.stream()
    .filter(p -> p.price > 100)    // 筛选贵重商品
    .mapToDouble(p -> p.price)     // 提取价格
    .sum();                        // 求和

// 2. 统计单词出现次数
String text = "hello world hello java";
Map<String, Long> wordCount = Arrays.stream(text.split(" "))
    .collect(Collectors.groupingBy(
        word -> word,              // 按单词分组
        Collectors.counting()      // 计数
    ));
```

