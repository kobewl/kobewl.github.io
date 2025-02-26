---
title: "1 Java 集合框架"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Java 集合框架

## 1.1 集合框架概述

### 1.1.1 什么是Java集合

Java集合框架是Java提供的一套用于存储和操作对象组的标准化架构。它提供了两个基本接口：

1. **Collection**：用于存储一组对象
   - 特点：单个元素的存储、访问和操作
   - 主要子接口：List、Set、Queue

2. **Map**：用于存储键值对
   - 特点：通过键来存储和访问值
   - 主要实现：HashMap、TreeMap、LinkedHashMap

**核心优势：**
- 提供了统一的API
- 减少编程工作量
- 提高程序性能
- 提供了多种实现方式

**主要接口说明：**

1. **List**：有序集合
   - 特点：元素可重复、有序、可通过索引访问
   - 场景：适合存储和访问有序数据

2. **Set**：不重复集合
   - 特点：元素不可重复、无序（部分实现有序）
   - 场景：适合去重和集合运算

3. **Queue/Deque**：队列集合
   - 特点：支持FIFO、LIFO等特殊操作
   - 场景：适合处理任务队列、缓冲等场景

4. **Map**：键值对集合
   - 特点：键不可重复，值可重复
   - 场景：适合需要通过键快速查找值的场景

### 1.1.2 整体架构

```ascii
Collection 接口
├── List 接口
│   ├── ArrayList    - 动态数组实现
│   ├── LinkedList   - 双向链表实现
│   └── Vector      - 线程安全的动态数组
│       └── Stack   - 栈实现
│
├── Set 接口
│   ├── HashSet     - 哈希表实现
│   ├── TreeSet     - 红黑树实现
│   └── LinkedHashSet- 哈希表+链表实现
│
└── Queue 接口
    ├── PriorityQueue - 优先队列
    └── Deque 接口    - 双端队列
        ├── ArrayDeque  - 数组实现
        └── LinkedList  - 链表实现

Map 接口
├── HashMap      - 哈希表实现
├── TreeMap      - 红黑树实现
├── LinkedHashMap- 哈希表+链表实现
└── Hashtable    - 线程安全的哈希表
```

### 1.1.3 集合特点对比

| 集合类型   | 有序性 | 线程安全 | 允许重复 | 允许 null  |
| ---------- | ------ | -------- | -------- | ---------- |
| ArrayList  | 是     | 否       | 是       | 是         |
| LinkedList | 是     | 否       | 是       | 是         |
| HashSet    | 否     | 否       | 否       | 是         |
| TreeSet    | 是     | 否       | 否       | 否         |
| HashMap    | 否     | 否       | 值允许   | 键值都允许 |
| TreeMap    | 是     | 否       | 值允许   | 值允许     |

## 1.2 List 集合

^e549f5

### 1.2.1 ArrayList

^461613

#### 1.2.1.1 概念和特点

ArrayList是List接口最常用的实现类，它是一个动态数组，支持随机访问和快速迭代。

**核心特点：**
- 底层使用Object[]数组实现
- 支持动态扩容（默认1.5倍）
- 随机访问效率高（O(1)）
- 插入删除效率低（需要移动元素）
- 线程不安全

#### 1.2.1.2 扩容机制

- 默认初始容量：10
- 扩容时机：当前容量不足以容纳新元素
- 扩容大小：新容量 = 旧容量 + (旧容量 >> 1)，即1.5倍
- 扩容过程：创建新数组，复制元素

#### 1.2.1.3 适用场景

- 频繁随机访问场景
- 主要在尾部进行增删的场景
- 数据量明确的场景（可指定初始容量）

### 1.2.2 LinkedList

^cb1ba7

#### 1.2.2.1 概念和特点

LinkedList是基于双向链表实现的List接口，每个元素都有前驱和后继指针。

**核心特点：**
- 底层使用双向链表实现
- 不支持随机访问（需要遍历）
- 插入删除效率高（O(1)）
- 占用空间较大（需要存储前后指针）
- 线程不安全

#### 1.2.2.2 实现原理

```java
private static class Node<E> {
    E item;           // 元素值
    Node<E> next;     // 后继节点
    Node<E> prev;     // 前驱节点
}
```

#### 1.2.2.3 适用场景

- 频繁在任意位置进行增删的场景
- 需要从两端操作的场景（队列、栈）
- 不需要随机访问的场景

#### 1.2.2.4 ArrayList与LinkedList对比

| 特性 | ArrayList | LinkedList |
|------|-----------|------------|
| 底层实现 | 动态数组 | 双向链表 |
| 随机访问 | O(1) | O(n) |
| 插入删除 | O(n) | O(1) |
| 内存占用 | 少 | 较多 |
| 适用场景 | 随机访问、尾部操作 | 任意位置增删、双端操作 |

