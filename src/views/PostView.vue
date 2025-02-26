<template>
  <div class="post-view">
    <BlogPostDetail :post="post" />
  </div>
</template>

<script>
import BlogPostDetail from '@/components/BlogPostDetail.vue'

export default {
  name: 'PostView',
  components: {
    BlogPostDetail,
  },
  data() {
    return {
      post: null,
    }
  },
  created() {
    // 模拟从API获取数据
    // 实际应用中应从后端API或文件系统获取
    this.fetchPost()
  },
  methods: {
    fetchPost() {
      // 示例数据
      const posts = {
        1: {
          id: '1',
          title: 'Java基础知识',
          date: '2023-01-01',
          category: 'Java',
          tags: ['Java', '编程语言'],
          content: `
# Java基础知识

## 1.1 Java 简介

### 1.1.1 什么是 Java？

Java 的特点：
- 跨平台
- 面向对象
- 简单易学
- 高性能
- 分布式
- 安全性

Java 程序运行过程：
源代码(.java) ──编译──→ 字节码(.class) ──运行──→ 程序结果

### 1.1.2 Java 的优势

- 跨平台: "Write Once, Run Anywhere"
- 面向对象: 封装、继承、多态
- 丰富的API: Java标准库提供了丰富的API
- 强大的开发工具: Eclipse, IntelliJ IDEA等
- 庞大的社区支持: 大量开发者和资源

## 1.2 基本语法

### 1.2.1 数据类型

Java有8种基本数据类型：
- 整数类型：byte, short, int, long
- 浮点类型：float, double
- 字符类型：char
- 布尔类型：boolean

### 1.2.2 变量和常量

变量声明语法：
\`\`\`java
int num = 10;
String name = "Java";
\`\`\`

常量声明语法：
\`\`\`java
final double PI = 3.14159;
\`\`\`

### 1.2.3 控制流程

条件语句：
\`\`\`java
if (condition) {
    // code
} else if (anotherCondition) {
    // code
} else {
    // code
}
\`\`\`

循环语句：
\`\`\`java
// for循环
for (int i = 0; i < 10; i++) {
    System.out.println(i);
}

// while循环
while (condition) {
    // code
}

// do-while循环
do {
    // code
} while (condition);
\`\`\`

## 1.3 面向对象编程

### 1.3.1 类和对象

\`\`\`java
public class Person {
    // 属性
    private String name;
    private int age;
    
    // 构造方法
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // 方法
    public void sayHello() {
        System.out.println("Hello, my name is " + name);
    }
}
\`\`\`

### 1.3.2 封装、继承和多态

封装：使用private、protected、public等访问修饰符控制访问权限

继承：使用extends关键字实现继承
\`\`\`java
public class Student extends Person {
    private String studentId;
    
    public Student(String name, int age, String studentId) {
        super(name, age);
        this.studentId = studentId;
    }
}
\`\`\`

多态：父类引用指向子类对象
\`\`\`java
Person person = new Student("Alice", 20, "S12345");
person.sayHello(); // 调用的是Student中重写的sayHello方法
\`\`\`
          `,
        },
        2: {
          id: '2',
          title: 'Java集合',
          date: '2023-01-02',
          category: 'Java',
          tags: ['Java', '集合框架', '数据结构'],
          content: `
# Java集合

Java集合框架为存储和操作数据提供了一系列标准的类和接口。

## Collection接口

Collection是Java集合框架的根接口，定义了操作集合的基本方法。

主要的子接口包括：
- List: 有序集合，允许重复元素
- Set: 不允许重复元素
- Queue: 队列，通常以FIFO(先进先出)方式操作元素

## List接口

List是有序集合，允许重复元素。主要实现类：

### ArrayList

基于动态数组的实现，随机访问效率高，但插入删除效率低。

\`\`\`java
List<String> list = new ArrayList<>();
list.add("Apple");
list.add("Banana");
list.add("Orange");
System.out.println(list.get(1)); // 输出: Banana
\`\`\`

### LinkedList

基于双向链表的实现，随机访问效率低，但插入删除效率高。

\`\`\`java
List<String> linkedList = new LinkedList<>();
linkedList.add("Java");
linkedList.add("Python");
linkedList.addFirst("C++"); // 在头部添加元素
\`\`\`

## Set接口

Set是不允许重复元素的集合。主要实现类：

### HashSet

基于HashMap的实现，无序。

\`\`\`java
Set<String> set = new HashSet<>();
set.add("Apple");
set.add("Banana");
set.add("Apple"); // 重复元素不会被添加
System.out.println(set.size()); // 输出: 2
\`\`\`

### TreeSet

基于红黑树的实现，有序。

\`\`\`java
Set<String> treeSet = new TreeSet<>();
treeSet.add("B");
treeSet.add("A");
treeSet.add("C");
// 输出: [A, B, C] - 按照自然顺序排序
System.out.println(treeSet);
\`\`\`

## Map接口

Map提供了键值对映射。主要实现类：

### HashMap

基于哈希表的实现，无序。

\`\`\`java
Map<String, Integer> map = new HashMap<>();
map.put("Apple", 10);
map.put("Banana", 20);
map.put("Orange", 30);
System.out.println(map.get("Banana")); // 输出: 20
\`\`\`

### TreeMap

基于红黑树的实现，按键排序。

\`\`\`java
Map<String, Integer> treeMap = new TreeMap<>();
treeMap.put("B", 2);
treeMap.put("A", 1);
treeMap.put("C", 3);
// 输出: {A=1, B=2, C=3} - 按键的自然顺序排序
System.out.println(treeMap);
\`\`\`

## 集合框架的工具类

### Collections

提供了一系列静态方法来操作集合。

\`\`\`java
List<String> list = new ArrayList<>();
list.add("C");
list.add("A");
list.add("B");

// 排序
Collections.sort(list);
System.out.println(list); // 输出: [A, B, C]

// 二分查找
int index = Collections.binarySearch(list, "B");
System.out.println(index); // 输出: 1

// 反转
Collections.reverse(list);
System.out.println(list); // 输出: [C, B, A]

// 洗牌
Collections.shuffle(list);
System.out.println(list); // 随机顺序
\`\`\`
          `,
        },
        3: {
          id: '3',
          title: 'Java异常处理',
          date: '2023-01-03',
          category: 'Java',
          tags: ['Java', '异常处理'],
          content: `
# Java异常处理

## 异常概述

异常是程序执行过程中出现的错误或异常情况。Java的异常处理机制可以优雅地处理这些问题。

Java中的异常分为两大类：
1. **检查型异常(Checked Exceptions)**: 必须显式处理的异常
2. **非检查型异常(Unchecked Exceptions)**: 不强制处理的异常

## 异常层次结构

所有异常都继承自java.lang.Throwable类，主要有两个子类：
- **Error**: 严重错误，通常无法恢复
- **Exception**: 程序可以处理的异常

\`\`\`
            Throwable
           /        \\
        Error     Exception
                 /        \\
    RuntimeException     检查型异常
        (非检查型)
\`\`\`

## 异常处理语法

### try-catch-finally

基本语法：

\`\`\`java
try {
    // 可能抛出异常的代码
} catch (ExceptionType1 e1) {
    // 处理ExceptionType1类型的异常
} catch (ExceptionType2 e2) {
    // 处理ExceptionType2类型的异常
} finally {
    // 无论是否发生异常都会执行
}
\`\`\`

示例：

\`\`\`java
try {
    int[] numbers = {1, 2, 3};
    System.out.println(numbers[10]); // 数组越界
} catch (ArrayIndexOutOfBoundsException e) {
    System.out.println("数组越界: " + e.getMessage());
} finally {
    System.out.println("无论是否发生异常，finally块都会执行");
}
\`\`\`

### try-with-resources

Java 7引入的自动资源管理语法：

\`\`\`java
try (Resource resource = new Resource()) {
    // 使用资源的代码
} catch (Exception e) {
    // 异常处理
}
\`\`\`

示例：

\`\`\`java
try (FileReader reader = new FileReader("file.txt");
     BufferedReader br = new BufferedReader(reader)) {
    // 读取文件
    String line;
    while ((line = br.readLine()) != null) {
        System.out.println(line);
    }
} catch (IOException e) {
    System.out.println("文件读取错误: " + e.getMessage());
}
\`\`\`

## 抛出异常

使用throw关键字抛出异常：

\`\`\`java
public void checkAge(int age) {
    if (age < 0) {
        throw new IllegalArgumentException("年龄不能为负数");
    }
}
\`\`\`

使用throws声明方法可能抛出的异常：

\`\`\`java
public void readFile(String filename) throws IOException {
    // 可能抛出IOException的代码
}
\`\`\`

## 自定义异常

创建自定义异常类：

\`\`\`java
public class InsufficientFundsException extends Exception {
    private double amount;
    
    public InsufficientFundsException(double amount) {
        super("余额不足，还需 " + amount + " 元");
        this.amount = amount;
    }
    
    public double getAmount() {
        return amount;
    }
}
\`\`\`

使用自定义异常：

\`\`\`java
public class Account {
    private double balance;
    
    public void withdraw(double amount) throws InsufficientFundsException {
        if (amount > balance) {
            double needs = amount - balance;
            throw new InsufficientFundsException(needs);
        }
        
        balance -= amount;
    }
}
\`\`\`

## 最佳实践

1. 只捕获可以处理的异常
2. 不要在finally块中使用return语句
3. 使用具体的异常类型而不是通用的Exception
4. 记录异常信息以便调试
5. 关闭资源优先使用try-with-resources
6. 不要忽略异常（空catch块）
          `,
        },
      }

      const postId = this.$route.params.id
      this.post = posts[postId]

      if (!this.post) {
        // 处理文章不存在的情况
        console.error('文章不存在')
      }
    },
  },
}
</script>

<style scoped>
.post-view {
  min-height: 100vh;
}
</style>
