---
title: "1 Java 锁机制"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Java 锁机制

## 1.1 锁的基本概念

### 1.1.1 什么是锁

锁是Java并发编程中用于线程同步的机制，用于保证多线程环境下共享资源的互斥访问，防止数据竞争和保证数据一致性。

#### 1.1.1.1 锁的作用

1. **线程同步**
   - 保证共享资源的互斥访问
   - 维护线程间的执行顺序
   - 确保数据的一致性和可见性

2. **内存可见性**
   - 保证修改的数据能被其他线程看到
   - 防止指令重排优化
   - 建立happens-before关系

3. **性能平衡**
   - 在并发和安全间寻找平衡点
   - 通过不同锁机制优化性能
   - 根据场景选择合适的锁

#### 1.1.1.2 锁的工作原理

1. **获取锁的过程**
   - 检查锁的状态
   - 尝试获取锁的所有权
   - 失败时进入等待队列

2. **锁的状态变化**
   - 无锁 → 偏向锁 → 轻量级锁 → 重量级锁
   - 状态升级过程不可逆
   - 根据竞争程度自动升级

3. **锁的释放机制**
   - 显式释放（Lock接口）
   - 自动释放（synchronized）
   - 唤醒等待线程

### 1.1.2 同步机制的分类

1. **锁（Lock）**
   - 互斥锁：保证同一时刻只有一个线程可以访问共享资源
   - 读写锁：允许多个读线程同时访问，但写线程需要独占

2. **信号量（Semaphore）**
   - 计数信号量：控制同时访问共享资源的线程数量
   - 二元信号量：相当于互斥锁

3. **条件变量（Condition）**
   - 线程等待/通知机制
   - 支持多个等待队列

### 1.1.3 锁的分类

1. **按实现方式分类**
   - synchronized 关键字（内置锁）
   - Lock 接口实现（显式锁）

2. **按锁的性质分类**
   - 可重入锁/不可重入锁
   - 公平锁/非公平锁
   - 独占锁/共享锁
   - 乐观锁/悲观锁

### 1.1.4 锁的对比分析

| 锁类型 | 实现方式 | 优点 | 缺点 | 适用场景 |
|--------|----------|------|------|----------|
| synchronized | JVM内置 | 使用简单，自动释放 | 功能单一，不可中断 | 低竞争场景 |
| ReentrantLock | JUC实现 | 功能丰富，可中断 | 需手动释放，代码复杂 | 高竞争场景 |
| ReadWriteLock | JUC实现 | 读写分离，提高并发 | 写线程可能饥饿 | 读多写少 |
| StampedLock | JUC实现 | 支持乐观读，性能高 | 不可重入，不支持条件变量 | 读多写少且性能要求高 |
| Semaphore | JUC实现 | 控制并发数，资源池 | 不保证公平性 | 限流，资源池管理 |

### 1.1.5 各类锁的详细介绍

#### 1.1.5.1 synchronized（内置锁）

1. **实现原理**
   - 基于Monitor机制实现
   - 依赖对象头中的Mark Word
   - 支持锁升级（偏向锁→轻量级锁→重量级锁）

2. **核心特性**
   - 自动加锁和释放
   - 可重入性
   - 非公平锁
   - 不可中断

3. **性能优化**
   - 偏向锁：减少无竞争时的同步开销
   - 轻量级锁：避免线程阻塞
   - 适应性自旋：优化短期锁定

4. **使用场景**
   - 代码块同步
   - 方法同步
   - 类级别同步
   - 低竞争环境

#### 1.1.5.2 ReentrantLock（可重入锁）

1. **实现原理**
   - 基于AQS（AbstractQueuedSynchronizer）
   - 维护一个同步队列
   - 支持公平和非公平模式

2. **核心特性**
   - 可重入性
   - 可中断性
   - 支持超时获取锁
   - 支持多个条件变量
   - 支持公平锁

3. **高级功能**
   - lockInterruptibly()：可中断获取锁
   - tryLock()：尝试获取锁
   - newCondition()：创建条件变量
   - getHoldCount()：查询当前线程的重入次数

4. **使用场景**
   - 需要灵活控制锁的场景
   - 需要可中断的锁获取操作
   - 需要公平锁的场景
   - 需要多个条件变量的场景

#### 1.1.5.3 ReadWriteLock（读写锁）

1. **实现原理**
   - 维护读锁和写锁
   - 读锁共享，写锁独占
   - 写锁优先级高于读锁

2. **核心特性**
   - 读写分离
   - 写锁独占
   - 读锁共享
   - 支持锁降级（写锁→读锁）

3. **性能特点**
   - 读多写少场景性能好
   - 写线程可能饥饿
   - 适合读多写少的场景

4. **使用场景**
   - 缓存实现
   - 读多写少的数据结构
   - 需要读写分离的场景

