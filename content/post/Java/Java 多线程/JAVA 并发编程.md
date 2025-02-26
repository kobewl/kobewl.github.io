---
title: "1 线程基础"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 线程基础

### 1.1.1 线程基础

#### 1.1.1.1 线程生命周期
Java线程的生命周期包含6种状态，由`Thread.State`枚举定义：

1. **NEW**  
   线程被创建但未启动（未调用`start()`方法）。此时线程对象仅完成初始化，未分配系统资源。

2. **RUNNABLE**  
   线程已启动，可能在执行或等待CPU时间片。包含两种子状态：
   - **Ready**：等待操作系统分配CPU资源。
   - **Running**：正在执行线程任务。

3. **BLOCKED**  
   线程因等待获取锁而阻塞（如进入`synchronized`代码块时锁被其他线程占用）。只有获得锁后才能回到RUNNABLE状态。

4. **WAITING**  
   线程主动进入等待状态，需其他线程显式唤醒。常见触发方式：
   - `Object.wait()`（需配合synchronized）
   - `LockSupport.park()`
   - `Thread.join()`等待其他线程终止

5. **TIMED_WAITING**  
   带超时的等待状态，时间到后自动唤醒。触发方式：
   - `Thread.sleep(long)`
   - `Object.wait(long)`
   - `LockSupport.parkNanos()`

6. **TERMINATED**  
   线程已执行完毕或异常终止。此时不可再通过`start()`重启。

**状态转换图**：
```
NEW --start()--> RUNNABLE
RUNNABLE --synchronized竞争失败--> BLOCKED
RUNNABLE --wait()/join()--> WAITING
RUNNABLE --sleep()/wait(timeout)--> TIMED_WAITING
BLOCKED --获取到锁--> RUNNABLE
WAITING --notify()/notifyAll()--> RUNNABLE
TIMED_WAITING --超时/唤醒--> RUNNABLE
RUNNABLE --执行结束--> TERMINATED
```

---

#### 1.1.1.2 线程创建方式
1. **继承Thread类**  
   ```java
   class MyThread extends Thread {
       @Override
       public void run() {
           System.out.println("Thread running");
       }
   }
   new MyThread().start();
   ```
   **缺点**：Java单继承限制，扩展性差。

2. **实现Runnable接口**  
   ```java
   class MyRunnable implements Runnable {
       @Override
       public void run() {
           System.out.println("Runnable running");
       }
   }
   new Thread(new MyRunnable()).start();
   ```
   **优点**：解耦任务与执行，推荐方式。

3. **实现Callable接口**  
   ```java
   class MyCallable implements Callable<String> {
       @Override
       public String call() {
           return "Result";
       }
   }
   FutureTask<String> task = new FutureTask<>(new MyCallable());
   new Thread(task).start();
   System.out.println(task.get());
   ```
   **特点**：支持返回值，可抛出异常，配合`FutureTask`使用。

4. **线程池方式**  
   ```java
   ExecutorService executor = Executors.newFixedThreadPool(4);
   executor.execute(() -> System.out.println("Task executed"));
   executor.shutdown();
   ```
   **优势**：资源复用、控制并发数、管理线程生命周期。

---

#### 1.1.1.3 线程通信方式
1. **volatile**  
   - 保证变量可见性（禁止指令重排）
   - 适用场景：单写多读状态标志
   ```java
   volatile boolean flag = false;
   ```

2. **synchronized**  
   - 互斥锁，保证原子性和可见性
   - 对象锁（实例方法）和类锁（静态方法）
   ```java
   public synchronized void method() {}
   ```

3. **wait/notify**  
   - 经典生产者-消费者模型
   ```java
   synchronized(lock) {
       while(condition) lock.wait();
       // 操作
       lock.notifyAll();
   }
   ```

4. **CountDownLatch**  
   - 等待多个线程完成
   ```java
   CountDownLatch latch = new CountDownLatch(3);
   latch.countDown(); // 子线程调用
   latch.await();     // 主线程等待
   ```

5. **CyclicBarrier**  
   - 多线程相互等待至屏障点
   ```java
   CyclicBarrier barrier = new CyclicBarrier(3, ()->System.out.println("All arrived"));
   barrier.await();
   ```

6. **Semaphore**  
   - 控制并发访问数
   ```java
   Semaphore semaphore = new Semaphore(5);
   semaphore.acquire();
   semaphore.release();
   ```

---

#### 1.1.1.4 实战要点
1. **线程状态监控**  
   - 使用`jstack`或`ThreadMXBean`获取线程快照
   - 监控WAITING/BLOCKED线程比例

2. **线程安全问题排查**  
   - 竞态条件：使用`Atomic`类或同步控制
   - 可见性问题：检查volatile使用

3. **死锁检测与预防**  
   - 检测：`jstack`查看死锁信息
   - 预防：
     - 避免嵌套锁
     - 按固定顺序获取锁
     - 使用`tryLock()`带超时

---

### 1.1.2 线程池

#### 1.1.2.1 核心参数
| 参数 | 说明 |
|------|------|
| corePoolSize | 核心线程数，即使空闲也不会被回收 |
| maximumPoolSize | 最大线程数（包含核心线程） |
| keepAliveTime | 非核心线程空闲存活时间 |
| workQueue | 任务队列（直接影响线程池行为） |
| threadFactory | 定制线程创建（命名、优先级等） |
| handler | 拒绝策略（AbortPolicy/CallerRunsPolicy等） |

---

#### 1.1.2.2 工作原理
1. **任务提交流程**  
   ```
   1. 核心线程未满 → 创建新线程执行
   2. 核心线程已满 → 放入工作队列
   3. 队列已满且线程数 < maximumPoolSize → 创建非核心线程
   4. 队列已满且线程数达到最大值 → 执行拒绝策略
   ```

2. **线程复用机制**  
   通过循环从`workQueue`中获取任务（`getTask()`方法），使用阻塞队列实现线程等待。

3. **任务队列类型**  
   - **LinkedBlockingQueue**：无界队列（可能导致OOM）
   - **ArrayBlockingQueue**：有界队列
   - **SynchronousQueue**：直接传递队列

---

#### 1.1.2.3 常用线程池
| 类型 | 特点 | 风险 |
|------|------|------|
| FixedThreadPool | 固定线程数，无界队列 | 任务堆积导致OOM |
| CachedThreadPool | 弹性线程数，SynchronousQueue | 线程数失控 |
| ScheduledThreadPool | 支持定时任务 | 无界队列风险 |
| SingleThreadExecutor | 单线程顺序执行 | 无界队列风险 |

---

#### 1.1.2.4 实际应用
4. **参数配置**  
   - CPU密集型：corePoolSize = CPU核数 + 1
   - IO密集型：corePoolSize = CPU核数 * 2
   - 动态调整：通过`setCorePoolSize()`方法

5. **监控指标**  
   - 活跃线程数：`getActiveCount()`
   - 队列大小：`getQueue().size()`
   - 任务完成数：`getCompletedTaskCount()`

---

