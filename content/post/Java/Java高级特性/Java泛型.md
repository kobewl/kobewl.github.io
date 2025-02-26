---
title: "Java泛型详解"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# Java泛型详解

## 1. 泛型基础

### 1.1 什么是泛型？
1. **定义**
   - 泛型是Java 5引入的特性
   - 允许在定义类、接口和方法时使用类型参数
   - 提供编译时类型安全检查机制

2. **作用**
   - 消除类型转换
   - 提供编译时类型安全性
   - 实现通用算法

3. **优势**
   - 类型安全
   - 消除强制类型转换
   - 提高代码重用性
   - 支持泛型算法实现

### 1.2 泛型类型参数命名约定
- T：Type（类型）
- E：Element（元素）
- K：Key（键）
- V：Value（值）
- N：Number（数值类型）
- ？：表示不确定的类型

## 2. 泛型类

### 2.1 泛型类定义
```java
public class Box<T> {
    private T t;
    
    public void set(T t) {
        this.t = t;
    }
    
    public T get() {
        return t;
    }
}
```

### 2.2 泛型类使用
```java
// 创建Integer类型的Box
Box<Integer> intBox = new Box<>();
intBox.set(10);

// 创建String类型的Box
Box<String> stringBox = new Box<>();
stringBox.set("Hello Generic");
```

### 2.3 多类型参数
```java
public class Pair<K, V> {
    private K key;
    private V value;
    
    public Pair(K key, V value) {
        this.key = key;
        this.value = value;
    }
    
    // getter和setter方法
}
```

## 3. 泛型方法

### 3.1 泛型方法定义
```java
public class GenericMethod {
    public <T> void printArray(T[] array) {
        for (T element : array) {
            System.out.print(element + " ");
        }
        System.out.println();
    }
    
    public <T> T getFirst(T[] array) {
        if (array != null && array.length > 0) {
            return array[0];
        }
        return null;
    }
}
```

### 3.2 泛型方法调用
```java
GenericMethod gm = new GenericMethod();
Integer[] integers = {1, 2, 3, 4, 5};
String[] strings = {"Hello", "Generic", "Method"};

gm.printArray(integers); // 1 2 3 4 5
gm.printArray(strings);  // Hello Generic Method
```

## 4. 类型擦除

### 4.1 概念
- Java的泛型是通过类型擦除实现的
- 在编译时，所有泛型类型都会被擦除
- 替换为原始类型（raw type）

### 4.2 类型擦除规则
1. **替换为原始类型**
   ```java
   // 编译前
   public class Box<T> {
       private T t;
   }
   
   // 编译后
   public class Box {
       private Object t;
   }
   ```

2. **添加类型转换**
   - 编译器在必要时添加类型转换代码
   - 确保类型安全

### 4.3 类型擦除的局限性
1. **不能创建泛型数组**
   ```java
   // 错误
   T[] array = new T[10];
   
   // 正确
   T[] array = (T[]) new Object[10];
   ```

2. **无法使用instanceof运算符**
   ```java
   // 错误
   if (obj instanceof List<String>) { }
   
   // 正确
   if (obj instanceof List) { }
   ```

## 5. 泛型通配符

### 5.1 无界通配符（?）
```java
public void printList(List<?> list) {
    for (Object elem : list) {
        System.out.print(elem + " ");
    }
}
```

### 5.2 上界通配符（extends）
```java
public double sumOfList(List<? extends Number> list) {
    double sum = 0.0;
    for (Number n : list) {
        sum += n.doubleValue();
    }
    return sum;
}
```

### 5.3 下界通配符（super）
```java
public void addNumbers(List<? super Integer> list) {
    for (int i = 1; i <= 5; i++) {
        list.add(i);
    }
}
```

## 6. 泛型约束

### 6.1 类型参数约束
```java
public class NumberBox<T extends Number> {
    private T number;
    
    public double square() {
        return number.doubleValue() * number.doubleValue();
    }
}
```

### 6.2 多重边界
```java
public class DataProcessor<T extends Number & Comparable<T>> {
    public T findMax(T[] array) {
        if (array == null || array.length == 0) {
            return null;
        }
        
        T max = array[0];
        for (T item : array) {
            if (item.compareTo(max) > 0) {
                max = item;
            }
        }
        return max;
    }
}
```

## 7. 最佳实践

