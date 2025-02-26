---
title: "1 Java 基础知识"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Java 基础知识

## 1.1 Java 简介

### 1.1.1 什么是 Java？

```ascii
Java 的特点：
┌──────────────────────────┐
│ Write Once, Run Anywhere │
└──────────────────────────┘
     ↓            ↓
  跨平台       一次编写
     ↓            ↓
[Windows/Linux/Mac OS...]

Java 程序运行过程：
源代码(.java) ──编译──→ 字节码(.class) ──运行──→ 程序结果
                javac              java
```

### 1.1.2 Java 的优势

1. **跨平台性**

   - JVM 提供统一运行环境
   - 不同系统使用相同代码

2. **面向对象**

   - 封装、继承、多态
   - 易维护、易复用

3. **安全性**
   - 强类型语言
   - 异常处理机制
   - 安全管理器

## 1.2 基本语法

### 1.2.1 数据类型

```ascii
Java 数据类型：
┌─────────────┐
│  基本类型     |
├─────────────┤      ————————————
│ byte(1字节) │      │  包装类   │
│ short(2字节)│ ────→│ Byte      │
│ int(4字节)  │      │ Short     │
│ long(8字节) │      │ Integer   │
│ float(4字节)│      │ Long      │
│ double(8字节)│     │ Float     │
│ char(2字节) │      │ Double    │
│ boolean(1位)│      │ Character │
└─────────────┘      │ Boolean   │
                     └───────────┘
```

### 1.2.2 变量与常量

```java
// 1. 变量声明和初始化
int number = 10;            // 声明并初始化
final double PI = 3.14159;  // 常量声明

// 2. 变量命名规则
studentName    // 驼峰命名法
MAX_VALUE      // 常量全大写
_privateVar    // 私有变量前导下划线
```

### 1.2.3 运算符

```ascii
运算符优先级：
高  ┌─────────────┐
    │ ()          │ 括号
    │ ++ -- !     │ 一元运算符
    │ * / %       │ 乘除
    │ + -         │ 加减
    │ > >= < <=   │ 比较
    │ == !=       │ 相等
    │ &&          │ 与
    │ ||          │ 或
低  │ = += -= etc │ 赋值
    └─────────────┘
```

## 1.3 流程控制

### 1.3.1 条件语句

```java
// 1. if-else
if (condition) {
    // 代码块
} else if (condition2) {
    // 代码块
} else {
    // 代码块
}

// 2. switch
switch (variable) {
    case value1:
        // 代码块
        break;
    case value2:
        // 代码块
        break;
    default:
        // 默认代码块
}
```

### 1.3.2 循环语句

```ascii
循环结构：
┌──────────────┐
│ for 循环     │──→ 知道循环次数
│ while 循环   │──→ 不知道循环次数
│ do-while 循环│──→ 至少执行一次
└──────────────┘
```

```java
// 1. for 循环
for (int i = 0; i < 10; i++) {
    System.out.println(i);
}

// 2. while 循环
while (condition) {
    // 代码块
}

// 3. do-while 循环
do {
    // 代码块
} while (condition);
```

## 1.4 数组

### 1.4.1 数组定义和使用

```java
// 1. 数组声明
int[] numbers = new int[5];
int[] numbers = {1, 2, 3, 4, 5};

// 2. 多维数组
int[][] matrix = new int[3][4];
int[][] matrix = {{1,2,3}, {4,5,6}};
```

### 1.4.2 数组操作

```ascii
数组常见操作：
┌─────────────┐
│ 遍历        │──→ for/foreach
│ 查找        │──→ Arrays.binarySearch()
│ 排序        │──→ Arrays.sort()
│ 复制        │──→ Arrays.copyOf()
└─────────────┘
```

## 1.5 面向对象基础

### 1.5.1 类和对象

```java
public class Student {
    // 属性
    private String name;
    private int age;

    // 构造方法
    public Student(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // getter/setter 方法
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
```

### 1.5.2 三大特性

