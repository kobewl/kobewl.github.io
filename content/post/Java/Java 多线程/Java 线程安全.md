---
title: "Java 线程安全"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# Java 线程安全

## 1. 并发问题

### 1.1 什么是线程安全

- 当多个线程同时访问一个对象时，如果不考虑这些线程在运行时环境下的调度和交替执行，也不需要进行额外的同步，调用这个对象的行为都可以获得正确的结果，就称这个对象是线程安全的。

### 1.2 线程不安全的表现

1. **原子性问题**

   - 一个操作的中间状态对其他线程可见
   - 典型场景：i++ 操作

2. **可见性问题**

   - 一个线程对共享变量的修改，其他线程不能立即看到
   - 由于 CPU 缓存导致的数据不一致

3. **有序性问题**
   - 程序的执行顺序与代码编写顺序不同
   - 由于指令重排序优化导致

### 1.3 竞态条件示例

```java
public class Counter {
    private int count = 0;

    // 线程不安全的计数方法
    public void increment() {
        count++;  // 非原子操作
    }

    public int getCount() {
        return count;
    }
}
```

## 2. 线程安全实现方式

^cd9ebe

### 2.1 synchronized 关键字

^86ce7c

1. **基本使用**

```java
public class SafeCounter {
    private int count = 0;

    // 同步方法
    public synchronized void increment() {
        count++;
    }

    // 同步代码块
    public void incrementBlock() {
        synchronized(this) {
            count++;
        }
    }
}
```

2. **synchronized 的特性**

   - 原子性：确保同步代码块的操作是原子的
   - 可见性：保证线程间的可见性
   - 有序性：禁止指令重排序
   - 可重入性：同一个线程可以重复获取同一把锁

3. **synchronized 的使用方式**

   - 修饰实例方法：锁定当前对象实例
   - 修饰静态方法：锁定当前类的 Class 对象
   - 修饰代码块：锁定指定对象

4. **synchronized 的优化**
   - 偏向锁：减少无竞争情况下的同步开销
   - 轻量级锁：减少竞争较少情况下的同步开销
   - 重量级锁：保证多线程竞争的正确性

### 2.2 Lock 接口

^62d4e8

1. **ReentrantLock 基本使用**

```java
public class SafeCounter {
    private int count = 0;
    private final Lock lock = new ReentrantLock();

    public void increment() {
        lock.lock();  // 获取锁
        try {
            count++;
        } finally {
            lock.unlock();  // 释放锁
        }
    }

    // 支持超时的获取锁方式
    public void incrementWithTimeout() throws InterruptedException {
        if (lock.tryLock(1, TimeUnit.SECONDS)) {
            try {
                count++;
            } finally {
                lock.unlock();
            }
        }
    }
}
```

2. **Lock 接口的特性**

   - 可中断获取锁：`lockInterruptibly()`
   - 可超时获取锁：`tryLock(long time, TimeUnit unit)`
   - 可非阻塞获取锁：`tryLock()`
   - 可实现公平锁：`new ReentrantLock(true)`

3. **ReadWriteLock 读写锁**

```java
public class SafeCache {
    private Map<String, Object> cache = new HashMap<>();
    private ReadWriteLock rwLock = new ReentrantReadWriteLock();
    private Lock readLock = rwLock.readLock();
    private Lock writeLock = rwLock.writeLock();

    public Object get(String key) {
        readLock.lock();
        try {
            return cache.get(key);
        } finally {
            readLock.unlock();
        }
    }

    public void put(String key, Object value) {
        writeLock.lock();
        try {
            cache.put(key, value);
        } finally {
            writeLock.unlock();
        }
    }
}
```

### 2.3 volatile 关键字

1. **基本使用**

```java
public class StatusHolder {
    private volatile boolean flag = false;

    public void setFlag() {
        flag = true;  // 对其他线程立即可见
    }

    public boolean getFlag() {
        return flag;
    }
}
```

2. **volatile 的特性**

   - 保证可见性：修改立即对其他线程可见
   - 保证有序性：禁止指令重排序
   - 不保证原子性：不能保证复合操作的原子性

3. **适用场景**
   - 状态标志位
   - 双重检查锁定（DCL）
   - 独立观察者模式

### 2.4 原子类

1. **基本类型原子类**

```java
public class AtomicCounter {
    private AtomicInteger count = new AtomicInteger(0);

    public void increment() {
        count.incrementAndGet();  // 原子操作
    }

    public int getCount() {
        return count.get();
    }
}
```

2. **常用原子类**

   - `AtomicInteger`/`AtomicLong`/`AtomicBoolean`
   - `AtomicReference`：原子引用
   - `AtomicIntegerArray`：原子数组
   - `AtomicStampedReference`：带版本号的原子引用

3. **原子类的优势**
   - 无锁实现，性能更好
   - 避免 ABA 问题
   - 支持原子更新操作

### 2.5 线程安全集合

1. **同步包装器**

```java
// 将普通集合转换为线程安全集合
List<String> list = Collections.synchronizedList(new ArrayList<>());
Map<String, Object> map = Collections.synchronizedMap(new HashMap<>());
Set<String> set = Collections.synchronizedSet(new HashSet<>());
```

