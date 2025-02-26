---
title: "Java IO"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# Java IO

## 1. IO 体系概述

### 1.1 整体架构

```ascii
Java IO
├── 字节流
│   ├── 输入流 InputStream
│   │   ├── FileInputStream     - 文件输入
│   │   ├── BufferedInputStream - 缓冲输入
│   │   ├── DataInputStream    - 基本类型输入
│   │   └── ObjectInputStream  - 对象输入
│   │
│   └── 输出流 OutputStream
│       ├── FileOutputStream    - 文件输出
│       ├── BufferedOutputStream- 缓冲输出
│       ├── DataOutputStream   - 基本类型输出
│       └── ObjectOutputStream - 对象输出
│
└── 字符流
    ├── 输入流 Reader
    │   ├── FileReader         - 文件读取
    │   ├── BufferedReader     - 缓冲读取
    │   └── InputStreamReader  - 字节转字符
    │
    └── 输出流 Writer
        ├── FileWriter         - 文件写入
        ├── BufferedWriter     - 缓冲写入
        └── OutputStreamWriter - 字符转字节
```

### 1.2 字节流与字符流对比

| 特点     | 字节流               | 字符流    |
| -------- | -------------------- | --------- |
| 处理单位 | 8 位字节             | 16 位字符 |
| 适用场景 | 二进制文件（图片等） | 文本文件  |
| 缓冲区   | 无缓冲               | 有缓冲    |
| 编码处理 | 不处理               | 自动处理  |

## 2. 文件操作

### 2.1 File 类基本操作

```java
// 创建 File 对象
File file = new File("test.txt");
File dir = new File("testDir");

// 文件操作
boolean exists = file.exists();        // 检查是否存在
boolean created = file.createNewFile();// 创建新文件
boolean deleted = file.delete();       // 删除文件
long length = file.length();           // 获取文件大小
boolean renamed = file.renameTo(new File("newName.txt")); // 重命名

// 目录操作
boolean mkdir = dir.mkdir();           // 创建目录
String[] files = dir.list();          // 列出文件名
File[] fileObjects = dir.listFiles(); // 列出文件对象
```

### 2.2 文件路径操作

```java
File file = new File("test.txt");

// 路径信息
String path = file.getPath();          // 相对路径
String absPath = file.getAbsolutePath();// 绝对路径
String parent = file.getParent();      // 父目录

// 路径分隔符
String separator = File.separator;      // 系统相关的分隔符
```

## 3. 字节流操作

### 3.1 文件字节流

```java
// 写入文件
try (FileOutputStream fos = new FileOutputStream("test.txt")) {
    String data = "Hello World";
    fos.write(data.getBytes());
} catch (IOException e) {
    e.printStackTrace();
}

// 读取文件
try (FileInputStream fis = new FileInputStream("test.txt")) {
    byte[] buffer = new byte[1024];
    int length;
    while ((length = fis.read(buffer)) != -1) {
        System.out.println(new String(buffer, 0, length));
    }
} catch (IOException e) {
    e.printStackTrace();
}
```

### 3.2 缓冲字节流

```java
// 写入文件（带缓冲）
try (BufferedOutputStream bos = new BufferedOutputStream(
        new FileOutputStream("test.txt"))) {
    String data = "Hello World";
    bos.write(data.getBytes());
} catch (IOException e) {
    e.printStackTrace();
}

// 读取文件（带缓冲）
try (BufferedInputStream bis = new BufferedInputStream(
        new FileInputStream("test.txt"))) {
    byte[] buffer = new byte[1024];
    int length;
    while ((length = bis.read(buffer)) != -1) {
        System.out.println(new String(buffer, 0, length));
    }
} catch (IOException e) {
    e.printStackTrace();
}
```

## 4. 字符流操作

### 4.1 文件字符流

```java
// 写入文件
try (FileWriter writer = new FileWriter("test.txt")) {
    writer.write("Hello World");
} catch (IOException e) {
    e.printStackTrace();
}

// 读取文件
try (FileReader reader = new FileReader("test.txt")) {
    char[] buffer = new char[1024];
    int length;
    while ((length = reader.read(buffer)) != -1) {
        System.out.println(new String(buffer, 0, length));
    }
} catch (IOException e) {
    e.printStackTrace();
}
```

### 4.2 缓冲字符流