```ascii
面向对象三大特性：

1. 封装
┌─────────────┐
│ private 属性 │
│ public 方法  │
└─────────────┘

2. 继承
┌─────────┐
│  父类   │
└────┬────┘
     │
┌────┴────┐
│  子类   │
└─────────┘

3. 多态
方法重写和重载
父类引用指向子类对象

访问修饰符：
┌─────────────┬───────┬───────┬───────┬───────┐
│ 修饰符      │ 类内部│ 同包  │ 子类  │ 其他包│
├─────────────┼───────┼───────┼───────┼───────┤
│ private     │   √   │   ×   │   ×   │   ×   │
│ default     │   √   │   √   │   ×   │   ×   │
│ protected   │   √   │   √   │   √   │   ×   │
│ public      │   √   │   √   │   √   │   √   │
└─────────────┴───────┴───────┴───────┴───────┘
```

## 1.6 异常处理

### 1.6.1 异常体系

```ascii
Throwable
├── Error
└── Exception
    ├── RuntimeException
    │   ├── NullPointerException
    │   ├── ArrayIndexOutOfBoundsException
    │   └── ...
    └── IOException
        ├── FileNotFoundException
        └── ...
```

### 1.6.2 异常处理方式

```java
// 1. try-catch-finally
try {
    // 可能抛出异常的代码
} catch (Exception e) {
    // 异常处理代码
} finally {
    // 总是执行的代码
}

// 2. throws 声明
public void method() throws Exception {
    // 方法体
}
```

## 1.7 编码规范

### 1.7.1 命名规范

```ascii
命名规范：
┌─────────────┐
│ 类名        │──→ 首字母大写 (Student)
│ 方法名      │──→ 驼峰命名 (getName)
│ 变量名      │──→ 驼峰命名 (firstName)
│ 常量名      │──→ 全大写下划线 (MAX_VALUE)
│ 包名        │──→ 全小写 (com.example)
└─────────────┘
```

### 1.7.2 代码格式

1. **缩进与空格**

   - 使用 4 个空格缩进
   - 运算符两边加空格
   - 方法之间加空行

2. **注释规范**
   - 类注释：说明类的用途
   - 方法注释：说明参数和返回值
   - 关键代码注释：说明实现逻辑

# 2 基本数据类型

## 2.1 基本数据类型分类

### 2.1.1 整数类型

```ascii
整数类型范围：
┌─────────────┬────────────┬─────────────────────┐
│ 类型        │ 字节数     │ 取值范围            │
├─────────────┼────────────┼─────────────────────┤
│ byte        │ 1字节      │ -128 到 127         │
│ short       │ 2字节      │ -32768 到 32767     │
│ int         │ 4字节      │ -2^31 到 2^31-1     │
│ long        │ 8字节      │ -2^63 到 2^63-1     │
└─────────────┴────────────┴─────────────────────┘

使用场景：
- byte：处理二进制数据流
- short：节省内存的小范围数值
- int：最常用的整数类型
- long：大数值如时间戳
```

### 2.1.2 浮点类型

````ascii
浮点类型特点：
┌─────────────┬────────────┬─────────────────────┐
│ 类型        │ 字节数     │ 精度                │
├─────────────┼────────────┼─────────────────────┤
│ float       │ 4字节      │ 7位有效数字         │
│ double      │ 8字节      │ 15位有效数字        │
└─────────────┴────────────┴─────────────────────┘

精度问题处理：
```java
// 不要直接比较浮点数
double a = 0.1 + 0.2;
double b = 0.3;
System.out.println(a == b);  // false

// 使用 BigDecimal 处理精确计算
BigDecimal a = new BigDecimal("0.1");
BigDecimal b = new BigDecimal("0.2");
BigDecimal c = a.add(b);     // 精确计算
````

### 2.1.3 字符类型

- char: 2 字节，存储 Unicode 字符
- 取值范围：\u0000 到 \uffff（0 到 65535）

```java
// Unicode 编码示例
char c1 = 'A';           // 字符字面量
char c2 = '\u0041';      // Unicode 编码
char c3 = 65;           // 十进制编码