2. **并发集合**

```java
// JUC包中的并发集合
ConcurrentHashMap<String, Object> map = new ConcurrentHashMap<>();
CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<>();
ConcurrentLinkedQueue<String> queue = new ConcurrentLinkedQueue<>();
BlockingQueue<String> blockingQueue = new ArrayBlockingQueue<>(100);
```

3. **常用并发集合特点**
   - `ConcurrentHashMap`：分段锁实现，并发度高
   - `CopyOnWriteArrayList`：写时复制，适合读多写少
   - `BlockingQueue`：用于生产者-消费者模式
   - `ConcurrentSkipListMap`：并发排序 Map

### 2.6 ThreadLocal

1. **基本使用**

```java
public class UserContext {
    private static final ThreadLocal<User> userHolder = new ThreadLocal<>();

    public static void setUser(User user) {
        userHolder.set(user);
    }

    public static User getUser() {
        return userHolder.get();
    }

    public static void clear() {
        userHolder.remove();  // 防止内存泄露
    }
}
```

2. **ThreadLocal 的特点**

   - 线程封闭：每个线程独立的副本
   - 线程隔离：不同线程数据互不影响
   - 简化参数传递：避免方法之间传递参数

3. **注意事项**
   - 内存泄露：必须手动清理
   - 线程池注意：及时清理 ThreadLocal
   - 父子线程：考虑使用 InheritableThreadLocal

## 3. 线程安全最佳实践

### 3.1 设计原则

1. **不可变性**

   - 使用 final 修饰类和字段
   - 确保状态不可变
   - 例如：String、Integer 等

2. **线程封闭**

   - 栈封闭：局部变量
   - ThreadLocal：线程本地存储
   - 单线程使用：确保只在单线程中访问

3. **同步策略**
   - 粗粒度同步：同步整个方法
   - 细粒度同步：同步关键代码块
   - 避免过度同步：影响性能

### 3.2 性能优化

1. **减少锁持有时间**

```java
public class OptimizedLock {
    public void process() {
        // 执行不需要同步的操作
        Object result = prepareData();

        synchronized(this) {
            // 只同步必要的代码
            updateSharedState(result);
        }

        // 继续执行不需要同步的操作
        postProcess();
    }
}
```

2. **减少锁粒度**

   - 使用分段锁
   - 使用并发集合
   - 使用原子类

3. **避免死锁**
   - 固定加锁顺序
   - 使用超时锁
   - 避免嵌套锁

### 3.3 常见问题

1. **死锁问题**

```java
public class DeadLockDemo {
    private final Object lockA = new Object();
    private final Object lockB = new Object();

    public void methodA() {
        synchronized(lockA) {
            synchronized(lockB) {
                // 可能发生死锁
            }
        }
    }

    public void methodB() {
        synchronized(lockB) {
            synchronized(lockA) {
                // 可能发生死锁
            }
        }
    }
}
```

2. **活锁问题**

   - 线程互相谦让，都无法完成任务
   - 解决：引入随机等待时间

3. **饥饿问题**
   - 线程无法获取所需资源
   - 解决：使用公平锁

### 3.4 监控和调试

1. **线程转储（Thread Dump）**

   - 使用 jstack 命令
   - 分析线程状态和锁信息
   - 定位死锁和性能问题

2. **性能分析**

   - 使用 JMX 监控线程
   - 使用性能分析工具
   - 监控锁竞争情况

3. **调试技巧**
   - 日志记录关键操作
   - 使用断言验证不变性
   - 使用测试工具模拟并发

## 4. Java 锁机制详解

### 4.1 synchronized 锁原理

1. **对象头结构**

```java
// 对象头主要包含两部分
Mark Word：   // 存储对象自身的运行时数据
    - HashCode
    - GC 分代年龄
    - 锁状态标志
    - 线程持有的锁
    - 偏向线程 ID
    - 偏向时间戳
Class Pointer：// 指向对象类型数据的指针
```

2. **锁的状态变化**

```
无锁 -> 偏向锁 -> 轻量级锁 -> 重量级锁
```

3. **Monitor 机制**

- 每个对象都有一个 Monitor 监视器
- Monitor 包含：
  - Owner：持有锁的线程
  - EntryList：等待获取锁的线程队列
  - WaitSet：调用 wait() 的线程队列

### 4.2 锁升级过程

1. **偏向锁**

```java
// 偏向锁的获取过程
if (对象头的Mark Word可偏向) {
    if (偏向锁指向当前线程) {
        // 已经获得偏向锁，继续执行
    } else if (偏向锁空闲) {
        // CAS 竞争锁，成功则获得偏向锁
    } else {
        // 偏向其他线程，撤销偏向锁
        // 升级为轻量级锁
    }
}

// 使用场景
public class BiasedLockExample {
    private Object lock = new Object();

    public void doSomething() {
        synchronized(lock) {  // 第一次获取锁时会偏向当前线程
            // 业务逻辑
        }
    }
}
```

2. **轻量级锁**

