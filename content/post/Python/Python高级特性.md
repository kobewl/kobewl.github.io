---
title: "Python 高级特性"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# Python 高级特性

## 一、装饰器（Decorators）
### 1. 基本概念

- 装饰器定义
  - 是一个可调用对象（函数或类）
  - 用于修改或增强其他函数或类的功能
  - 不改变原函数的源代码

- 装饰器语法
  ```python
  def decorator(func):
      def wrapper(*args, **kwargs):
          # 在函数执行前的操作
          result = func(*args, **kwargs)
          # 在函数执行后的操作
          return result
      return wrapper

  @decorator
  def function():
      pass
  ```

### 2. 常见应用场景

- 日志记录
  ```python
  def log_decorator(func):
      def wrapper(*args, **kwargs):
          print(f"Calling {func.__name__}")
          result = func(*args, **kwargs)
          print(f"{func.__name__} finished")
          return result
      return wrapper

  @log_decorator
  def greet(name):
      print(f"Hello, {name}!")
  ```

- 性能计时
  ```python
  import time

  def timer_decorator(func):
      def wrapper(*args, **kwargs):
          start = time.time()
          result = func(*args, **kwargs)
          end = time.time()
          print(f"{func.__name__} took {end - start} seconds")
          return result
      return wrapper
  ```

## 二、生成器（Generators）
### 1. 基本概念

- 生成器定义
  - 一种特殊的迭代器
  - 使用yield语句生成值
  - 节省内存空间

- 生成器语法
  ```python
  def generator_function():
      for i in range(10):
          yield i

  # 使用生成器表达式
  gen = (x for x in range(10))
  ```

### 2. 实现原理

- yield机制
  - 保存函数执行状态
  - 暂停和恢复执行
  - 惰性计算

- 示例代码
  ```python
  def fibonacci():
      a, b = 0, 1
      while True:
          yield a
          a, b = b, a + b

  # 使用生成器
  fib = fibonacci()
  for _ in range(10):
      print(next(fib))
  ```

## 三、迭代器（Iterators）
### 1. 基本概念

- 迭代器协议
  - __iter__() 方法
  - __next__() 方法
  - StopIteration 异常

- 实现示例
  ```python
  class Counter:
      def __init__(self, start, end):
          self.start = start
          self.end = end
      
      def __iter__(self):
          return self
      
      def __next__(self):
          if self.start >= self.end:
              raise StopIteration
          self.start += 1
          return self.start - 1
  ```

## 四、上下文管理器（Context Managers）
### 1. 基本概念

- with语句
  - 自动管理资源
  - 确保资源正确释放

- 实现方法
  ```python
  class FileManager:
      def __init__(self, filename):
          self.filename = filename
      
      def __enter__(self):
          self.file = open(self.filename, 'r')
          return self.file
      
      def __exit__(self, exc_type, exc_val, exc_tb):
          self.file.close()

  # 使用上下文管理器
  with FileManager('file.txt') as f:
      content = f.read()
  ```

### 2. contextlib模块

- @contextmanager装饰器
  ```python
  from contextlib import contextmanager

  @contextmanager
  def timer():
      start = time.time()
      yield
      end = time.time()
      print(f"Elapsed time: {end - start}")

  with timer():
      # 执行一些操作
      time.sleep(1)
  ```

## 五、属性装饰器（Property Decorators）
### 1. @property

- 将方法转换为属性
- 实现getter和setter

```python
class Person:
    def __init__(self, name):
        self._name = name

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, value):
        if not isinstance(value, str):
            raise TypeError("Name must be a string")
        self._name = value
```

## 六、描述符（Descriptors）
### 1. 基本概念

- 描述符协议
  - __get__()
  - __set__()
  - __delete__()

```python
class TypedProperty:
    def __init__(self, type):
        self.type = type
        self.name = None

    def __get__(self, instance, owner):
        return instance.__dict__[self.name]

    def __set__(self, instance, value):
        if not isinstance(value, self.type):
            raise TypeError(f"Expected {self.type}")
        instance.__dict__[self.name] = value

class Person:
    name = TypedProperty(str)
    age = TypedProperty(int)
```

## 七、元类（Metaclasses）
### 1. 基本概念

- 类的类
- 控制类的创建过程
- 实现类的自动注册

```python
class MetaClass(type):
    def __new__(cls, name, bases, attrs):
        # 在类创建时修改类的属性
        return super().__new__(cls, name, bases, attrs)

class MyClass(metaclass=MetaClass):
    pass
```

## 八、最佳实践

1. 装饰器
   - 保持简单，专注于单一功能
   - 使用functools.wraps保留原函数信息
   - 考虑参数化装饰器

2. 生成器
   - 处理大数据集时优先使用
   - 注意生成器的一次性特性
   - 合理使用send()和throw()方法

3. 迭代器
   - 实现__iter__和__next__方法
   - 适当抛出StopIteration异常
   - 考虑使用itertools模块

4. 上下文管理器
   - 资源管理场景优先使用
   - 正确处理异常
   - 使用contextlib简化实现