// 转义字符
char newLine = '\n';     // 换行
char tab = '\t';         // 制表符
char quote = '\'';       // 单引号
```

### 2.1.4 布尔类型

- boolean: 只有 true 和 false 两个值
- 在 JVM 中实际占用大小依赖于具体实现

```java
// 条件判断
boolean flag = true;
if (flag) {
    // 执行代码
}

// 逻辑运算
boolean a = true, b = false;
boolean and = a && b;    // 短路与
boolean or = a || b;     // 短路或
boolean not = !a;        // 取反
```

## 2.2 类型转换

### 2.2.1 自动类型转换

```ascii
自动类型转换方向：
byte → short → int → long → float → double
              ↗
            char

注意事项：
1. 小类型向大类型转换是安全的
2. char 可以安全转换为 int 及更大类型
3. 整型转浮点型可能损失精度
```

### 2.2.2 强制类型转换

```java
// 基本强制转换
double d = 3.14;
int i = (int) d;    // i = 3，小数部分被截断

// 可能溢出的转换
long bigNum = 1234567890L;
int smallNum = (int) bigNum;  // 可能溢出

// 处理精度损失
double price = 100.123;
long cents = Math.round(price * 100);  // 四舍五入
```

## 2.3 包装类

### 2.3.1 自动装箱与拆箱

```java
// 自动装箱
Integer num = 100;                  // Integer.valueOf(100)
Boolean flag = true;                // Boolean.valueOf(true)

// 自动拆箱
int value = num;                    // num.intValue()
boolean b = flag;                   // flag.booleanValue()

// 性能考虑
Integer sum = 0;
for (int i = 0; i < 1000; i++) {
    sum += i;  // 每次都会创建新对象，影响性能
}
```

### 2.3.2 缓存机制

```java
// Integer 缓存范围：-128 到 127
Integer a = 127;
Integer b = 127;
System.out.println(a == b);      // true

Integer c = 128;
Integer d = 128;
System.out.println(c == d);      // false

// Character 缓存范围：0 到 127
// Boolean 缓存：true 和 false
```

### 2.3.3 常用方法

```java
// 字符串转换
String numStr = "123";
int num = Integer.parseInt(numStr);        // 字符串转整数
double d = Double.parseDouble("3.14");     // 字符串转浮点数
String binary = Integer.toBinaryString(10); // 转二进制字符串

// 值比较
Integer x = 100;
Integer y = 200;
System.out.println(x.compareTo(y));        // 比较大小

// 常量获取
System.out.println(Integer.MAX_VALUE);     // 最大值
System.out.println(Integer.MIN_VALUE);     // 最小值
System.out.println(Double.POSITIVE_INFINITY); // 正无穷
```

# 3 String 相关

## 3.1 String 特性

^497c70

1. **不可变性**

   - String 对象一旦创建，内容不可改变
   - 所有修改操作都会创建新的 String 对象
   - 线程安全，可以在多线程环境下安全使用
   - final 修饰的好处：
     - 缓存哈希值，提高性能
     - 线程安全，无需同步
     - 字符串常量池优化
   - 实现原理：
     - 内部字符数组被 final 修饰
     - 没有提供修改内部状态的方法
     - 所有修改操作都会返回新对象

2. **线程安全性**

   - 并发访问安全：
     - 不可变对象天生线程安全
     - 无需额外同步措施
     - 可以安全地在多个线程间共享
   - 性能优势：
     - 避免同步开销
     - 适合作为缓存对象
     - 适合作为常量使用

3. **字符串常量池**

   ```ascii
   字符串池工作原理：
   ┌─────────────────────────────┐
   │     String Pool             │
   │  ┌──────┐  ┌──────┐        │
   │  │"abc" │  │"def" │        │
   │  └──────┘  └──────┘        │
   └─────────────────────────────┘

   String s1 = "abc";  // 使用池中对象
   String s2 = new String("abc");  // 创建新对象
   ```

   - 实现原理：
     - 存储在运行时常量池中
     - 使用 flyweight 模式
     - 节省内存空间
   - 内存管理[[内存区域与内存管理]]：
     - JVM 启动时创建
     - 存储在方法区（JDK 7 之前）
     - 存储在堆中（JDK 7 之后）
   - 垃圾回收：
     - 常量池中的字符串可以被回收
     - 遵循可达性分析
     - intern() 方法的影响

## 3.2 String 常用方法

### 3.2.1 基本操作

```java
String str = "Hello World";

