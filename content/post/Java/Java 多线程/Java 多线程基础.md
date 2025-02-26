---
title: "Java 多线程基础"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
## 0.1 线程概述

### 0.1.1 什么是线程

- Thread（线程）是程序执行的最小单位
- 一个 Process（进程）可以包含多个线程
- 线程共享进程的资源，包括内存空间和文件句柄

### 0.1.2 为什么需要多线程

- 提高程序的并发执行能力
- 充分利用多核 CPU 资源
- 提升用户体验（如：UI 响应）
- 降低系统资源的消耗

## 0.2 线程的生命周期

^bb5688

### 0.2.1 线程状态

线程在 Java 中存在以下状态（`Thread.State`）：

1. **NEW**：新建状态

   - 线程被创建，但尚未调用 `start()` 方法

2. **RUNNABLE**：可运行状态

   - 线程正在 JVM 中运行
   - 等待 CPU 时间片

3. **BLOCKED**：阻塞状态

   - 等待获取 synchronized 锁
   - 被其他线程占用锁时

4. **WAITING**：等待状态

   - 调用 `wait()`
   - 调用 `join()`
   - 调用 `LockSupport.park()`

5. **TIMED_WAITING**：超时等待状态

   - 调用 `sleep(time)`
   - 调用 `wait(time)`
   - 调用 `join(time)`

6. **TERMINATED**：终止状态
   - 线程执行完毕
   - 出现未处理的异常

## 0.3 线程的创建方式

^35e54f

### 0.3.1 继承 Thread 类

```java
public class MyThread extends Thread {
    @Override
    public void run() {
        // 线程执行的代码
        System.out.println("Thread is running");
    }
}

// 使用方式
MyThread thread = new MyThread();
thread.start();
```

**优点：**

- 可以直接使用 Thread 类的方法，不需要额外实例化 Thread
- 获取线程名称等信息方便，可直接使用 this 关键字

**缺点：**

- Java 不支持多继承，如果继承了 Thread 类，就不能继承其他类
- 任务和线程的实现耦合在一起，不符合面向对象设计原则

### 0.3.2 实现 Runnable 接口

```java
public class MyRunnable implements Runnable {
    @Override
    public void run() {
        // 线程执行的代码
        System.out.println("Runnable is running");
    }
}

// 使用方式 - 方式1：传统方式
Thread thread = new Thread(new MyRunnable());
thread.start();

// 使用方式 - 方式2：Lambda表达式（Java 8+）
Thread thread2 = new Thread(() -> {
    System.out.println("Lambda Runnable is running");
});
thread2.start();

// 使用方式 - 方式3：匿名内部类
Thread thread3 = new Thread(new Runnable() {
    @Override
    public void run() {
        System.out.println("Anonymous Runnable is running");
    }
});
thread3.start();
```

**优点：**

- 可以继承其他类，更灵活
- 任务和线程的实现分离，更符合面向对象
- 可以共享资源，多个线程可以使用同一个 Runnable 实例

**缺点：**

- 不能直接使用 Thread 类的方法，需要使用 Thread.currentThread() 获取当前线程
- 任务没有返回值

### 0.3.3 实现 Callable 接口

```java
// 创建 Callable 对象
Callable<String> callable = new Callable<String>() {
    @Override
    public String call() throws Exception {
        // 执行任务并返回结果
        return "Task Result";
    }
};

// 使用方式1：使用 FutureTask
FutureTask<String> futureTask = new FutureTask<>(callable);
Thread thread = new Thread(futureTask);
thread.start();

try {
    // 获取任务执行结果（会阻塞等待）
    String result = futureTask.get();
    // 获取任务执行结果（最多等待1秒）
    String result2 = futureTask.get(1, TimeUnit.SECONDS);
} catch (Exception e) {
    e.printStackTrace();
}

// 使用方式2：使用 ExecutorService
ExecutorService executor = Executors.newSingleThreadExecutor();
Future<String> future = executor.submit(callable);

try {
    String result = future.get();
} catch (Exception e) {
    e.printStackTrace();
} finally {
    executor.shutdown();
}
```

**优点：**

- 可以有返回值
- 可以抛出异常
- 支持泛型
- 可以通过 Future 接口控制任务执行

**缺点：**

- 实现复杂，需要处理异常
- 需要借助 FutureTask 或线程池执行

### 0.3.4 使用线程池

