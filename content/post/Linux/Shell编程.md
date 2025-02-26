---
title: "1 Shell 编程基础"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 Shell 编程基础

## 1.1 Shell 基础

### 1.1.1 Shell 类型

- **bash** (默认)
- **sh**
- **zsh**
- **csh**
- **ksh**

### 1.1.2 Shell 脚本结构

```bash
#!/bin/bash          # shebang行
# 注释
# 变量定义
# 主程序
# 函数定义
```

## 1.2 变量和数据类型

### 1.2.1 变量定义

```bash
name="value"         # 定义变量
echo $name          # 使用变量
echo ${name}        # 使用变量(推荐)
readonly name       # 只读变量
unset name          # 删除变量
```

### 1.2.2 特殊变量

```bash
$0      # 脚本名称
$1-$9   # 位置参数
$#      # 参数个数
$*      # 所有参数
$@      # 所有参数(数组形式)
$?      # 上一条命令返回值
$$      # 当前进程PID
$!      # 上一个后台进程PID
```

## 1.3 运算符

### 1.3.1 算术运算

```bash
let "a = 1 + 2"
expr 1 + 2
$((1 + 2))
```

### 1.3.2 条件测试

```bash
test expression
[ expression ]
[[ expression ]]    # 增强版test
```

## 1.4 控制结构

### 1.4.1 条件语句

```bash
# if语句
if [ condition ]; then
    commands
elif [ condition ]; then
    commands
else
    commands
fi

# case语句
case $var in
    pattern1)
        commands;;
    pattern2)
        commands;;
    *)
        commands;;
esac
```

### 1.4.2 循环语句

```bash
# for循环
for var in list; do
    commands
done

# while循环
while [ condition ]; do
    commands
done

# until循环
until [ condition ]; do
    commands
done
```

## 1.5 函数

### 1.5.1 函数定义

```bash
function_name() {
    commands
    return value
}

# 或者
function function_name {
    commands
    return value
}
```

### 1.5.2 函数参数

```bash
function_name() {
    echo $1    # 第一个参数
    echo $2    # 第二个参数
    echo $#    # 参数个数
    echo $*    # 所有参数
}
```

## 1.6 输入输出

### 1.6.1 标准输入输出

```bash
echo "输出"
read var      # 读取输入
printf "格式化输出"
```

### 1.6.2 重定向

```bash
command > file    # 输出重定向
command >> file   # 追加重定向
command < file    # 输入重定向
command 2> file   # 错误重定向
command &> file   # 所有输出重定向
```

## 1.7 字符串处理

### 1.7.1 字符串操作

```bash
${#string}        # 字符串长度
${string:position}    # 子字符串
${string:position:length}
${string#pattern}     # 从头删除最短匹配
${string##pattern}    # 从头删除最长匹配
${string%pattern}     # 从尾删除最短匹配
${string%%pattern}    # 从尾删除最长匹配
```

### 1.7.2 正则表达式

```bash
grep pattern file
sed 's/pattern/replacement/'
awk 'pattern {action}'
```

## 1.8 数组

### 1.8.1 数组操作

```bash
array=(value1 value2 ...)    # 定义数组
${array[0]}                  # 访问元素
${array[*]}                  # 所有元素
${#array[*]}                # 数组长度
```

## 1.9 调试

### 1.9.1 调试选项

```bash
set -x          # 打开调试
set +x          # 关闭调试
bash -x script  # 调试执行
```

## 1.10 最佳实践

1. **错误处理**

```bash
set -e          # 遇错退出
set -u          # 未定义变量报错
trap command signal  # 信号处理
```

2. **代码风格**

- 使用有意义的变量名
- 添加适当的注释
- 保持一致的缩进
- 模块化代码

## 1.11 面试重点

1. **基础概念**

   - Shell 类型区别
   - 环境变量 vs 局部变量
   - 特殊变量含义

2. **语法特性**

   - 条件测试方法
   - 循环控制
   - 函数返回值

3. **文本处理**

   - grep/sed/awk 使用
   - 正则表达式
   - 文件操作

4. **实际应用**

   - 系统监控脚本
   - 日志分析
   - 批量处理
   - 自动化运维

5. **调试技巧**
   - 常见错误处理
   - 调试方法
   - 性能优化