```java
// 创建 ArrayList
ArrayList<String> list = new ArrayList<>();

// 添加元素
list.add("Apple");
list.add("Banana");
list.add(1, "Orange");  // 在指定位置插入

// 访问元素
String first = list.get(0);  // 获取第一个元素
list.set(1, "Grape");       // 修改元素

// 删除元素
list.remove(0);             // 按索引删除
list.remove("Banana");      // 按对象删除

// 遍历
for (String fruit : list) {
    System.out.println(fruit);
}
```

### 1.2.3 Vector

^4c46fc

#### 1.2.3.1 概念和特点

Vector是List接口的早期实现类，是一个线程安全的动态数组。

**核心特点：**
- 底层使用Object[]数组实现
- 所有方法都是同步的（synchronized）
- 支持动态扩容（默认2倍）
- 随机访问效率高（O(1)）
- 线程安全但性能较低

#### 1.2.3.2 扩容机制

- 默认初始容量：10
- 扩容时机：当前容量不足以容纳新元素
- 扩容大小：新容量 = 旧容量 * 2（可通过capacityIncrement指定增量）
- 扩容过程：创建新数组，复制元素

#### 1.2.3.3 Vector与ArrayList对比

| 特性 | Vector | ArrayList |
|------|---------|------------|
| 线程安全 | 是（synchronized） | 否 |
| 扩容机制 | 2倍 | 1.5倍 |
| 性能 | 较低（同步开销） | 较高 |
| 适用场景 | 多线程环境 | 单线程环境 |

```java
// 创建Vector
Vector<String> vector = new Vector<>();

// 添加元素
vector.add("Apple");
vector.add("Banana");
vector.add(1, "Orange");  // 在指定位置插入

// 访问元素
String first = vector.get(0);
vector.set(1, "Grape");   // 修改元素

// 删除元素
vector.remove(0);         // 按索引删除
vector.remove("Banana"); // 按对象删除

// 遍历
for (String fruit : vector) {
    System.out.println(fruit);
}
```

#### 1.2.3.4 不推荐使用的原因

1. **性能问题**
   - 同步策略简单粗暴（方法级同步）
   - 读写都需要加锁，性能开销大
   - 并发性能较差

2. **替代方案**
   - ArrayList + Collections.synchronizedList()
   - CopyOnWriteArrayList
   - 并发集合类

3. **设计缺陷**
   - 同步粒度过大
   - 扩容机制效率较低
   - API设计不够优雅

### 1.2.4 LinkedList

```java
// 创建 LinkedList
LinkedList<String> linkedList = new LinkedList<>();

// 特有方法
linkedList.addFirst("First");   // 添加到开头
linkedList.addLast("Last");     // 添加到结尾
String first = linkedList.getFirst();  // 获取第一个
String last = linkedList.getLast();    // 获取最后一个
```

## 1.3 Set 集合

^baddb9

### 1.3.1 HashSet

^29663c

#### 1.3.1.1 概念和特点

HashSet是Set接口的主要实现类，基于HashMap实现，不允许重复元素。

**核心特点：**
- 底层使用HashMap实现（value都是同一个Object对象）
- 不保证元素的顺序
- 允许使用null元素
- 非线程安全
- 查找效率高（O(1)）

#### 1.3.1.2 去重原理

- 使用hashCode()和equals()方法保证元素唯一
- 添加元素时先判断hashCode是否相等
- 如果hashCode相等，再判断equals是否为true

#### 1.3.1.3 适用场景

- 需要去重的场景
- 不关心元素顺序的场景
- 需要快速判断元素是否存在的场景

### 1.3.2 TreeSet

^9934ba

#### 1.3.2.1 概念和特点

红黑树[[红黑树]]是一种自平衡的二叉搜索树，**它通过节点的颜色来维持树的平衡**。TreeSet和TreeMap都是基于红黑树实现的。

**红黑树的特性：**
- 每个节点要么是红色，要么是黑色
- 根节点必须是黑色
- 叶子节点（NIL）是黑色
- 红色节点的子节点必须是黑色（不能有连续的红色节点）
- 从根到叶子的所有路径都包含相同数量的黑色节点

**核心操作：**
1. 旋转操作
   - 左旋：将节点的右子树变为该节点的父节点
   - 右旋：将节点的左子树变为该节点的父节点

2. 变色操作
   - 在插入和删除时通过改变节点颜色维持平衡
   - 用于保证红黑树的五个特性

**平衡维护：**
```java
// 左旋示例
private void leftRotate(Node<K,V> x) {
    Node<K,V> y = x.right;
    x.right = y.left;
    if (y.left != null)
        y.left.parent = x;
    y.parent = x.parent;
    if (x.parent == null)
        root = y;
    else if (x == x.parent.left)
        x.parent.left = y;
    else
        x.parent.right = y;
    y.left = x;
    x.parent = y;
}
```

**性能分析：**
- 查找、插入、删除操作的时间复杂度都是O(log n)
- 自平衡特性保证了最坏情况下的性能
- 相比AVL树，红黑树的插入和删除操作需要更少的旋转