```java
// 创建线程池
ExecutorService executorService = Executors.newFixedThreadPool(3);

// 方式1：执行 Runnable 任务
executorService.execute(() -> {
    System.out.println("Runnable task in thread pool");
});

// 方式2：提交 Callable 任务
Future<String> future = executorService.submit(() -> {
    return "Callable task result";
});

// 方式3：提交多个任务
List<Future<String>> futures = executorService.invokeAll(Arrays.asList(
    () -> "Task 1 result",
    () -> "Task 2 result"
));

// 方式4：提交多个任务，只要有一个完成就返回
String result = executorService.invokeAny(Arrays.asList(
    () -> "Task 1 result",
    () -> "Task 2 result"
));

try {
    // 获取任务执行结果
    String taskResult = future.get();
} catch (Exception e) {
    e.printStackTrace();
} finally {
    // 关闭线程池
    executorService.shutdown();
}
```

**优点：**

- 重用线程，避免频繁创建和销毁
- 控制并发数量，避免资源耗尽
- 提供任务队列，统一管理任务
- 提供多种预定义的线程池实现
- 支持定时任务和周期性任务

**缺点：**

- 使用不当可能造成资源耗尽
- 需要手动关闭线程池
- 任务队列可能造成内存溢出

### 0.3.5 四种方式对比

| 特性       | Thread | Runnable | Callable | 线程池 |
| ---------- | ------ | -------- | -------- | ------ |
| 任务返回值 | 无     | 无       | 有       | 有     |
| 异常处理   | 不支持 | 不支持   | 支持     | 支持   |
| 资源利用   | 差     | 一般     | 一般     | 好     |
| 代码耦合度 | 高     | 低       | 低       | 低     |
| 使用难度   | 简单   | 简单     | 中等     | 中等   |
| 扩展性     | 差     | 好       | 好       | 好     |

## 0.4 线程的基本操作

### 0.4.1 线程启动

- 使用 `start()` 方法启动线程
- 不能多次调用 `start()` 方法
- 直接调用 `run()` 方法不会启动新线程

### 0.4.2 线程中断

```java
// 中断线程
thread.interrupt();

// 判断线程是否被中断
boolean interrupted = Thread.interrupted();
boolean isInterrupted = thread.isInterrupted();
```

### 0.4.3 线程休眠

```java
try {
    // 休眠 1 秒
    Thread.sleep(1000);
} catch (InterruptedException e) {
    e.printStackTrace();
}
```

### 0.4.4 线程等待和唤醒

```java
// 等待
synchronized(object) {
    object.wait();
}

// 唤醒一个线程
synchronized(object) {
    object.notify();
}

// 唤醒所有线程
synchronized(object) {
    object.notifyAll();
}
```

### 0.4.5 线程合并

```java
// 等待线程执行完成
thread.join();

// 最多等待 1 秒
thread.join(1000);
```

### 0.4.6 线程优先级

```java
// 设置优先级 (1-10)
thread.setPriority(Thread.MAX_PRIORITY);  // 10
thread.setPriority(Thread.NORM_PRIORITY); // 5
thread.setPriority(Thread.MIN_PRIORITY);  // 1
```

## 0.5 线程安全问题

### 0.5.1 线程安全的概念

- 当多个线程同时访问共享资源时可能产生数据不一致
- 需要采取同步措施确保线程安全

### 0.5.2 常见的线程安全问题

- 竞态条件
- 死锁
- 活锁
- 饥饿

### 0.5.3 保证线程安全的方式

1. synchronized 关键字
2. Lock 接口
3. volatile 关键字
4. 线程安全的集合类
5. 原子类
6. ThreadLocal

## 0.6 最佳实践

### 0.6.1 线程池的使用

- 避免频繁创建和销毁线程
- 控制线程数量
- 重用线程资源

### 0.6.2 异常处理

- 使用 try-catch 块处理异常
- 使用 UncaughtExceptionHandler 处理未捕获的异常

### 0.6.3 资源管理

- 及时释放资源
- 使用 try-with-resources 语句
- 避免资源泄露

## 0.7 线程池详解

^2f105e

### 0.7.1 线程池的核心参数

^a1772d

ThreadPoolExecutor 的完整构造函数：

```java
public ThreadPoolExecutor(
    int corePoolSize,                    // 核心线程数
    int maximumPoolSize,                 // 最大线程数
    long keepAliveTime,                  // 空闲线程存活时间
    TimeUnit unit,                       // 时间单位
    BlockingQueue<Runnable> workQueue,   // 工作队列
    ThreadFactory threadFactory,         // 线程工厂
    RejectedExecutionHandler handler     // 拒绝策略
)
```

1. **corePoolSize（核心线程数）**

   - 线程池中常驻的线程数量
   - 即使线程空闲，也不会被销毁
   - 可以通过 allowCoreThreadTimeOut(true) 允许核心线程超时销毁

