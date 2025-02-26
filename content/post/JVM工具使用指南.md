# 1 JVM工具使用指南

## 1.1 命令行工具

### 1.1.1 jmap（Java Memory Map）

#### 1.1.1.1 功能介绍
- 用于生成堆转储快照（heap dump）
- 查看堆内存使用状况
- 查看对象统计信息
- 查看类加载信息

#### 1.1.1.2 常用命令
```bash
# 查看堆内存使用情况
jmap -heap <pid>

# 生成堆转储文件
jmap -dump:format=b,file=heap.hprof <pid>

# 查看存活对象统计
jmap -histo:live <pid>

# 强制执行垃圾回收
jmap -histo:live <pid>
```

#### 1.1.1.3 使用场景
- 内存泄漏分析
- 内存溢出排查
- 对象分布分析

### 1.1.2 jstack（Java Stack Trace）

#### 1.1.2.1 功能介绍
- 查看线程堆栈信息
- 检测死锁
- 分析线程状态

#### 1.1.2.2 常用命令
```bash
# 打印线程堆栈信息
jstack <pid>

# 打印详细信息，包含锁信息
jstack -l <pid>

# 打印线程同步信息
jstack -F <pid>
```

#### 1.1.2.3 使用场景
- 线程死锁分析
- CPU使用率高排查
- 程序假死分析

### 1.1.3 jstat（JVM Statistics Monitoring Tool）

#### 1.1.3.1 功能介绍
- 监控JVM的类加载、内存、垃圾收集等运行数据
- 实时查看JVM运行状态

#### 1.1.3.2 常用命令
```bash
# 查看GC统计信息，每隔1000ms输出一次
jstat -gcutil <pid> 1000

# 查看类加载统计
jstat -class <pid>

# 查看JIT编译统计
jstat -compiler <pid>
```

#### 1.1.3.3 使用场景
- GC频率监控
- 内存使用趋势分析
- 类加载情况分析

### 1.1.4 jinfo（Java Configuration Info）

#### 1.1.4.1 功能介绍
- 查看JVM的配置参数
- 动态修改部分参数

#### 1.1.4.2 常用命令
```bash
# 查看JVM参数
jinfo <pid>

# 查看某个具体参数
jinfo -flag MaxHeapSize <pid>

# 动态修改参数
jinfo -flag +PrintGC <pid>
```

### 1.1.5 jcmd（Java Command）

#### 1.1.5.1 功能介绍
- 诊断工具的统一入口
- 查看JVM运行时信息
- 执行GC操作
- 生成线程转储和堆转储

#### 1.1.5.2 常用命令
```bash
# 列出所有可用命令
jcmd <pid> help

# 查看JVM版本信息
jcmd <pid> VM.version

# 查看JVM参数
jcmd <pid> VM.flags

# 执行GC
jcmd <pid> GC.run
```

### 1.1.6 jps（Java Process Status）

#### 1.1.6.1 功能介绍
- 列出系统中所有的Java进程
- 显示进程ID和主类名

#### 1.1.6.2 常用命令
```bash
# 列出Java进程
jps

# 显示完整的包名和进程参数
jps -l -v
```

### 1.2.4 JProfiler

#### 1.2.4.1 功能特点
- CPU热点分析
- 内存分配分析
- SQL和NoSQL分析
- 线程和锁分析

#### 1.2.4.2 使用方法
1. 安装JProfiler
2. 配置目标应用
3. 启动分析会话
4. 查看性能数据

### 1.2.5 Arthas

#### 1.2.5.1 功能特点
- 在线诊断工具
- 方法执行监控
- 线程分析
- 类加载分析

#### 1.2.5.2 常用命令
```bash
# 启动Arthas
java -jar arthas-boot.jar

# 查看线程信息
thread

# 监控方法执行
monitor ClassName MethodName

# 查看类加载信息
classloader
```

### 1.2.6 GCViewer

#### 1.2.6.1 功能特点
- GC日志可视化分析
- 内存使用趋势分析
- GC暂停时间分析

#### 1.2.6.2 使用方法
1. 导入GC日志文件
2. 查看GC统计信息
3. 分析内存使用趋势
4. 优化GC参数

## 1.2 可视化工具

### 1.2.1 JVisualVM

#### 1.2.1.1 功能特点
- 内存监控
- CPU分析
- 线程分析
- 堆转储分析

#### 1.2.1.2 使用方法
1. 启动：在JDK的bin目录下执行jvisualvm
2. 连接目标JVM
3. 查看实时监控数据
4. 进行CPU抽样和内存快照分析

### 1.2.2 MAT（Memory Analyzer Tool）

#### 1.2.2.1 功能特点
- 堆转储文件分析
- 内存泄漏检测
- 对象引用链分析

#### 1.2.2.2 使用方法
1. 使用jmap生成堆转储文件
2. 使用MAT打开堆转储文件
3. 分析Leak Suspects（泄漏嫌疑）
4. 查看对象引用树

### 1.2.3 JMC（Java Mission Control）

#### 1.2.3.1 功能特点
- 实时性能监控
- 飞行记录器（JFR）
- 高级事件分析

#### 1.2.3.2 使用方法
1. 启动JMC
2. 连接目标JVM
3. 开启飞行记录
4. 分析性能数据

## 1.3 最佳实践

### 1.3.1 性能分析流程
1. 使用jstat监控GC情况
2. 使用jstack分析线程状态
3. 必要时使用jmap生成堆转储
4. 使用MAT进行深入分析

### 1.3.2 注意事项
- 生产环境慎用jmap dump
- 注意文件权限问题
- 考虑性能影响
- 定期清理转储文件

### 1.3.3 常见问题排查

#### 1.3.3.1 内存泄漏
1. 使用jstat观察GC趋势
2. 使用jmap生成堆转储
3. 使用MAT分析泄漏点

#### 1.3.3.2 CPU过高
1. 使用top定位进程
2. 使用jstack查看线程栈
3. 分析热点方法

#### 1.3.3.3 死锁问题
1. 使用jstack检测死锁
2. 分析锁持有情况
3. 查看线程状态

## 1.4 工具对比

| 工具 | 主要用途 | 适用场景 | 优势 | 劣势 |
|------|---------|----------|------|------|
| jmap | 内存分析 | 内存泄漏 | 功能强大 | 性能影响大 |
| jstack | 线程分析 | 死锁、CPU高 | 信息全面 | 瞬时数据 |
| jstat | GC监控 | 性能监控 | 实时性好 | 数据有限 |
| JVisualVM | 综合分析 | 开发测试 | 可视化好 | 功能一般 |
| MAT | 内存分析 | 泄漏分析 | 分析强大 | 学习成本高 |