**应用优势：**
- 有序性：保证了元素的有序遍历
- 平衡性：防止树退化为链表
- 效率：主要操作都具有对数级别的时间复杂度

#### 1.3.2.2 排序方式

- 自然排序：元素需实现Comparable接口
- 定制排序：创建TreeSet时传入Comparator

#### 1.3.2.3 适用场景

- 需要去重且要保持元素有序的场景
- 需要按照自定义规则排序的场景
- 需要范围查询的场景

#### 1.3.2.4 HashSet与TreeSet对比

| 特性 | HashSet | TreeSet |
|------|---------|----------|
| 底层实现 | HashMap | 红黑树 |
| 有序性 | 无序 | 有序 |
| 性能 | 常数时间O(1) | 对数时间O(log n) |
| null值 | 允许 | 不允许 |
| 适用场景 | 快速查找、无序去重 | 有序去重、范围查询 |

```java
// 创建 HashSet
HashSet<Integer> numbers = new HashSet<>();

// 添加元素
numbers.add(1);
numbers.add(2);
numbers.add(1);  // 重复元素不会被添加

// 检查元素
boolean contains = numbers.contains(1);  // true

// 删除元素
numbers.remove(1);
```

### 1.3.3 TreeSet

```java
// 创建 TreeSet
TreeSet<String> treeSet = new TreeSet<>();

// 添加元素（自动排序）
treeSet.add("C");
treeSet.add("A");
treeSet.add("B");

// 特有方法
String first = treeSet.first();  // 获取第一个元素
String last = treeSet.last();    // 获取最后一个元素
```

## 1.4 Map 集合

^397b75

### 1.4.1 HashMap

^b56e93

#### 1.4.1.1 概念和特点

HashMap是Map接口最常用的实现类，它是一个基于哈希表的键值对集合。

**核心特点：**
- 非线程安全
- 允许null键和null值
- 不保证元素的有序性
- 查找效率高（理想情况O(1)）

#### 1.4.1.2 底层数据结构

**1. 基本组成**
- 数组（哈希桶）：存储Node节点的数组，也称为哈希表
- 链表（解决哈希冲突）：当发生哈希冲突时，将冲突的节点以链表形式存储
- 红黑树（优化链表查询）：当链表长度超过阈值时，转换为红黑树提高查询效率

**2. 数据结构演进**
- JDK 1.7：数组 + 链表（头插法，存在并发死循环问题）
- JDK 1.8：数组 + 链表 + 红黑树（尾插法，引入红黑树优化）

```java
// Node节点定义
static class Node<K,V> implements Map.Entry<K,V> {
    final int hash;    // 哈希值
    final K key;       // 键
    V value;           // 值
    Node<K,V> next;    // 下一个节点
}

// 红黑树节点定义
static final class TreeNode<K,V> extends LinkedHashMap.Entry<K,V> {
    TreeNode<K,V> parent;  // 父节点
    TreeNode<K,V> left;    // 左子节点
    TreeNode<K,V> right;   // 右子节点
    TreeNode<K,V> prev;    // 删除时需要的前驱节点
    boolean red;           // 节点颜色
}
```

**3. 重要参数**
- 初始容量：16（必须是2的幂）
- 负载因子：0.75（默认值，可以在构造时指定）
- 树化阈值：8（链表长度超过8转红黑树）
- 树退化阈值：6（红黑树节点数小于6转链表）
- 最小树化容量：64（数组容量大于64才会发生树化）

#### 1.4.1.3 核心操作原理

**1. put操作流程**
```java
// 简化的put流程
public V put(K key, V value) {
    // 1. 计算hash值
    int hash = hash(key);
    
    // 2. 计算数组索引
    int index = (n - 1) & hash;  // n为数组长度
    
    // 3. 插入或更新节点
    if (table[index] == null) {
        // 空桶，直接插入
        table[index] = newNode(hash, key, value, null);
    } else {
        // 发生hash冲突，遍历链表或红黑树
        // 如果key存在，更新value
        // 如果key不存在，插入新节点
        // 如果链表长度超过8，考虑树化
    }
    
    // 4. 判断是否需要扩容
    if (++size > threshold) {
        resize();
    }
}
```

**2. get操作流程**
- 计算key的hash值
- 定位到数组索引位置
- 判断是链表还是红黑树
- 查找对应的节点

**3. resize扩容机制**
- 触发条件：size > threshold
- 新容量：oldCap << 1（扩大为原来的2倍）
- 数据迁移：rehash，重新计算每个节点的位置
- 优化：节点在新数组的位置只可能是原位置或原位置+oldCap

#### 1.4.1.4 性能优化建议

**1. 初始容量设置**
```java
// 预估大小/负载因子，避免频繁扩容
HashMap<String, Object> map = new HashMap<>(32);
```