// 长度和判空
int length = str.length();           // 字符串长度
boolean isEmpty = str.isEmpty();     // 是否为空
boolean isBlank = str.isBlank();    // 是否为空白字符

// 字符访问
char first = str.charAt(0);          // 获取字符
char[] chars = str.toCharArray();    // 转换为字符数组

// 查找方法
int index = str.indexOf("World");    // 查找子串
int last = str.lastIndexOf('o');     // 最后出现位置
boolean contains = str.contains("Hello"); // 包含判断
```

### 3.2.2 字符串变换

```java
String str = "Hello World";

// 大小写转换
String upper = str.toUpperCase();    // 转大写
String lower = str.toLowerCase();    // 转小写

// 去除空白
String trimmed = str.trim();         // 去除两端空白
String stripped = str.strip();       // 去除 Unicode 空白

// 替换操作
String replaced = str.replace('l', 'L');     // 替换字符
String replacedAll = str.replaceAll("\\s+", "-"); // 正则替换
```

### 3.2.3 字符串分割与合并

```java
// 分割字符串
String text = "apple,banana,orange";
String[] fruits = text.split(",");   // 使用逗号分割

// 字符串合并
String joined = String.join("-", fruits);    // 使用连字符合并
String concat = "Hello".concat(" World");    // 连接字符串

// 格式化字符串
String formatted = String.format("Hello, %s!", "Java");
```

## 3.3 字符串比较

### 3.3.1 equals 和 ==

```java
String s1 = "Hello";
String s2 = "Hello";
String s3 = new String("Hello");

// == 比较引用
System.out.println(s1 == s2);        // true（字符串池）
System.out.println(s1 == s3);        // false（不同对象）

// equals 比较内容
System.out.println(s1.equals(s3));   // true
System.out.println(s1.equalsIgnoreCase("HELLO")); // true
```

### 3.3.2 比较排序

```java
String str1 = "apple";
String str2 = "banana";

// 比较大小
int result = str1.compareTo(str2);   // 负数，str1 < str2
int ignoreCase = str1.compareToIgnoreCase("APPLE"); // 0，相等

// 字典序排序
String[] words = {"banana", "apple", "orange"};
Arrays.sort(words);  // 按字母顺序排序
```

## 3.4 性能优化

### 3.4.1 最佳实践

1. **选择合适的工具**

   - 单线程用 StringBuilder ^c4bcbb
   - 多线程用 StringBuffer ^1343ce
   - 简单字符串连接用 +
   - 大量操作时使用 StringBuilder

2. **避免频繁修改**

   ```java
   // 错误示例
   String result = "";
   for (int i = 0; i < 1000; i++) {
       result += i;  // 每次都创建新对象
   }

   // 正确示例
   StringBuilder sb = new StringBuilder();
   for (int i = 0; i < 1000; i++) {
       sb.append(i);
   }
   String result = sb.toString();
   ```

### 3.4.2 StringBuilder vs StringBuffer

^9211a3

```ascii
性能对比：
┌─────────────┬────────────┬─────────────┐
│ 类型        │ 线程安全   │ 性能        │
├─────────────┼────────────┼─────────────┤
│ StringBuilder│    否     │ 最快        │
│ StringBuffer │    是     │ 较快        │
│ String      │    是     │ 最慢        │
└─────────────┴────────────┴─────────────┘
```

```java
// StringBuilder 示例
StringBuilder builder = new StringBuilder();
builder.append("Hello")
       .append(" ")
       .append("World");