2. **maximumPoolSize（最大线程数）**

   - 线程池中允许的最大线程数
   - 当工作队列满了，且活动线程数小于最大线程数时，会创建新线程
   - 必须大于等于核心线程数

3. **keepAliveTime（空闲线程存活时间）**

   - 非核心线程空闲后的存活时间
   - 超过这个时间，空闲线程会被销毁
   - 当 allowCoreThreadTimeOut(true) 时，也作用于核心线程

4. **unit（时间单位）**

   - keepAliveTime 的时间单位
   - 可选值：NANOSECONDS、MICROSECONDS、MILLISECONDS、SECONDS 等

5. **workQueue（工作队列）**

   - 存储等待执行的任务的阻塞队列
   - 常用实现：
     - ArrayBlockingQueue：有界队列，FIFO
     - LinkedBlockingQueue：可选有界/无界队列，FIFO
     - SynchronousQueue：不存储元素的阻塞队列
     - PriorityBlockingQueue：优先级队列
     - DelayQueue：延迟队列

6. **threadFactory（线程工厂）**

   - 用于创建新线程的工厂
   - 可以自定义线程的名称、优先级、是否守护线程等
   - 默认使用 Executors.defaultThreadFactory()

7. **handler（拒绝策略）**
   - 当线程池和队列都满了时的处理策略
   - 默认实现：
     - AbortPolicy：抛出 RejectedExecutionException（默认）
     - CallerRunsPolicy：在调用者线程中执行任务
     - DiscardPolicy：直接丢弃任务
     - DiscardOldestPolicy：丢弃队列中最旧的任务

### 0.7.2 线程池的工作流程

^6266c2

1. **提交任务时的处理流程：**

   ```
   1. 活动线程数 < 核心线程数：创建新线程执行任务
   2. 活动线程数 >= 核心线程数：将任务加入工作队列
   3. 工作队列已满：
      - 活动线程数 < 最大线程数：创建新线程执行任务
      - 活动线程数 >= 最大线程数：执行拒绝策略
   ```

2. **线程池的状态：**
   - RUNNING：接受新任务，处理队列中的任务
   - SHUTDOWN：不接受新任务，处理队列中的任务
   - STOP：不接受新任务，不处理队列中的任务
   - TIDYING：所有任务已终止，线程数为 0
   - TERMINATED：terminated() 方法执行完成

### 0.7.3 常用的线程池类型

^25200c

1. **FixedThreadPool**

```java
ExecutorService fixedPool = Executors.newFixedThreadPool(nThreads);
```

- 核心线程数 = 最大线程数
- 使用无界 LinkedBlockingQueue
- 适合需要固定线程数的场景

2. **CachedThreadPool**

```java
ExecutorService cachedPool = Executors.newCachedThreadPool();
```

- 核心线程数 = 0
- 最大线程数 = Integer.MAX_VALUE
- 使用 SynchronousQueue
- 适合执行大量短期异步任务

3. **SingleThreadExecutor**

```java
ExecutorService singlePool = Executors.newSingleThreadExecutor();
```

- 核心线程数 = 最大线程数 = 1
- 使用无界 LinkedBlockingQueue
- 适合需要顺序执行的场景

4. **ScheduledThreadPool**

```java
ScheduledExecutorService scheduledPool = Executors.newScheduledThreadPool(corePoolSize);
```

- 核心线程数固定，最大线程数 = Integer.MAX_VALUE
- 使用 DelayedWorkQueue
- 适合执行定时任务和周期性任务

### 0.7.4 线程池的最佳实践

1. **线程池大小的选择**

   - CPU 密集型任务：线程数 = CPU 核心数 + 1
   - IO 密集型任务：线程数 = CPU 核心数 \* (1 + IO 耗时/CPU 耗时)
   - 混合型任务：根据实际情况测试调整

2. **避免常见问题**

   - 避免使用无界队列，可能导致 OOM
   - 避免提交相互依赖的任务，可能导致死锁
   - 合理设置拒绝策略，避免任务丢失
   - 注意异常处理，避免线程泄露

3. **监控和维护**

   - 定期监控线程池状态
   - 合理设置线程池参数
   - 及时处理拒绝任务
   - 优雅关闭线程池

4. **关闭线程池的方式**

```java
// 温和关闭：等待所有任务完成
executorService.shutdown();

// 强制关闭：立即中断所有任务
executorService.shutdownNow();

// 优雅关闭：等待指定时间
executorService.shutdown();
if (!executorService.awaitTermination(60, TimeUnit.SECONDS)) {
    executorService.shutdownNow();
}
```