**2. 影响性能的因素**
- 初始容量太小：导致频繁扩容
- 负载因子设置不当：过大导致哈希冲突增加，过小导致空间浪费
- 哈希冲突过多：导致链表过长或频繁树化

**3. 最佳实践**
- 合理设置初始容量，避免扩容
- 使用不可变对象作为key
- 重写key的hashCode()和equals()方法
- 考虑并发场景下使用ConcurrentHashMap

#### 1.4.1.5 常见问题

**1. 为什么容量必须是2的幂？**
- 计算索引时使用位运算：(n-1) & hash
- 2的幂-1的二进制全是1，可以充分散列
- 提高计算效率，位运算比取模快

**2. 为什么使用红黑树而不是AVL树？**
- 红黑树的插入/删除性能更好
- AVL树要求更严格的平衡，调整次数更多
- 实际应用中，查询性能差异不大

**3. 为什么负载因子默认是0.75？**
- 在时间和空间成本上的权衡
- 建议值在0.6-0.75之间
- 0.75能较好平衡查询成本和空间成本

### 1.4.2 Hashtable

^d5953d

#### 1.4.2.1 概念和特点

Hashtable是Java早期提供的一个线程安全的哈希表实现，实现了Map接口。

**核心特点：**
- 线程安全（所有方法都使用synchronized同步）
- 不允许null键和null值
- 不保证元素的有序性
- 查找效率高（理想情况O(1)）
- 性能相对较低（同步开销）

#### 1.4.2.2 底层实现原理

**1. 数据结构**
```java
// Hashtable的Entry结构
private static class Entry<K,V> implements Map.Entry<K,V> {
    final int hash;    // 哈希值
    final K key;       // 键
    V value;           // 值
    Entry<K,V> next;   // 下一个节点
}
```

**2. 重要特性**
- 初始容量：11（默认值）
- 负载因子：0.75（默认值）
- 扩容倍数：2n+1（与HashMap的2^n不同）
- 哈希冲突：采用链地址法解决

#### 1.4.2.3 线程安全机制

**1. 同步实现**
```java
// 典型的同步方法实现
public synchronized V put(K key, V value) {
    // 不允许null值
    if (value == null) {
        throw new NullPointerException();
    }
    // ... 实现逻辑
}

public synchronized V get(Object key) {
    Entry<?,?> tab[] = table;
    int hash = key.hashCode();
    int index = (hash & 0x7FFFFFFF) % tab.length;
    // ... 实现逻辑
}
```

**2. 同步特点**
- 方法级同步，粒度较大
- 读写都需要获取对象锁
- 并发性能较差

#### 1.4.2.4 HashMap与Hashtable对比

| 特性    | HashMap     | Hashtable       |
| ----- | ----------- | --------------- |
| 线程安全  | 否           | 是（synchronized） |
| null值 | 允许          | 不允许             |
| 性能    | 较高          | 较低（同步开销）        |
| 初始容量  | 16          | 11              |
| 扩容机制  | 2^n         | 2n+1            |
| 继承关系  | AbstractMap | Dictionary      |

#### 1.4.2.5 使用示例

```java
// 创建Hashtable
Hashtable<String, Integer> table = new Hashtable<>();

// 添加元素
table.put("A", 1);
table.put("B", 2);

// 获取元素
Integer value = table.get("A");  // 1

// 删除元素
table.remove("B");

// 检查键值
boolean containsKey = table.containsKey("A");    // true
boolean containsValue = table.containsValue(1);  // true

// 遍历
for (Map.Entry<String, Integer> entry : table.entrySet()) {
    System.out.println(entry.getKey() + ": " + entry.getValue());
}
```

#### 1.4.2.6 不推荐使用的原因

1. **性能问题**
   - 同步策略粗粒度
   - 读写都需要获取锁
   - 并发效率低下

2. **替代方案**
   - ConcurrentHashMap（推荐）
   - Collections.synchronizedMap()
   - HashMap + 自定义同步

3. **设计缺陷**
   - 不支持null键值
   - 扩容效率较低
   - API设计过时

### 1.4.3 TreeMap

^7724c6

#### 1.4.3.1 概念和特点

TreeMap是Map接口的有序实现，基于红黑树（Red-Black Tree）实现。

**核心特点：**
- 有序性：根据键的自然顺序或定制比较器排序
- 非线程安全
- 不允许null键（但允许null值）
- 查找效率为O(log n)

#### 1.4.3.2 底层实现原理

**1. 数据结构**
```java
// TreeMap的节点结构
private static final class Entry<K,V> implements Map.Entry<K,V> {
    K key;
    V value;
    Entry<K,V> left;    // 左子节点
    Entry<K,V> right;   // 右子节点
    Entry<K,V> parent;  // 父节点
    boolean color;      // 节点颜色
}
```

**2. 重要特性**
- 基于红黑树实现，保证了增删改查的平衡性
- 所有节点都遵循二叉搜索树的特性
- 通过节点颜色的变换保持树的平衡