String result = builder.toString();

// StringBuffer 示例（线程安全）
StringBuffer buffer = new StringBuffer();
buffer.append("Hello")
      .append(" ")
      .append("World");
String result2 = buffer.toString();
```

### 3.4.3 内存优化

```java
// 1. 重用 StringBuilder
StringBuilder sb = new StringBuilder(1000); // 预分配容量

// 2. 使用字符串池
String pooled = "Hello".intern();

// 3. 及时释放不用的字符串
StringBuilder sb = null; // 帮助GC回收

// 4. 使用字符数组处理大量字符
char[] buffer = new char[1000];
// 处理完后及时清空
Arrays.fill(buffer, '\0');
```

## 3.5 String、StringBuilder和StringBuffer的区别

### 3.5.1 基本特性对比

```ascii
特性对比：
┌─────────────┬────────────┬─────────────┬─────────────┐
│   特性      │  String    │StringBuilder│StringBuffer │
├─────────────┼────────────┼─────────────┼─────────────┤
│ 可变性      │  不可变    │    可变     │    可变     │
│ 线程安全    │    是      │     否      │     是      │
│ 性能        │   最低     │    最高     │    中等     │
│ 内存占用    │   较高     │    较低     │    较低     │
└─────────────┴────────────┴─────────────┴─────────────┘
```

### 3.5.2 使用场景

1. **String适用场景**
   - 字符串内容不经常变化
   - 被多个线程共享访问
   - 作为常量使用
   ```java
   String name = "Java";
   String constant = "PI=" + 3.14159;  // 编译时优化
   ```

2. **StringBuilder适用场景**
   - 字符串经常修改
   - 单线程环境
   - 对性能要求较高
   ```java
   StringBuilder builder = new StringBuilder();
   for (int i = 0; i < 1000; i++) {
       builder.append(i);
   }
   ```

3. **StringBuffer适用场景**
   - 字符串经常修改
   - 多线程环境
   - 需要线程安全保证
   ```java
   StringBuffer buffer = new StringBuffer();
   // 多线程环境下安全
   buffer.append("Thread").append(Thread.currentThread().getId());
   ```

### 3.5.3 内部实现区别

1. **String的实现**
   ```ascii
   String内部结构：
   ┌─────────────────────┐
   │    String对象       │
   ├─────────────────────┤
   │ private final byte[]│◄── 不可变的字符数组
   │ private final int   │◄── 编码标记
   └─────────────────────┘
   ```

2. **StringBuilder和StringBuffer的实现**
   ```ascii
   可变字符串实现：
   ┌─────────────────────┐
   │StringBuilder/Buffer │
   ├─────────────────────┤
   │ byte[]             │◄── 可变的字符数组
   │ int count          │◄── 实际字符数
   └─────────────────────┘
   ```

### 3.5.4 线程安全性分析

```ascii
线程安全性比较：
┌─────────────┬──────────────────────────┐
│  String     │ 不可变对象，天生线程安全         │
├─────────────┼──────────────────────────┤
│StringBuilder│ 非线程安全，但单线程性能最佳     │
├─────────────┼──────────────────────────┤
│StringBuffer │ 使用synchronized关键字保证线程安全│
└─────────────┴──────────────────────────┘
```

### 3.5.5 最佳实践建议

1. **选择原则**
   - 优先使用String（不可变性是优势时）
   - 单线程下，字符串频繁修改用StringBuilder
   - 多线程下，字符串频繁修改用StringBuffer

2. **性能优化建议**
   ```java
   // 1. 预分配容量，避免扩容
   StringBuilder sb = new StringBuilder(1000);
   
   // 2. 明确线程安全需求
   // 非线程安全场景
   StringBuilder builder = new StringBuilder();
   // 线程安全场景
   StringBuffer buffer = new StringBuffer();
   
   // 3. 链式调用提高代码可读性
   StringBuilder result = new StringBuilder()
       .append("Hello")
       .append(" ")
       .append("World");
   ```