### 7.1 设计原则
1. **优先使用泛型集合**
   ```java
   // 推荐
   List<String> list = new ArrayList<>();
   
   // 不推荐
   List list = new ArrayList();
   ```

2. **明确的类型参数**
   ```java
   // 推荐
   Map<String, List<Integer>> map = new HashMap<>();
   
   // 不推荐
   Map map = new HashMap();
   ```

### 7.2 PECS原则
- Producer Extends, Consumer Super
- 当需要从泛型类读取时，使用extends
- 当需要向泛型类写入时，使用super

```java
// Producer - 使用extends
public void printNumbers(List<? extends Number> list) {
    for (Number n : list) {
        System.out.println(n);
    }
}

// Consumer - 使用super
public void addIntegers(List<? super Integer> list) {
    list.add(42);
}
```

### 7.3 常见错误避免
1. **原始类型使用**
   ```java
   // 错误
   List list = new ArrayList();
   list.add("hello");
   Integer num = (Integer) list.get(0); // 运行时异常
   
   // 正确
   List<String> list = new ArrayList<>();
   list.add("hello");
   String str = list.get(0); // 安全
   ```

2. **泛型数组**
   ```java
   // 错误
   List<String>[] array = new List<String>[10];
   
   // 正确
   List<String>[] array = new List[10]; // 使用原始类型创建数组
   ```

## 8. 实际应用场景

### 8.1 通用数据结构
```java
public class Stack<T> {
    private List<T> items = new ArrayList<>();
    
    public void push(T item) {
        items.add(item);
    }
    
    public T pop() {
        if (items.isEmpty()) {
            throw new EmptyStackException();
        }
        return items.remove(items.size() - 1);
    }
}
```

### 8.2 通用算法实现
```java
public class Algorithms {
    public static <T extends Comparable<T>> T findMax(List<T> list) {
        if (list == null || list.isEmpty()) {
            return null;
        }
        
        T max = list.get(0);
        for (T item : list) {
            if (item.compareTo(max) > 0) {
                max = item;
            }
        }
        return max;
    }
}
```

### 8.3 缓存实现
```java
public class Cache<K, V> {
    private Map<K, V> cache = new HashMap<>();
    
    public void put(K key, V value) {
        cache.put(key, value);
    }
    
    public V get(K key) {
        return cache.get(key);
    }
    
    public boolean contains(K key) {
        return cache.containsKey(key);
    }
}
```

## 9. 高级主题

### 9.1 泛型与反射
```java
public class ReflectionUtil {
    public static <T> T getInstance(Class<T> clazz) throws Exception {
        return clazz.getDeclaredConstructor().newInstance();
    }
    
    public static <T> List<T> createList(Class<T> clazz) {
        return new ArrayList<T>();
    }
}
```

### 9.2 泛型与注解
```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface Constraint<T> {
    Class<T> type();
}
```

### 9.3 递归类型限定
```java
public class ComparableBox<T extends Comparable<T>> {
    private T value;
    
    public ComparableBox(T value) {
        this.value = value;
    }
    
    public boolean isGreaterThan(ComparableBox<T> other) {
        return value.compareTo(other.value) > 0;
    }
}
```

## 10. 性能考虑

### 10.1 装箱和拆箱
- 使用基本类型的包装类作为类型参数时要注意装箱和拆箱的性能开销
- 在性能关键的场景，考虑使用基本类型数组而不是泛型集合

### 10.2 内存使用
- 泛型不会增加运行时的内存开销
- 类型擦除确保了泛型与非泛型代码具有相同的内存布局

### 10.3 编译时开销
- 泛型会增加编译时的开销
- 类型检查和类型推断需要额外的编译时间

## 11. 总结

### 11.1 核心要点
1. 泛型提供了编译时类型安全性
2. 通过类型擦除实现
3. 支持泛型类、泛型方法和泛型接口
4. 提供了通配符用于类型限定
5. 遵循PECS原则可以更好地使用泛型

### 11.2 使用建议
1. 优先使用泛型而不是原始类型
2. 明确指定类型参数
3. 注意类型擦除的限制
4. 合理使用通配符
5. 遵循最佳实践原则

### 11.3 注意事项
1. 不能创建泛型数组
2. 不能使用基本类型作为类型参数
3. 静态上下文中不能使用类型参数
4. 注意类型擦除带来的限制