#### 1.4.3.3 核心操作

**1. 基本操作示例**
```java
// 创建TreeMap（自然排序）
TreeMap<Integer, String> treeMap = new TreeMap<>();

// 创建TreeMap（定制排序）
TreeMap<String, Integer> customMap = new TreeMap<>((s1, s2) -> 
    s2.compareTo(s1)); // 反序排列

// 添加元素
treeMap.put(3, "Three");
treeMap.put(1, "One");
treeMap.put(2, "Two");

// 获取元素
String value = treeMap.get(1);    // "One"

// 特有的导航方法
Map.Entry<Integer, String> firstEntry = treeMap.firstEntry(); // 最小键值对
Map.Entry<Integer, String> lastEntry = treeMap.lastEntry();   // 最大键值对
Integer lowerKey = treeMap.lowerKey(2);   // 小于2的最大键
Integer higherKey = treeMap.higherKey(2); // 大于2的最小键
```

**2. 范围操作**
```java
// 获取子Map
SortedMap<Integer, String> subMap = treeMap.subMap(1, 3); // [1,3)范围的映射

// 获取头部Map
SortedMap<Integer, String> headMap = treeMap.headMap(2); // 小于2的映射

// 获取尾部Map
SortedMap<Integer, String> tailMap = treeMap.tailMap(2); // 大于等于2的映射
```

#### 1.4.3.4 性能分析

**1. 时间复杂度**
- 查找：O(log n)
- 插入：O(log n)
- 删除：O(log n)
- 遍历：O(n)

**2. 空间复杂度**
- O(n)，每个节点需要存储额外的颜色信息和指针

#### 1.4.3.5 TreeMap与HashMap对比

| 特性 | TreeMap | HashMap |
|------|---------|----------|
| 数据结构 | 红黑树 | 哈希表+链表+红黑树 |
| 有序性 | 有序 | 无序 |
| 性能 | O(log n) | O(1)平均 |
| null键 | 不支持 | 支持 |
| 内存占用 | 较大 | 较小 |
| 使用场景 | 需要排序 | 快速查找 |

#### 1.4.3.6 适用场景

1. **需要有序性的场景**
   - 按键排序的需求
   - 范围查询的需求
   - 获取最大最小键的需求

2. **特定业务场景**
   - 排行榜系统
   - 有序的字典或词典
   - 区间数据的管理

3. **最佳实践建议**
   - 需要排序时优先使用TreeMap
   - 大量随机访问时使用HashMap
   - 确保键类实现了Comparable接口或提供Comparator

### 1.4.4 LinkedHashMap

#### 1.4.4.1 概念和特点

ConcurrentHashMap是线程安全的HashMap实现，专门用于多线程环境。

**核心特点：**
- 线程安全，支持高并发
- 读操作无锁，写操作使用CAS和synchronized
- 不允许null键和null值
- 分段锁设计（JDK 1.7）或CAS+synchronized（JDK 1.8）

#### 1.4.4.2 底层实现原理

**1. JDK 1.8的实现**
- 取消了分段锁设计
- 使用CAS+synchronized实现并发控制
- 与HashMap一样采用数组+链表+红黑树的存储结构

**2. 并发控制机制**
```java
// Node节点定义
static class Node<K,V> implements Map.Entry<K,V> {
    final int hash;
    final K key;
    volatile V value;    // volatile保证可见性
    volatile Node<K,V> next;  // volatile保证可见性
}
```

**3. 重要参数**
- sizeCtl：控制初始化和扩容操作
- 树化阈值：8（与HashMap相同）
- 最小树化容量：64（与HashMap相同）

#### 1.4.4.3 ConcurrentHashMap与HashMap对比

^6b2e0e

| 特性    | ConcurrentHashMap | HashMap |
| ----- | ----------------- | ------- |
| 线程安全  | 是                 | 否       |
| 锁机制   | CAS+synchronized  | 无       |
| null值 | 不支持               | 支持      |
| 性能    | 并发环境高             | 单线程环境高  |
| 使用场景  | 多线程环境             | 单线程环境   |

**主要区别：**
1. **线程安全性**
   - ConcurrentHashMap：线程安全，适合多线程环境
   - HashMap：非线程安全，适合单线程环境

2. **实现机制**
   - ConcurrentHashMap：使用CAS和synchronized保证并发安全
   - HashMap：无并发控制机制

3. **性能特点**
   - ConcurrentHashMap：
     - 读操作无锁，性能高
     - 写操作使用CAS+synchronized，保证安全
   - HashMap：
     - 单线程下性能最优
     - 多线程下需要外部同步

4. **应用场景**
   - ConcurrentHashMap：
     - 高并发的缓存系统
     - 共享数据的线程安全访问
   - HashMap：
     - 单线程环境数据存储
     - 临时数据的快速存取