```java
// 写入文件（带缓冲）
try (BufferedWriter writer = new BufferedWriter(
        new FileWriter("test.txt"))) {
    writer.write("Hello World");
    writer.newLine();  // 写入换行
} catch (IOException e) {
    e.printStackTrace();
}

// 读取文件（带缓冲）
try (BufferedReader reader = new BufferedReader(
        new FileReader("test.txt"))) {
    String line;
    while ((line = reader.readLine()) != null) {
        System.out.println(line);
    }
} catch (IOException e) {
    e.printStackTrace();
}
```

## 5. 对象序列化

### 5.1 序列化基础

```java
// 定义可序列化的类
public class Person implements Serializable {
    private static final long serialVersionUID = 1L;
    private String name;
    private int age;
    // getter/setter
}

// 序列化对象
try (ObjectOutputStream oos = new ObjectOutputStream(
        new FileOutputStream("person.dat"))) {
    Person person = new Person("Alice", 20);
    oos.writeObject(person);
} catch (IOException e) {
    e.printStackTrace();
}

// 反序列化对象
try (ObjectInputStream ois = new ObjectInputStream(
        new FileInputStream("person.dat"))) {
    Person person = (Person) ois.readObject();
    System.out.println(person);
} catch (IOException | ClassNotFoundException e) {
    e.printStackTrace();
}
```

### 5.2 序列化注意事项

```java
public class SerializationExample {
    // transient 关键字
    private transient String password;  // 不会被序列化

    // 自定义序列化
    private void writeObject(ObjectOutputStream out) throws IOException {
        out.defaultWriteObject();
        // 自定义序列化逻辑
    }

    private void readObject(ObjectInputStream in)
            throws IOException, ClassNotFoundException {
        in.defaultReadObject();
        // 自定义反序列化逻辑
    }
}
```

## 6. NIO

### 6.1 Buffer（缓冲区）

```java
// 创建缓冲区
ByteBuffer buffer = ByteBuffer.allocate(1024);

// 写入数据
buffer.put("Hello".getBytes());

// 切换到读模式
buffer.flip();

// 读取数据
byte[] data = new byte[buffer.limit()];
buffer.get(data);

// 清空缓冲区
buffer.clear();
```

### 6.2 Channel（通道）

```java
// 文件通道
try (FileChannel channel = FileChannel.open(
        Paths.get("test.txt"), StandardOpenOption.READ)) {
    ByteBuffer buffer = ByteBuffer.allocate(1024);
    int length;
    while ((length = channel.read(buffer)) != -1) {
        buffer.flip();
        System.out.println(new String(buffer.array(), 0, length));
        buffer.clear();
    }
} catch (IOException e) {
    e.printStackTrace();
}
```

### 6.3 Selector（选择器）

```java
// 创建选择器
Selector selector = Selector.open();

// 注册通道
ServerSocketChannel serverChannel = ServerSocketChannel.open();
serverChannel.configureBlocking(false);
serverChannel.register(selector, SelectionKey.OP_ACCEPT);

// 选择就绪通道
while (true) {
    int readyChannels = selector.select();
    if (readyChannels == 0) continue;

    Set<SelectionKey> keys = selector.selectedKeys();
    Iterator<SelectionKey> keyIterator = keys.iterator();

    while (keyIterator.hasNext()) {
        SelectionKey key = keyIterator.next();
        if (key.isAcceptable()) {
            // 处理连接就绪事件
        } else if (key.isReadable()) {
            // 处理读就绪事件
        }
        keyIterator.remove();
    }
}
```

## 7. IO 性能优化

### 7.1 使用缓冲

```java
// 不使用缓冲
try (FileInputStream fis = new FileInputStream("big.file")) {
    int b;
    while ((b = fis.read()) != -1) {
        // 处理单字节
    }
}

// 使用缓冲（更高效）
try (BufferedInputStream bis = new BufferedInputStream(
        new FileInputStream("big.file"))) {
    byte[] buffer = new byte[8192];  // 8KB 缓冲区
    int length;
    while ((length = bis.read(buffer)) != -1) {
        // 处理缓冲区数据
    }
}
```

### 7.2 正确关闭资源

```java
// try-with-resources（推荐）
try (FileInputStream fis = new FileInputStream("test.txt");
     BufferedInputStream bis = new BufferedInputStream(fis)) {
    // 使用流
} catch (IOException e) {
    e.printStackTrace();
}

// 传统方式（不推荐）
FileInputStream fis = null;
try {
    fis = new FileInputStream("test.txt");
    // 使用流
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (fis != null) {
        try {
            fis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

