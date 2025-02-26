---
title: "Python 文件操作"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# Python 文件操作

## 一、文件基础

### 1. 文件打开和关闭

- 基本语法
  ```python
  # 打开文件
  file = open('filename', 'mode', encoding='utf-8')
  
  # 使用文件
  content = file.read()
  
  # 关闭文件
  file.close()
  ```

- 使用 with 语句（推荐）
  ```python
  with open('filename', 'mode', encoding='utf-8') as file:
      content = file.read()
  ```

### 2. 文件打开模式

- 常用模式
  - 'r'：只读模式（默认）
  - 'w'：写入模式（覆盖）
  - 'a'：追加模式
  - 'b'：二进制模式
  - 't'：文本模式（默认）
  - '+'：读写模式

## 二、文件读写操作

### 1. 读取操作

- 读取全部内容
  ```python
  with open('file.txt', 'r') as f:
      content = f.read()
  ```

- 按行读取
  ```python
  # 读取单行
  line = f.readline()
  
  # 读取所有行
  lines = f.readlines()
  
  # 迭代读取
  for line in f:
      print(line)
  ```

### 2. 写入操作

- 写入字符串
  ```python
  with open('file.txt', 'w') as f:
      f.write('Hello, World!')
  ```

- 写入多行
  ```python
  lines = ['Line 1\n', 'Line 2\n', 'Line 3\n']
  with open('file.txt', 'w') as f:
      f.writelines(lines)
  ```

## 三、文件系统操作

### 1. os 模块

```python
import os

# 当前工作目录
print(os.getcwd())

# 改变工作目录
os.chdir('/path/to/directory')

# 创建目录
os.mkdir('new_directory')

# 删除文件
os.remove('file.txt')

# 删除目录
os.rmdir('empty_directory')
```

### 2. os.path 模块

```python
import os.path

# 路径拼接
full_path = os.path.join('dir', 'subdir', 'file.txt')

# 判断是否存在
exists = os.path.exists('file.txt')

# 判断类型
is_file = os.path.isfile('file.txt')
is_dir = os.path.isdir('directory')

# 获取路径信息
base = os.path.basename('/path/to/file.txt')  # file.txt
dir_name = os.path.dirname('/path/to/file.txt')  # /path/to
```

## 四、高级文件操作

### 1. 二进制文件操作

```python
# 写入二进制数据
with open('file.bin', 'wb') as f:
    f.write(bytes([65, 66, 67]))

# 读取二进制数据
with open('file.bin', 'rb') as f:
    data = f.read()
```

### 2. 文件指针操作

```python
with open('file.txt', 'r') as f:
    # 移动指针
    f.seek(10)  # 移动到第10个字节
    
    # 获取当前位置
    position = f.tell()
    
    # 读取指定字节数
    data = f.read(5)
```

## 五、文件和目录管理

### 1. shutil 模块

```python
import shutil

# 复制文件
shutil.copy('source.txt', 'dest.txt')

# 复制目录
shutil.copytree('src_dir', 'dst_dir')

# 移动文件或目录
shutil.move('old_path', 'new_path')

# 删除目录及其内容
shutil.rmtree('directory')
```

### 2. 遍历目录

```python
# 简单遍历
for item in os.listdir('directory'):
    print(item)

# 高级遍历
for root, dirs, files in os.walk('directory'):
    print(f'当前目录: {root}')
    print(f'子目录: {dirs}')
    print(f'文件: {files}')
```

## 六、文件编码

### 1. 文本编码处理

```python
# 指定编码读取
with open('file.txt', 'r', encoding='utf-8') as f:
    content = f.read()

# 处理编码错误
with open('file.txt', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()
```

### 2. 编码转换

```python
# 字符串编码转换
text = 'Hello'
bytes_data = text.encode('utf-8')
text_again = bytes_data.decode('utf-8')
```

## 七、异常处理

### 1. 基本异常处理

```python
try:
    with open('file.txt', 'r') as f:
        content = f.read()
except FileNotFoundError:
    print('文件不存在')
except IOError:
    print('IO错误')
finally:
    print('清理工作')
```

### 2. 自定义文件操作异常

```python
class FileOperationError(Exception):
    def __init__(self, message):
        super().__init__(message)

def safe_read_file(filename):
    try:
        with open(filename, 'r') as f:
            return f.read()
    except Exception as e:
        raise FileOperationError(f'读取文件失败: {str(e)}')
```

## 八、最佳实践

### 1. 文件操作建议

- 始终使用 with 语句
- 正确处理编码
- 适当的异常处理
- 及时关闭文件

### 2. 性能优化

- 使用缓冲
  ```python
  # 设置缓冲区大小
  with open('file.txt', 'w', buffering=8192) as f:
      f.write('大量数据')
  ```

- 分块读取
  ```python
  def read_in_chunks(file_object, chunk_size=1024):
      while True:
          data = file_object.read(chunk_size)
          if not data:
              break
          yield data
  ```

### 3. 文件命名和组织

- 使用有意义的文件名
- 统一的目录结构
- 适当的权限管理
- 定期清理临时文件

## 九、实战示例

### 1. 文件备份工具

```python
import os
import shutil
from datetime import datetime

def backup_file(source_file):
    # 创建备份文件名
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    base_name = os.path.basename(source_file)
    backup_name = f'{base_name}.{timestamp}.bak'
    
    # 创建备份
    try:
        shutil.copy2(source_file, backup_name)
        print(f'备份成功: {backup_name}')
    except Exception as e:
        print(f'备份失败: {str(e)}')
```

### 2. 日志文件分析器

```python
from collections import defaultdict
import re

def analyze_log(log_file):
    pattern = r'\[(ERROR|INFO|WARNING)\]'
    stats = defaultdict(int)
    
    with open(log_file, 'r') as f:
        for line in f:
            match = re.search(pattern, line)
            if match:
                level = match.group(1)
                stats[level] += 1
    
    return dict(stats)
```

### 3. 文件监控器

```python
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class MyHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if not event.is_directory:
            print(f'文件被修改: {event.src_path}')

def monitor_directory(path):
    event_handler = MyHandler()
    observer = Observer()
    observer.schedule(event_handler, path, recursive=False)
    observer.start()
    
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
```