```java
// ConcurrentHashMap使用示例
ConcurrentHashMap<String, Integer> concurrentMap = new ConcurrentHashMap<>();

// 线程安全的操作
concurrentMap.put("key", 1);
concurrentMap.get("key");

// 原子操作
concurrentMap.putIfAbsent("key", 2);  // 不存在才插入
concurrentMap.replace("key", 1, 2);   // 更新已存在的值
```

### 1.4.5 Vector

^4c46fc

#### 1.4.5.1 概念和特点

Vector是List接口的早期实现类，是一个线程安全的动态数组。

**核心特点：**
- 底层使用Object[]数组实现
- 所有方法都是同步的（synchronized）
- 支持动态扩容（默认2倍）
- 随机访问效率高（O(1)）
- 线程安全但性能较低

#### 1.4.5.2 扩容机制

- 默认初始容量：10
- 扩容时机：当前容量不足以容纳新元素
- 扩容大小：新容量 = 旧容量 * 2（可通过capacityIncrement指定增量）
- 扩容过程：创建新数组，复制元素

#### 1.4.5.3 Vector与ArrayList对比

| 特性 | Vector | ArrayList |
|------|---------|------------|
| 线程安全 | 是（synchronized） | 否 |
| 扩容机制 | 2倍 | 1.5倍 |
| 性能 | 较低（同步开销） | 较高 |
| 适用场景 | 多线程环境 | 单线程环境 |

```java
// 创建Vector
Vector<String> vector = new Vector<>();

// 添加元素
vector.add("Apple");
vector.add("Banana");
vector.add(1, "Orange");  // 在指定位置插入

// 访问元素
String first = vector.get(0);
vector.set(1, "Grape");   // 修改元素

// 删除元素
vector.remove(0);         // 按索引删除
vector.remove("Banana"); // 按对象删除

// 遍历
for (String fruit : vector) {
    System.out.println(fruit);
}
```

#### 1.4.5.4 不推荐使用的原因

1. **性能问题**
   - 同步策略简单粗暴（方法级同步）
   - 读写都需要加锁，性能开销大
   - 并发性能较差

2. **替代方案**
   - ArrayList + Collections.synchronizedList()
   - CopyOnWriteArrayList
   - 并发集合类

3. **设计缺陷**
   - 同步粒度过大
   - 扩容机制效率较低
   - API设计不够优雅

### 1.4.6 LinkedList

```java
// 创建 LinkedList
LinkedList<String> linkedList = new LinkedList<>();

// 特有方法
linkedList.addFirst("First");   // 添加到开头
linkedList.addLast("Last");     // 添加到结尾
String first = linkedList.getFirst();  // 获取第一个
String last = linkedList.getLast();    // 获取最后一个
```

## 1.5 Set 集合

^baddb9

### 1.5.1 HashSet

^29663c

#### 1.5.1.1 概念和特点

HashSet是Set接口的主要实现类，基于HashMap实现，不允许重复元素。

**核心特点：**
- 底层使用HashMap实现（value都是同一个Object对象）
- 不保证元素的顺序
- 允许使用null元素
- 非线程安全
- 查找效率高（O(1)）

#### 1.5.1.2 去重原理

- 使用hashCode()和equals()方法保证元素唯一
- 添加元素时先判断hashCode是否相等
- 如果hashCode相等，再判断equals是否为true

#### 1.5.1.3 适用场景

- 需要去重的场景
- 不关心元素顺序的场景
- 需要快速判断元素是否存在的场景

### 1.5.2 TreeSet

^9934ba

#### 1.5.2.1 概念和特点

红黑树[[红黑树]]是一种自平衡的二叉搜索树，**它通过节点的颜色来维持树的平衡**。TreeSet和TreeMap都是基于红黑树实现的。

**红黑树的特性：**
- 每个节点要么是红色，要么是黑色
- 根节点必须是黑色
- 叶子节点（NIL）是黑色
- 红色节点的子节点必须是黑色（不能有连续的红色节点）
- 从根到叶子的所有路径都包含相同数量的黑色节点

**核心操作：**
1. 旋转操作
   - 左旋：将节点的右子树变为该节点的父节点
   - 右旋：将节点的左子树变为该节点的父节点

2. 变色操作
   - 在插入和删除时通过改变节点颜色维持平衡
   - 用于保证红黑树的五个特性

**平衡维护：**
```java
// 左旋示例
private void leftRotate(Node<K,V> x) {
    Node<K,V> y = x.right;
    x.right = y.left;
    if (y.left != null)
        y.left.parent = x;
    y.parent = x.parent;
    if (x.parent == null)
        root = y;
    else if (x == x.parent.left)
        x.parent.left = y;
    else
        x.parent.right = y;
    y.left = x;
    x.parent = y;
}
```

**性能分析：**
- 查找、插入、删除操作的时间复杂度都是O(log n)
- 自平衡特性保证了最坏情况下的性能
- 相比AVL树，红黑树的插入和删除操作需要更少的旋转

