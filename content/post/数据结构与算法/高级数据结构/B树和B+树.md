---
title: "1 B 树和 B+树"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 B 树和 B+树

## 1.1 B 树 (B-Tree)

### 1.1.1 基本概念

- m 阶 B 树是一种平衡的多路搜索树
- 每个节点最多有 m 个子节点
- 除根节点和叶节点外，每个节点至少有⌈m/2⌉个子节点
- 所有叶节点都在同一层

```mermaid
graph TD
    A["根节点 (35,65)"] --> B["节点 (15,25)"];
    A --> C["节点 (45,55)"];
    A --> D["节点 (75,85)"];
    B --> E["叶节点 (10,12)"];
    B --> F["叶节点 (17,20)"];
    B --> G["叶节点 (27,30)"]; 
    C --> H["叶节点 (40,42)"];
    C --> I["叶节点 (47,50)"];
    C --> J["叶节点 (57,60)"]; 
    D --> K["叶节点 (70,72)"];
    D --> L["叶节点 (77,80)"];
    D --> M["叶节点 (87,90)"]; 

    style A fill:#f9f,stroke:#333,stroke-width:2px
    style B fill:#bbf,stroke:#333,stroke-width:2px
    style C fill:#bbf,stroke:#333,stroke-width:2px
    style D fill:#bbf,stroke:#333,stroke-width:2px
    style E fill:#dfd,stroke:#333,stroke-width:2px
    style F fill:#dfd,stroke:#333,stroke-width:2px
    style G fill:#dfd,stroke:#333,stroke-width:2px
    style H fill:#dfd,stroke:#333,stroke-width:2px
    style I fill:#dfd,stroke:#333,stroke-width:2px
    style J fill:#dfd,stroke:#333,stroke-width:2px
    style K fill:#dfd,stroke:#333,stroke-width:2px
    style L fill:#dfd,stroke:#333,stroke-width:2px
    style M fill:#dfd,stroke:#333,stroke-width:2px
```

### 1.1.2 性质

1. **节点特征**

   - 所有节点的数据有序
   - 节点中的关键字互不相同
   - 节点的子树数比关键字数多 1

2. **平衡特性**
   - 所有叶节点具有相同的深度
   - 插入和删除操作自动保持平衡

### 1.1.3 节点结构

```java
public class BTreeNode<K extends Comparable<K>, V> {
    private int m;                  // B树的阶数
    private Entry<K,V>[] entries;   // 键值对数组
    private BTreeNode<K,V>[] children; // 子节点数组
    private int size;              // 当前节点中的键值对数量
    private boolean isLeaf;        // 是否是叶子节点

    static class Entry<K,V> {
        K key;
        V value;
        Entry(K key, V value) {
            this.key = key;
            this.value = value;
        }
    }
}
```

## 1.2 B+树

### 1.2.1 基本概念

- B+树是 B 树的变种
- 所有数据都存储在叶子节点
- 叶子节点通过链表相连
- 非叶节点只存储索引信息

```mermaid
graph TD
    A["根节点 35,65"] --> B["索引节点 15,25"];
    A --> C["索引节点 45,55"];
    B --> E["数据节点 (10:data10, 12:data12, 15:data15)"];
    B --> F["数据节点 (17:data17, 20:data20, 25:data25)"];
    B --> G["数据节点 (27:data27, 30:data30, 35:data35)"]; 
    C --> H["数据节点 (40:data40, 42:data42, 45:data45)"];
    C --> I["数据节点 (47:data47, 50:data50, 55:data55)"];
    C --> J["数据节点 (57:data57, 60:data60, 65:data65)"]; 
    
    %% 叶节点间的链表连接
    E -. "链表指针" .-> F;
    F -. "链表指针" .-> G;
    G -. "链表指针" .-> H;
    H -. "链表指针" .-> I;
    I -. "链表指针" .-> J;
    
    %% 节点样式
    style A fill:#ff9999,stroke:#333,stroke-width:4px
    style B fill:#99ccff,stroke:#333,stroke-width:3px
    style C fill:#99ccff,stroke:#333,stroke-width:3px
    style E fill:#99ff99,stroke:#333,stroke-width:2px
    style F fill:#99ff99,stroke:#333,stroke-width:2px
    style G fill:#99ff99,stroke:#333,stroke-width:2px
    style H fill:#99ff99,stroke:#333,stroke-width:2px
    style I fill:#99ff99,stroke:#333,stroke-width:2px
    style J fill:#99ff99,stroke:#333,stroke-width:2px
    
    %% 添加说明注释
    classDef note fill:#fff,stroke:#333,stroke-width:1px;
    N1["注: 根节点(红色): 只存储索引键值
索引节点(蓝色): 只存储索引键值
数据节点(绿色): 存储键值对数据"];
    class N1 note;
```

### 1.2.2 特点

1. **数据存储**

   - 只有叶节点存储数据
   - 非叶节点只存储键值
   - 叶节点包含所有键值

