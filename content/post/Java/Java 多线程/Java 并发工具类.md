---
title: "1 Java 并发工具类"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Java 并发工具类

## 1.1 并发容器基本概念

### 1.1.1 为什么需要并发容器

- 普通容器线程不安全
- 并发访问可能导致数据不一致
- 使用 synchronized 性能较差
- 并发容器提供更好的并发性能

### 1.1.2 并发容器的特点

- 线程安全：保证并发访问的正确性
- 高性能：使用锁分段等技术提升并发性能
- 弱一致性：迭代器不一定能反映最新的修改

## 1.2 并发容器分类

### 1.2.1 并发 List

- `CopyOnWriteArrayList`：写时复制的 List 实现
- `Collections.synchronizedList`：同步包装的 List

### 1.2.2 并发 Map

- `ConcurrentHashMap`：分段锁实现的 Map
- `ConcurrentSkipListMap`：跳表实现的有序 Map

### 1.2.3 并发 Queue

- `ConcurrentLinkedQueue`：非阻塞队列
- `BlockingQueue` 家族：阻塞队列实现

### 1.2.4 并发 Set

- `CopyOnWriteArraySet`：基于 CopyOnWriteArrayList 实现
- `ConcurrentSkipListSet`：基于 ConcurrentSkipListMap 实现

## 1.3 并发容器详解

### 1.3.1 CopyOnWriteArrayList

1. **基本原理**

```java
public class CopyOnWriteArrayList<E> {
    private transient volatile Object[] array;

    public boolean add(E e) {
        final ReentrantLock lock = this.lock;
        lock.lock();
        try {
            Object[] elements = getArray();
            int len = elements.length;
            Object[] newElements = Arrays.copyOf(elements, len + 1);
            newElements[len] = e;
            setArray(newElements);
            return true;
        } finally {
            lock.unlock();
        }
    }
}
```

2. **适用场景**

- 读多写少的并发场景
- 实时性要求不高的场景
- 集合规模较小的场景

3. **使用示例**

```java
CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<>();
// 写操作
list.add("item1");
list.add("item2");

// 读操作（无锁）
for (String item : list) {
    System.out.println(item);
}
```

### 1.3.2 ConcurrentHashMap

^be824f

1. **基本原理**

```java
public class ConcurrentHashMap<K,V> {
    // JDK 8 使用 CAS + synchronized 实现
    transient volatile Node<K,V>[] table;

    final V putVal(K key, V value, boolean onlyIfAbsent) {
        if (key == null || value == null) throw new NullPointerException();
        int hash = spread(key.hashCode());
        int binCount = 0;
        for (Node<K,V>[] tab = table;;) {
            Node<K,V> f; int n, i, fh;
            if (tab == null || (n = tab.length) == 0)
                tab = initTable();
            else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
                if (casTabAt(tab, i, null, new Node<K,V>(hash, key, value, null)))
                    break;
            }
            // ... 其他逻辑
        }
    }
}
```

2. **重要特性**

- 分段锁设计
- 支持高并发访问
- 弱一致性迭代器
- 不允许 null 键和值

3. **使用示例**

```java
ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();
// 原子操作
map.put("key1", 1);
map.putIfAbsent("key2", 2);

// 原子更新
map.replace("key1", 1, 2);
map.computeIfAbsent("key3", k -> 3);
```

### 1.3.3 BlockingQueue

1. **常用实现**

```java
// 有界队列
BlockingQueue<String> arrayQueue = new ArrayBlockingQueue<>(100);
// 无界队列
BlockingQueue<String> linkedQueue = new LinkedBlockingQueue<>();
// 优先级队列
BlockingQueue<String> priorityQueue = new PriorityBlockingQueue<>();
// 延迟队列
BlockingQueue<String> delayQueue = new DelayQueue<>();
```

2. **核心方法**

```java
public interface BlockingQueue<E> {
    // 添加方法
    boolean add(E e);        // 队列满时抛异常
    boolean offer(E e);      // 队列满时返回 false
    void put(E e);          // 队列满时阻塞等待

    // 获取方法
    E remove();             // 队列空时抛异常
    E poll();               // 队列空时返回 null
    E take();              // 队列空时阻塞等待
}
```

3. **使用示例**

```java
// 生产者-消费者模式
class Producer implements Runnable {
    private BlockingQueue<String> queue;

    public void run() {
        try {
            queue.put("task");  // 阻塞式添加
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}

class Consumer implements Runnable {
    private BlockingQueue<String> queue;

    public void run() {
        try {
            String task = queue.take();  // 阻塞式获取
            process(task);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
```

## 1.4 原子类

### 1.4.1 基本类型原子类

1. **常用类型**

```java
// 整数类型
AtomicInteger atomicInt = new AtomicInteger(0);
AtomicLong atomicLong = new AtomicLong(0L);
// 布尔类型
AtomicBoolean atomicBoolean = new AtomicBoolean(false);
```

2. **核心方法**

```java
public class AtomicInteger {
    // 原子更新方法
    public final int incrementAndGet()
    public final int decrementAndGet()
    public final int getAndAdd(int delta)
    public final boolean compareAndSet(int expect, int update)

    // 原子操作示例
    AtomicInteger counter = new AtomicInteger(0);
    counter.incrementAndGet();  // 原子自增
    counter.getAndAdd(5);      // 原子加法
    counter.compareAndSet(5, 10); // CAS 操作
}
```