```java
// 轻量级锁的获取过程
if (对象头的Mark Word无锁或偏向锁) {
    // 创建锁记录（Lock Record）
    // CAS 尝试将对象头指向锁记录
    if (CAS成功) {
        // 获得轻量级锁
    } else {
        // 自旋等待或升级为重量级锁
    }
}

// 自旋优化示例
public class SpinLockExample {
    private AtomicReference<Thread> owner = new AtomicReference<>();

    public void lock() {
        Thread current = Thread.currentThread();
        // 自旋等待锁释放
        while (!owner.compareAndSet(null, current)) {
            // 自旋等待
        }
    }
}
```

3. **重量级锁**

```java
// 重量级锁的工作原理
synchronized(object) {
    // 1. 检查对象头的锁状态
    // 2. 获取 Monitor 对象
    // 3. 进入等待队列或获取锁
    // 4. 执行同步代码块
    // 5. 释放锁
}
```

### 4.3 对象锁与类锁

1. **对象锁（实例锁）**

```java
public class ObjectLockExample {
    private final Object lock = new Object();

    // 方式1：synchronized 方法
    public synchronized void method1() {
        // 使用 this 作为锁对象
    }

    // 方式2：synchronized 代码块
    public void method2() {
        synchronized(lock) {
            // 使用指定对象作为锁
        }
    }
}
```

2. **类锁（静态锁）**

```java
public class ClassLockExample {
    // 方式1：synchronized 静态方法
    public static synchronized void method1() {
        // 使用类对象作为锁
    }

    // 方式2：synchronized 类对象
    public void method2() {
        synchronized(ClassLockExample.class) {
            // 使用类对象作为锁
        }
    }
}
```

### 4.4 乐观锁与悲观锁

1. **悲观锁**

```java
// 传统的 synchronized 和 ReentrantLock 都是悲观锁
public class PessimisticLockExample {
    private final ReentrantLock lock = new ReentrantLock();

    public void doSomething() {
        lock.lock();
        try {
            // 操作共享资源
        } finally {
            lock.unlock();
        }
    }
}
```

2. **乐观锁**

```java
// 基于 CAS 的乐观锁实现
public class OptimisticLockExample {
    private AtomicInteger value = new AtomicInteger(0);

    public void increment() {
        int oldValue;
        int newValue;
        do {
            oldValue = value.get();
            newValue = oldValue + 1;
        } while (!value.compareAndSet(oldValue, newValue));
    }
}
```

### 4.5 StampedLock

1. **基本用法**

```java
public class Point {
    private double x, y;
    private final StampedLock sl = new StampedLock();

    // 写锁（独占锁）
    public void move(double deltaX, double deltaY) {
        long stamp = sl.writeLock();  // 获取写锁
        try {
            x += deltaX;
            y += deltaY;
        } finally {
            sl.unlockWrite(stamp);    // 释放写锁
        }
    }

    // 乐观读
    public double distanceFromOrigin() {
        long stamp = sl.tryOptimisticRead();  // 获取乐观读标记
        double currentX = x, currentY = y;     // 读取共享资源
        if (!sl.validate(stamp)) {            // 检查期间是否有写操作
            stamp = sl.readLock();            // 升级为悲观读锁
            try {
                currentX = x;
                currentY = y;
            } finally {
                sl.unlockRead(stamp);
            }
        }
        return Math.sqrt(currentX * currentX + currentY * currentY);
    }

    // 悲观读锁
    public double read() {
        long stamp = sl.readLock();
        try {
            return x + y;
        } finally {
            sl.unlockRead(stamp);
        }
    }
}
```

2. **StampedLock 特点**

- 支持三种模式：写锁、悲观读锁、乐观读
- 写锁是独占的
- 不支持重入
- 不支持条件变量
- 性能比 ReadWriteLock 更好

### 4.6 锁的最佳实践

1. **选择合适的锁**

```java
// 场景1：单线程访问
使用偏向锁 -> synchronized

// 场景2：低竞争多线程
使用轻量级锁 -> synchronized 或 ReentrantLock

// 场景3：高竞争多线程
使用重量级锁 -> ReentrantLock 或 分段锁

// 场景4：读多写少
使用 ReadWriteLock 或 StampedLock

// 场景5：需要超时或中断
使用 ReentrantLock
```

2. **性能优化建议**

```java
// 1. 缩小锁范围
public void process() {
    // 无锁操作
    Object result = prepare();

    synchronized(lock) {
        // 最小化同步区域
    }

    // 无锁操作
    postProcess(result);
}

// 2. 避免锁嵌套
// 不推荐
synchronized(lockA) {
    synchronized(lockB) {
        // 可能死锁
    }
}

// 推荐
private final Object lock = new Object();
synchronized(lock) {
    // 单锁操作
}

// 3. 使用合适的锁粒度
private final Map<String, Object> map = new ConcurrentHashMap<>();  // 分段锁
private final List<String> list = new CopyOnWriteArrayList<>();    // 写时复制
```

3. **注意事项**

- 在 finally 块中释放锁
- 避免在循环中频繁加锁解锁
- 注意锁的重入性
- 合理使用锁超时机制
- 避免在锁内部进行耗时操作