**应用优势：**
- 有序性：保证了元素的有序遍历
- 平衡性：防止树退化为链表
- 效率：主要操作都具有对数级别的时间复杂度

#### 1.5.2.2 排序方式

- 自然排序：元素需实现Comparable接口
- 定制排序：创建TreeSet时传入Comparator

#### 1.5.2.3 适用场景

- 需要去重且要保持元素有序的场景
- 需要按照自定义规则排序的场景
- 需要范围查询的场景

#### 1.5.2.4 HashSet与TreeSet对比

| 特性 | HashSet | TreeSet |
|------|---------|----------|
| 底层实现 | HashMap | 红黑树 |
| 有序性 | 无序 | 有序 |
| 性能 | 常数时间O(1) | 对数时间O(log n) |
| null值 | 允许 | 不允许 |
| 适用场景 | 快速查找、无序去重 | 有序去重、范围查询 |

```java
// 创建 HashSet
HashSet<Integer> numbers = new HashSet<>();

// 添加元素
numbers.add(1);
numbers.add(2);
numbers.add(1);  // 重复元素不会被添加

// 检查元素
boolean contains = numbers.contains(1);  // true

// 删除元素
numbers.remove(1);
```

### 1.5.3 TreeSet

```java
// 创建 TreeSet
TreeSet<String> treeSet = new TreeSet<>();

// 添加元素（自动排序）
treeSet.add("C");
treeSet.add("A");
treeSet.add("B");

// 特有方法
String first = treeSet.first();  // 获取第一个元素
String last = treeSet.last();    // 获取最后一个元素
```

## 1.6 Map 集合

^397b75

### 1.6.1 HashMap

^b56e93

#### 1.6.1.1 概念和特点

HashMap是Map接口最常用的实现类，它是一个基于哈希表的键值对集合。

**核心特点：**
- 非线程安全
- 允许null键和null值
- 不保证元素的有序性
- 查找效率高（理想情况O(1)）

#### 1.6.1.2 底层数据结构

**1. 基本组成**
- 数组（哈希桶）：存储Node节点的数组，也称为哈希表
- 链表（解决哈希冲突）：当发生哈希冲突时，将冲突的节点以链表形式存储
- 红黑树（优化链表查询）：当链表长度超过阈值时，转换为红黑树提高查询效率

**2. 数据结构演进**
- JDK 1.7：数组 + 链表（头插法，存在并发死循环问题）
- JDK 1.8：数组 + 链表 + 红黑树（尾插法，引入红黑树优化）

```java
// Node节点定义
static class Node<K,V> implements Map.Entry<K,V> {
    final int hash;    // 哈希值
    final K key;       // 键
    V value;           // 值
    Node<K,V> next;    // 下一个节点
}

// 红黑树节点定义
static final class TreeNode<K,V> extends LinkedHashMap.Entry<K,V> {
    TreeNode<K,V> parent;  // 父节点
    TreeNode<K,V> left;    // 左子节点
    TreeNode<K,V> right;   // 右子节点
    TreeNode<K,V> prev;    // 删除时需要的前驱节点
    boolean red;           // 节点颜色
}
```

**3. 重要参数**
- 初始容量：16（必须是2的幂）
- 负载因子：0.75（默认值，可以在构造时指定）
- 树化阈值：8（链表长度超过8转红黑树）
- 树退化阈值：6（红黑树节点数小于6转链表）
- 最小树化容量：64（数组容量大于64才会发生树化）

#### 1.6.1.3 核心操作原理

**1. put操作流程**
```java
// 简化的put流程
public V put(K key, V value) {
    // 1. 计算hash值
    int hash = hash(key);
    
    // 2. 计算数组索引
    int index = (n - 1) & hash;  // n为数组长度
    
    // 3. 插入或更新节点
    if (table[index] == null) {
        // 空桶，直接插入
        table[index] = newNode(hash, key, value, null);
    } else {
        // 发生hash冲突，遍历链表或红黑树
        // 如果key存在，更新value
        // 如果key不存在，插入新节点
        // 如果链表长度超过8，考虑树化
    }
    
    // 4. 判断是否需要扩容
    if (++size > threshold) {
        resize();
    }
}
```

**2. get操作流程**
- 计算key的hash值
- 定位到数组索引位置
- 判断是链表还是红黑树
- 查找对应的节点

**3. resize扩容机制**
- 触发条件：size > threshold
- 新容量：oldCap << 1（扩大为原来的2倍）
- 数据迁移：rehash，重新计算每个节点的位置
- 优化：节点在新数组的位置只可能是原位置或原位置+oldCap

#### 1.6.1.4 性能优化建议

**1. 初始容量设置**
```java
// 预估大小/负载因子，避免频繁扩容
HashMap<String, Object> map = new HashMap<>(32);
```

**2. 影响性能的因素**
- 初始容量太小：导致频繁扩容
- 负载因子设置不当：过大导致哈希冲突增加，过小导致空间浪费
- 哈希冲突过多：导致链表过长或频繁树化