#### 1.1.5.4 StampedLock（邮戳锁）

1. **实现原理**
   - 基于CLH锁的变体实现
   - 不是基于AQS框架
   - 使用stamp（邮戳）作为锁的标识

2. **核心特性**
   - 支持乐观读
   - 三种模式：写、读、乐观读
   - 不可重入
   - 不支持条件变量

3. **性能优势**
   - 乐观读不阻塞写线程
   - 读写之间没有优先级
   - 性能优于ReadWriteLock

4. **使用场景**
   - 读多写少且性能要求高
   - 数据一致性要求不严格
   - 适合乐观读场景

#### 1.1.5.5 Semaphore（信号量）

1. **实现原理**
   - 基于AQS框架
   - 维护一个许可证计数器
   - 支持公平和非公平模式

2. **核心特性**
   - 可配置许可证数量
   - 支持公平和非公平获取
   - 支持批量获取和释放
   - 可以用作限流器

3. **主要方法**
   - acquire()：获取许可
   - release()：释放许可
   - tryAcquire()：尝试获取许可
   - availablePermits()：查询可用许可数

4. **使用场景**
   - 限制并发访问数
   - 实现资源池
   - 流量控制
   - 并发限制

## 1.2 synchronized 锁

### 1.2.1 基本使用

```java
// 1. 对象锁
public class SynchronizedExample {
    private final Object lock = new Object();
    
    // 方法锁
    public synchronized void method1() {
        // 同步代码
    }
    
    // 代码块锁
    public void method2() {
        synchronized(lock) {
            // 同步代码
        }
    }
}

// 2. 类锁
public class ClassLockExample {
    // 静态方法锁
    public static synchronized void method1() {
        // 同步代码
    }
    
    // 类对象锁
    public void method2() {
        synchronized(ClassLockExample.class) {
            // 同步代码
        }
    }
}
```

### 1.2.2 锁升级过程

```mermaid
graph LR
    A[无锁] --> B[偏向锁]
    B --> C[轻量级锁]
    C --> D[重量级锁]
```

1. **偏向锁**
   - 针对单线程访问
   - 首次获取锁时记录线程ID
   - 同一线程再次获取锁时无需同步操作

2. **轻量级锁**
   - 多线程竞争不激烈时使用
   - 通过CAS操作获取锁
   - 自旋等待，避免线程阻塞

3. **重量级锁**
   - 多线程竞争激烈时升级
   - 基于操作系统互斥量实现
   - 线程阻塞与唤醒

## 1.3 显式锁

### 1.3.1 ReentrantLock

```java
public class LockExample {
    private final Lock lock = new ReentrantLock();
    
    public void method() {
        lock.lock();
        try {
            // 临界区代码
        } finally {
            lock.unlock();
        }
    }
    
    // 支持超时的获取锁
    public void methodWithTimeout() throws InterruptedException {
        if (lock.tryLock(1, TimeUnit.SECONDS)) {
            try {
                // 临界区代码
            } finally {
                lock.unlock();
            }
        }
    }
}
```

### 1.3.2 ReadWriteLock

```java
public class CacheExample {
    private Map<String, Object> cache = new HashMap<>();
    private ReadWriteLock rwLock = new ReentrantReadWriteLock();
    private Lock readLock = rwLock.readLock();
    private Lock writeLock = rwLock.writeLock();
    
    public Object read(String key) {
        readLock.lock();
        try {
            return cache.get(key);
        } finally {
            readLock.unlock();
        }
    }
    
    public void write(String key, Object value) {
        writeLock.lock();
        try {
            cache.put(key, value);
        } finally {
            writeLock.unlock();
        }
    }
}
```

### 1.3.3 StampedLock

```java
public class Point {
    private double x, y;
    private final StampedLock sl = new StampedLock();
    
    // 写锁
    public void move(double deltaX, double deltaY) {
        long stamp = sl.writeLock();
        try {
            x += deltaX;
            y += deltaY;
        } finally {
            sl.unlockWrite(stamp);
        }
    }
    
    // 乐观读
    public double distanceFromOrigin() {
        long stamp = sl.tryOptimisticRead();
        double currentX = x, currentY = y;
        if (!sl.validate(stamp)) {
            stamp = sl.readLock();
            try {
                currentX = x;
                currentY = y;
            } finally {
                sl.unlockRead(stamp);
            }
        }
        return Math.sqrt(currentX * currentX + currentY * currentY);
    }
}
```

### 1.3.4 Semaphore

```java
public class Pool {
    private final Semaphore sem;
    private final List<Object> items;
    
    public Pool(int size) {
        sem = new Semaphore(size);
        items = new ArrayList<>(size);
    }
    
    public Object acquire() throws InterruptedException {
        sem.acquire();
        return getItem();
    }
    
    public void release(Object item) {
        if (putItem(item)) {
            sem.release();
        }
    }
}
```

