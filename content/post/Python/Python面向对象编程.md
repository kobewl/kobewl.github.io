---
title: "1 Python 面向对象编程"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Python 面向对象编程

## 1.1 一、类和对象基础

### 1.1.1 类的定义

- 类的基本语法
  ```python
  class ClassName:
      # 类属性
      class_attribute = value
      
      # 构造方法
      def __init__(self, params):
          # 实例属性
          self.instance_attribute = params
      
      # 实例方法
      def method(self):
          pass
  ```

- 命名规范
  - 类名使用驼峰命名法（CamelCase）
  - 方法和属性使用小写字母加下划线（snake_case）

### 1.1.2 对象的创建和使用

- 实例化对象
  ```python
  # 创建对象
  obj = ClassName(params)
  
  # 访问属性
  print(obj.instance_attribute)
  
  # 调用方法
  obj.method()
  ```

## 1.2 二、封装

### 1.2.1 访问控制

- 私有属性和方法（双下划线前缀）
  ```python
  class Student:
      def __init__(self):
          self.__score = 0  # 私有属性
      
      def __calculate_grade(self):  # 私有方法
          pass
  ```

- 保护属性和方法（单下划线前缀）
  ```python
  class Student:
      def __init__(self):
          self._age = 0  # 保护属性
  ```

### 1.2.2 属性装饰器

- @property 装饰器
  ```python
  class Person:
      def __init__(self):
          self.__age = 0
      
      @property
      def age(self):
          return self.__age
      
      @age.setter
      def age(self, value):
          if 0 <= value <= 150:
              self.__age = value
  ```

## 1.3 三、继承

### 1.3.1 基本继承

```python
class Animal:
    def __init__(self, name):
        self.name = name
    
    def speak(self):
        pass

class Dog(Animal):
    def speak(self):
        return f"{self.name} says Woof!"
```

### 1.3.2 多重继承

```python
class A:
    def method_a(self):
        pass

class B:
    def method_b(self):
        pass

class C(A, B):  # 多重继承
    pass
```

### 1.3.3 super() 函数

```python
class Child(Parent):
    def __init__(self):
        super().__init__()  # 调用父类的构造方法
```

## 1.4 四、多态

### 1.4.1 方法重写

```python
class Shape:
    def area(self):
        pass

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height
    
    def area(self):
        return self.width * self.height

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius
    
    def area(self):
        return 3.14 * self.radius ** 2
```

### 1.4.2 鸭子类型

```python
class Duck:
    def swim(self):
        print("Duck swimming")

class Fish:
    def swim(self):
        print("Fish swimming")

def make_it_swim(thing):
    thing.swim()  # 不关心对象类型，只关心是否有swim方法
```

## 1.5 五、魔术方法

### 1.5.1 常用魔术方法

```python
class MyClass:
    def __str__(self):
        return "字符串表示"
    
    def __len__(self):
        return 0
    
    def __eq__(self, other):
        return True
```

### 1.5.2 运算符重载

```python
class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)
    
    def __mul__(self, scalar):
        return Vector(self.x * scalar, self.y * scalar)
```

## 1.6 六、最佳实践

### 1.6.1 SOLID 原则

- 单一职责原则（Single Responsibility Principle）
- 开放封闭原则（Open-Closed Principle）
- 里氏替换原则（Liskov Substitution Principle）
- 接口隔离原则（Interface Segregation Principle）
- 依赖倒置原则（Dependency Inversion Principle）

### 1.6.2 设计模式

- 单例模式
  ```python
  class Singleton:
      _instance = None
      
      def __new__(cls):
          if cls._instance is None:
              cls._instance = super().__new__(cls)
          return cls._instance
  ```

- 工厂模式
  ```python
  class AnimalFactory:
      @staticmethod
      def create_animal(animal_type):
          if animal_type == "dog":
              return Dog()
          elif animal_type == "cat":
              return Cat()
  ```

### 1.6.3 代码组织

- 类的组织结构
  - 类属性
  - 构造方法
  - 公共方法
  - 保护方法
  - 私有方法
  - 魔术方法

- 模块化
  - 相关的类放在同一个模块中
  - 使用包组织模块
  - 遵循 Python 的导入约定

## 1.7 七、常见问题和解决方案

### 1.7.1 循环引用

- 使用弱引用（weakref）模块
- 重构代码结构避免循环依赖

### 1.7.2 内存管理

- 及时释放不需要的对象
- 使用 __del__ 方法清理资源
- 使用上下文管理器（with 语句）

### 1.7.3 性能优化

- 使用 __slots__ 限制属性
- 避免过度使用魔术方法
- 合理使用属性装饰器

## 1.8 八、测试和调试

### 1.8.1 单元测试

```python
import unittest

class TestMyClass(unittest.TestCase):
    def setUp(self):
        self.obj = MyClass()
    
    def test_method(self):
        self.assertEqual(self.obj.method(), expected_result)
```

### 1.8.2 调试技巧

- 使用 pdb 调试器
- 打印对象的 __dict__ 属性
- 使用 dir() 函数查看对象属性

## 1.9 九、高级主题

### 1.9.1 元类

```python
class MyMetaclass(type):
    def __new__(cls, name, bases, attrs):
        # 修改类的创建过程
        return super().__new__(cls, name, bases, attrs)

class MyClass(metaclass=MyMetaclass):
    pass
```

### 1.9.2 描述符

```python
class Descriptor:
    def __get__(self, obj, owner):
        pass
    
    def __set__(self, obj, value):
        pass
    
    def __delete__(self, obj):
        pass
```

### 1.9.3 抽象基类

```python
from abc import ABC, abstractmethod

class AbstractClass(ABC):
    @abstractmethod
    def abstract_method(self):
        pass
```

## 1.10 十、实战示例

### 1.10.1 简单的银行账户系统

```python
class BankAccount:
    def __init__(self, account_number, balance=0):
        self.__account_number = account_number
        self.__balance = balance
    
    @property
    def balance(self):
        return self.__balance
    
    def deposit(self, amount):
        if amount > 0:
            self.__balance += amount
            return True
        return False
    
    def withdraw(self, amount):
        if 0 < amount <= self.__balance:
            self.__balance -= amount
            return True
        return False

class SavingsAccount(BankAccount):
    def __init__(self, account_number, interest_rate):
        super().__init__(account_number)
        self.__interest_rate = interest_rate
    
    def add_interest(self):
        interest = self.balance * self.__interest_rate
        self.deposit(interest)
```

### 1.10.2 简单的图形界面组件

```python
class Widget:
    def __init__(self, x, y, width, height):
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    
    def draw(self):
        pass

class Button(Widget):
    def __init__(self, x, y, width, height, text):
        super().__init__(x, y, width, height)
        self.text = text
    
    def draw(self):
        # 绘制按钮
        pass
    
    def click(self):
        # 处理点击事件
        pass
```