**3. 最佳实践**
- 合理设置初始容量，避免扩容
- 使用不可变对象作为key
- 重写key的hashCode()和equals()方法
- 考虑并发场景下使用ConcurrentHashMap

#### 1.6.1.5 常见问题

**1. 为什么容量必须是2的幂？**
- 计算索引时使用位运算：(n-1) & hash
- 2的幂-1的二进制全是1，可以充分散列
- 提高计算效率，位运算比取模快

**2. 为什么使用红黑树而不是AVL树？**
- 红黑树的插入/删除性能更好
- AVL树要求更严格的平衡，调整次数更多
- 实际应用中，查询性能差异不大

**3. 为什么负载因子默认是0.75？**
- 在时间和空间成本上的权衡
- 建议值在0.6-0.75之间
- 0.75能较好平衡查询成本和空间成本

### 1.6.2 LinkedHashMap

#### 1.6.2.1 概念和特点

LinkedHashMap是HashMap的子类，它在HashMap的基础上维护了一个双向链表，用于保持插入顺序或访问顺序。

**核心特点：**
- 继承自HashMap，具有HashMap的所有特性
- 维护了一个双向链表，保证了迭代顺序
- 支持两种顺序：插入顺序（默认）和访问顺序
- 适合实现LRU缓存

#### 1.6.2.2 实现原理

```java
// Entry节点定义
static class Entry<K,V> extends HashMap.Node<K,V> {
    Entry<K,V> before, after; // 用于维护双向链表
    Entry(int hash, K key, V value, Node<K,V> next) {
        super(hash, key, value, next);
    }
}
```

#### 1.6.2.3 两种顺序模式

1. **插入顺序（默认）**
   - 维护元素的插入顺序
   - 适合需要记住插入顺序的场景

2. **访问顺序**
   - 每次访问元素后，将其移动到链表末尾
   - 适合实现LRU缓存

```java
// 创建一个访问顺序的LinkedHashMap
LinkedHashMap<String, Integer> map = new LinkedHashMap<>(16, 0.75f, true);
```

#### 1.6.2.4 LRU缓存实现

```java
public class LRUCache<K,V> extends LinkedHashMap<K,V> {
    private final int capacity;
    
    public LRUCache(int capacity) {
        super(capacity, 0.75f, true);
        this.capacity = capacity;
    }
    
    @Override
    protected boolean removeEldestEntry(Map.Entry<K,V> eldest) {
        return size() > capacity;
    }
}
```

## 1.7 Queue和Stack

### 1.7.1 Queue接口

#### 1.7.1.1 PriorityQueue

**概念和特点：**
- 基于优先堆的无界优先队列
- 默认自然顺序排序（小顶堆）
- 可以通过Comparator自定义排序
- 不允许null元素

```java
// 创建PriorityQueue
PriorityQueue<Integer> pq = new PriorityQueue<>();

// 添加元素
pq.offer(3);
pq.offer(1);
pq.offer(2);

// 获取堆顶元素
int top = pq.peek();  // 1

// 删除堆顶元素
int removed = pq.poll();  // 1
```

#### 1.7.1.2 Deque接口

**概念和特点：**
- 双端队列，支持两端插入和删除
- 可以用作栈或队列
- 主要实现类：ArrayDeque、LinkedList

**ArrayDeque特点：**
- 基于循环数组实现
- 作为栈比Stack性能好
- 作为队列比LinkedList性能好
- 不允许null元素

```java
// 作为栈使用
Deque<String> stack = new ArrayDeque<>();
stack.push("First");      // 压栈
stack.pop();              // 出栈

// 作为队列使用
Deque<String> queue = new ArrayDeque<>();
queue.offer("First");     // 入队
queue.poll();             // 出队
```

### 1.7.2 Stack类

**概念和特点：**
- Vector的子类，实现了LIFO栈
- 线程安全（继承自Vector）
- 性能较差（推荐使用ArrayDeque）
- 所有方法都是同步的

```java
// 创建Stack
Stack<String> stack = new Stack<>();

// 压栈
stack.push("First");
stack.push("Second");

// 查看栈顶
String top = stack.peek();

// 出栈
String popped = stack.pop();

// 检查栈是否为空
boolean empty = stack.empty();
```

### 1.7.3 LinkedHashSet

^e72186

**概念和特点：**
- HashSet的子类，具有HashSet的特性
- 维护了一个双向链表，保证了迭代顺序
- 性能略低于HashSet，但迭代速度更快
- 适合需要去重且保持插入顺序的场景

```java
// 创建LinkedHashSet
LinkedHashSet<String> set = new LinkedHashSet<>();

// 添加元素
set.add("First");
set.add("Second");
set.add("First");  // 重复元素不会被添加

// 遍历（保持插入顺序）
for (String element : set) {
    System.out.println(element);
}
```