## 1.4 锁优化技术

### 1.4.1 减小锁粒度

1. **缩小同步范围**
```java
public void process() {
    // 非同步操作
    Object result = prepare();
    
    synchronized(lock) {
        // 最小化同步区域
    }
    
    // 非同步操作
    postProcess(result);
}
```

2. **锁分段**
```java
// 使用 ConcurrentHashMap 代替 synchronized Map
Map<String, Object> map = new ConcurrentHashMap<>();
```

### 1.4.2 锁消除和锁粗化

1. **锁消除**：JIT编译器优化，删除不必要的加锁操作
2. **锁粗化**：合并相邻的同步块，减少加锁解锁次数

### 1.4.3 性能对比

| 优化方式 | 适用场景 | 性能提升 | 实现复杂度 |
|----------|----------|----------|------------|
| 减小锁粒度 | 并发访问集合 | 高 | 中 |
| 锁分段 | 大规模并发写入 | 高 | 高 |
| 锁消除 | 线程安全对象 | 中 | 低 |
| 锁粗化 | 频繁加锁操作 | 中 | 低 |

## 1.5 最佳实践

1. **选择合适的锁**
   - 低竞争场景：synchronized
   - 高竞争场景：ReentrantLock
   - 读多写少：ReadWriteLock或StampedLock
   - 资源池管理：Semaphore

```java
// 低竞争场景示例
public synchronized void lowContention() {
    // 简单的同步操作
}

// 高竞争场景示例
private final ReentrantLock lock = new ReentrantLock(true); // true表示公平锁
public void highContention() {
    lock.lock();
    try {
        // 复杂的同步操作
    } finally {
        lock.unlock();
    }
}

// 读多写少场景示例
private final ReadWriteLock rwLock = new ReentrantReadWriteLock();
public void readOperation() {
    rwLock.readLock().lock();
    try {
        // 读操作
    } finally {
        rwLock.readLock().unlock();
    }
}
```

2. **避免死锁**
   - 固定加锁顺序
   - 避免嵌套锁
   - 使用超时机制
   - 使用tryLock尝试获取锁

```java
// 正确的加锁顺序
public void transferMoney(Account from, Account to, double amount) {
    // 始终按照账户ID的顺序加锁
    Account first = from.getId() < to.getId() ? from : to;
    Account second = from.getId() < to.getId() ? to : from;
    
    synchronized(first) {
        synchronized(second) {
            // 转账操作
        }
    }
}

// 使用tryLock避免死锁
public boolean tryTransfer(Account from, Account to, double amount, long timeout) {
    try {
        if (from.getLock().tryLock(timeout, TimeUnit.MILLISECONDS)) {
            try {
                if (to.getLock().tryLock(timeout, TimeUnit.MILLISECONDS)) {
                    try {
                        // 转账操作
                        return true;
                    } finally {
                        to.getLock().unlock();
                    }
                }
            } finally {
                from.getLock().unlock();
            }
        }
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
    }
    return false;
}
```

3. **性能优化**
   - 减少锁持有时间
   - 避免锁的粗粒度使用
   - 合理使用乐观锁
   - 选择合适的锁实现

```java
// 减少锁持有时间示例
public void optimizedMethod() {
    // 锁外进行准备工作
    Object result = prepare();
    
    synchronized(lock) {
        // 最小化同步区域
        updateSharedState(result);
    }
    
    // 锁外进行后续处理
    postProcess(result);
}

// 使用乐观锁示例（基于版本号）
public boolean updateData(Data data) {
    int version;
    do {
        version = data.getVersion();
        // 修改数据
        data.setValue(newValue);
    } while (!data.compareAndSet(version, version + 1));
    return true;
}
```

4. **注意事项**
   - 在finally块中释放锁
   - 避免在循环中频繁加锁解锁
   - 注意锁的重入性
   - 合理使用锁超时机制
   - 避免在锁内部进行耗时操作

```java
// 正确的锁使用模式
public void processItems(List<Item> items) {
    // 避免在循环中加锁解锁
    lock.lock();
    try {
        for (Item item : items) {
            processItem(item);
        }
    } finally {
        lock.unlock();
    }
}

// 错误的锁使用模式
public void processItemsWrong(List<Item> items) {
    // 不要这样做！
    for (Item item : items) {
        lock.lock();
        try {
            processItem(item);
        } finally {
            lock.unlock();
        }
    }
}

// 避免在锁内部进行耗时操作
public void processWithIO() {
    // IO准备工作
    byte[] data = prepareData();
    
    lock.lock();
    try {
        // 仅同步必要的状态更新
        updateState(data);
    } finally {
        lock.unlock();
    }
    
    // IO操作放在锁外部
    saveToFile(data);
}