2. **节点结构**
   - 叶节点通过指针连接
   - 便于范围查询
   - 支持顺序访问

### 1.2.3 节点实现

```java
public class BPlusTreeNode<K extends Comparable<K>, V> {
    private boolean isLeaf;
    private BPlusTreeNode<K,V> next;     // 叶子节点的下一个节点
    private List<K> keys;                // 键列表
    private List<V> values;              // 值列表（仅叶子节点）
    private List<BPlusTreeNode<K,V>> children; // 子节点列表

    public BPlusTreeNode(boolean isLeaf) {
        this.isLeaf = isLeaf;
        this.keys = new ArrayList<>();
        if (isLeaf) {
            this.values = new ArrayList<>();
        } else {
            this.children = new ArrayList<>();
        }
    }
}
```

## 1.3 操作实现

### 1.3.1 查找操作

1. **B 树查找流程**

```mermaid
flowchart TD
    A[开始] --> B[从根节点开始]
    B --> C{是否找到关键字?}
    C -->|是| D[返回对应值]
    C -->|否| E{是否是叶节点?}
    E -->|是| F[未找到,返回null]
    E -->|否| G[在子节点中继续查找]
    G --> C
```

2. **B 树查找代码**

```java
public V search(K key) {
    return searchInNode(root, key);
}

private V searchInNode(BTreeNode<K,V> node, K key) {
    int i = 0;
    while (i < node.size && key.compareTo(node.entries[i].key) > 0) {
        i++;
    }

    if (i < node.size && key.compareTo(node.entries[i].key) == 0) {
        return node.entries[i].value;
    }

    if (node.isLeaf) {
        return null;
    }

    return searchInNode(node.children[i], key);
}
```

3. **B+树查找流程**

```mermaid
flowchart TD
    A[开始] --> B[从根节点开始]
    B --> C[找到目标叶节点]
    C --> D{在叶节点中查找关键字}
    D -->|找到| E[返回对应值]
    D -->|未找到| F[返回null]
```

4. **B+树查找代码**

```java
public V search(K key) {
    BPlusTreeNode<K,V> leaf = findLeaf(key);
    int index = Collections.binarySearch(leaf.keys, key);
    return index >= 0 ? leaf.values.get(index) : null;
}
```

### 1.3.2 插入操作

1. **节点分裂**

   - 当节点满时进行分裂
   - 中间键值向上提升
   - 保持树的平衡性

```mermaid
flowchart TD
    A[开始插入] --> B{节点是否已满?}
    B -->|否| C[直接插入新键值]
    B -->|是| D[分裂节点]
    D --> E[选择中间键值]
    E --> F[创建新节点]
    F --> G[分配键值到新旧节点]
    G --> H[中间键值上升到父节点]
    H --> I[更新节点间关系]
    C --> J[完成]
    I --> J
```

2. **具体步骤**
   - 找到插入位置
   - 插入键值对
   - 必要时分裂节点
   - 更新父节点信息

## 1.4 性能分析

### 1.4.1 时间复杂度

| 操作  | B 树      | B+树      |
| --- | -------- | -------- |
| 查找  | O(log n) | O(log n) |
| 插入  | O(log n) | O(log n) |
| 删除  | O(log n) | O(log n) |
| 范围  | O(n)     | O(k)     |

### 1.4.2 空间利用

1. **B 树**

   - 每个节点空间利用率约 50%
   - 适合随机访问

2. **B+树**
   - 叶节点紧凑存储
   - 更高的空间利用率
   - 适合顺序访问

## 1.5 应用场景

### 1.5.1 数据库应用

1. **B 树适用场景**

   - 数据量较小
   - 读写频率接近
   - 随机访问为主

2. **B+树适用场景**
   - 大型数据库
   - 索引系统
   - 文件系统

### 1.5.2 具体实例

1. **数据库索引**

   - MySQL 的 InnoDB 引擎
   - Oracle 的索引实现
   - MongoDB 的索引

2. **文件系统**
   - NTFS
   - ext4
   - HFS+

## 1.6 实现考虑

### 1.6.1 设计要点

1. **节点大小**

   - 考虑磁盘块大小
   - 平衡访问效率
   - 考虑缓存行大小

2. **分裂策略**
   - 选择分裂点
   - 处理边界情况
   - 维护平衡性

### 1.6.2 优化方向

1. **缓存优化**

   - 节点缓存
   - 预读机制
   - 批量操作

2. **并发控制**
   - 锁粒度
   - 事务支持
   - 版本控制

## 1.7 比较分析

### 1.7.1 B 树 vs B+树

1. **结构差异**

   - 数据存储位置
   - 索引节点内容
   - 叶节点连接

2. **性能特点**
   - 范围查询
   - 空间利用
   - 查询稳定性

### 1.7.2 使用选择

1. **选择 B 树**

   - 单一数据访问
   - 内存存储
   - 随机访问频繁

2. **选择 B+树**
   - 范围查询多
   - 磁盘存储
   - 顺序访问频繁