### 1.4.2 数组类型原子类

1. **常用类型**

```java
// 原子数组
AtomicIntegerArray atomicIntArray = new AtomicIntegerArray(10);
AtomicLongArray atomicLongArray = new AtomicLongArray(10);
AtomicReferenceArray<String> atomicRefArray = new AtomicReferenceArray<>(10);
```

2. **使用示例**

```java
AtomicIntegerArray array = new AtomicIntegerArray(10);
array.set(0, 1);            // 设置元素
array.getAndIncrement(0);   // 原子自增
array.addAndGet(0, 5);      // 原子加法
```

### 1.4.3 引用类型原子类

1. **常用类型**

```java
// 原子引用
AtomicReference<User> userRef = new AtomicReference<>();
// 带版本号的原子引用（解决 ABA 问题）
AtomicStampedReference<String> stampedRef =
    new AtomicStampedReference<>("value", 0);
// 带标记的原子引用
AtomicMarkableReference<String> markableRef =
    new AtomicMarkableReference<>("value", false);
```

2. **使用示例**

```java
// AtomicReference 示例
AtomicReference<User> userRef = new AtomicReference<>();
User user = new User("Tom", 20);
userRef.set(user);
User oldUser = userRef.get();
User newUser = new User("Jerry", 25);
userRef.compareAndSet(oldUser, newUser);

// AtomicStampedReference 示例（解决 ABA 问题）
AtomicStampedReference<String> stampedRef =
    new AtomicStampedReference<>("A", 0);
int stamp = stampedRef.getStamp();
String value = stampedRef.getReference();
stampedRef.compareAndSet(value, "B", stamp, stamp + 1);
```

### 1.4.4 字段更新器

1. **常用类型**

```java
// 字段更新器
AtomicIntegerFieldUpdater<User> ageUpdater =
    AtomicIntegerFieldUpdater.newUpdater(User.class, "age");
AtomicReferenceFieldUpdater<User, String> nameUpdater =
    AtomicReferenceFieldUpdater.newUpdater(User.class, String.class, "name");
```

2. **使用示例**

```java
public class User {
    volatile int age;    // 必须是 volatile
    volatile String name; // 必须是 volatile

    // 字段更新器示例
    private static final AtomicIntegerFieldUpdater<User> AGE_UPDATER =
        AtomicIntegerFieldUpdater.newUpdater(User.class, "age");

    public void incrementAge() {
        AGE_UPDATER.incrementAndGet(this);
    }
}
```

## 1.5 并发工具类最佳实践

### 1.5.1 选择合适的并发容器

1. **场景选择**

```java
// 场景1：读多写少
CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<>();

// 场景2：高并发访问
ConcurrentHashMap<String, Object> map = new ConcurrentHashMap<>();

// 场景3：生产者-消费者模式
BlockingQueue<Task> queue = new ArrayBlockingQueue<>(100);

// 场景4：需要排序
ConcurrentSkipListMap<String, Object> sortedMap =
    new ConcurrentSkipListMap<>();
```

2. **性能考虑**

- 避免过度同步
- 合理设置初始容量
- 注意内存占用

### 1.5.2 注意事项

1. **迭代器使用**

```java
ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();
// 弱一致性迭代
for (Map.Entry<String, Integer> entry : map.entrySet()) {
    // 迭代过程中的修改可能不可见
}
```

2. **原子操作**

```java
// 组合操作需要额外同步
ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();
synchronized (map) {
    if (!map.containsKey("key")) {
        map.put("key", 1);
    }
}

// 使用原子方法
map.putIfAbsent("key", 1);
```

3. **性能优化**

```java
// 批量操作优化
ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();
// 不推荐
for (String key : keys) {
    map.put(key, value);
}

// 推荐
map.putAll(prepareBatchData());
```

### 1.5.3 常见问题

1. **内存泄漏**

```java
// 需要及时清理不用的元素
ConcurrentHashMap<String, Object> cache = new ConcurrentHashMap<>();
// 定期清理
scheduler.scheduleAtFixedRate(() -> {
    cache.entrySet().removeIf(entry ->
        isExpired(entry.getValue()));
}, 1, 1, TimeUnit.HOURS);
```

2. **死锁预防**

```java
// 使用带超时的阻塞方法
BlockingQueue<Task> queue = new ArrayBlockingQueue<>(100);
Task task = queue.poll(1, TimeUnit.SECONDS);

// 使用 tryLock 避免死锁
ReentrantLock lock = new ReentrantLock();
if (lock.tryLock(1, TimeUnit.SECONDS)) {
    try {
        // 处理任务
    } finally {
        lock.unlock();
    }
}
```

3. **性能问题**

```java
// 避免创建过多的临时对象
AtomicReference<User> userRef = new AtomicReference<>();
// 不推荐
while (true) {
    User user = userRef.get();
    User newUser = new User(user.getName(), user.getAge() + 1);
    if (userRef.compareAndSet(user, newUser)) {
        break;
    }
}

// 推荐
userRef.updateAndGet(user ->
    new User(user.getName(), user.getAge() + 1));
```

