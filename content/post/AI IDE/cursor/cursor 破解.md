---
title: "cursor 破解"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
  

需要两个部分：　

1. 破解+禁止自动更新
2. Fake（在文章最后）

⚠️ 重要提示　

本工具当前支持版本：　

- ✅ Cursor v0.44.11 及以下版本
- ✅ Windows: 最新的 0.45.x 版本（已支持）
- ✅ Mac/Linux: 最新的 0.45.x 版本（已支持，欢迎测试并反馈问题）

使用前请确认您的 Cursor 版本。　

🔒 禁用自动更新功能　

为防止 Cursor 自动更新到不支持的新版本，您可以选择禁用自动更新功能。　

#### 0.1.1.1 方法一：使用内置脚本（推荐）

在运行重置工具时，脚本会询问是否要禁用自动更新：　

```
[询问] 是否要禁用 Cursor 自动更新功能？否 - 保持默认设置 (按回车键)是 - 禁用自动更新
```

选择 1 即可自动完成禁用操作。　

#### 0.1.1.2 方法二：手动禁用

Windows:　

1. 关闭所有 Cursor 进程
2. 删除目录：%LOCALAPPDATA%\cursor-updater
3. 在相同位置创建同名文件（不带扩展名）

macOS:　

```
# 关闭 Cursorpkill -f "Cursor"# 删除更新目录并创建阻止文件rm -rf ~/Library/Application\ Support/cursor-updatertouch ~/Library/Application\ Support/cursor-updater
```

Linux:　

```
# 关闭 Cursorpkill -f "Cursor"# 删除更新目录并创建阻止文件rm -rf ~/.config/cursor-updatertouch ~/.config/cursor-updater
```

⚠️ 注意： 禁用自动更新后，需要手动下载并安装新版本。建议在确认新版本可用后再更新。　

### 0.1.2 📝 问题描述

当您遇到以下任一提示时:　

#### 0.1.2.1 问题一：试用账号限制

```
Too many free trial accounts used on this machine.Please upgrade to pro. We have this limit in placeto prevent abuse. Please let us know if you believethis is a mistake.
```

#### 0.1.2.2 #### 问题二：API密钥限制

```
❗[New Issue]Composer relies on custom models that cannot be billed to an API key.Please disable API keys and use a Pro or Business subscription.Request ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

#### 0.1.2.3 问题三：试用请求次数限制

这表示在 VIP 免费试用期间已达到使用次数限制:　

```
You've reached your trial request limit.
```

#### 0.1.2.4 解决方案 ：完全卸载 Cursor 并重新安装（API 密钥问题）

1. 下载 Geek.exe 卸载程序（请在公众号私信“Geek”获取，一般的卸载软件卸载不干净）
2. 完全卸载 Cursor 应用
3. 重新安装 Cursor 应用
4. 转到解决方案 1

#### 0.1.2.5 方案一：快速重置（推荐）

1. 关闭 Cursor 应用
2. 执行重置机器码脚本（见下方安装说明）
3. 重新打开 Cursor 即可继续使用

#### 0.1.2.6 方案二：账号切换

4. 文件 -> Cursor Settings -> 注销当前账号
5. 关闭 Cursor
6. 执行重置机器码脚本
7. 使用新账号重新登录

#### 0.1.2.7 方案三：网络优化

如果上述方案仍无法解决，可尝试：　

- 切换至低延迟节点（推荐区域：日本、新加坡、美国、香港）
- 确保网络稳定性
- 清除浏览器缓存后重试

### 0.1.3 🚀 系统支持

### 0.1.4 🚀 一键解决方案

国内用户（推荐）　

macOS　

```
curl -fsSL https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_mac_id_modifier.sh | sudo bash
```

Linux　

```
curl -fsSL https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_linux_id_modifier.sh | sudo bash
```

Windows　

```
irm https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_win_id_modifier.ps1 | iex
```

#### 0.1.4.1 Windows 管理员终端运行和手动安装

##### 0.1.4.1.1 方法一：使用 Win + X 快捷键

```
按下 Win + X 组合键在弹出的菜单中选择以下任一选项:- "Windows PowerShell (管理员)"- "Windows Terminal (管理员)" - "终端(管理员)"   (具体选项因Windows版本而异)
```

##### 0.1.4.1.2 方法二：使用 Win + R 运行命令

```
 按下 Win + R 组合键在运行框中输入 powershell 或 pwsh 按 Ctrl + Shift + Enter 以管理员身份运行   或在打开的窗口中输入: Start-Process pwsh -Verb RunAs 在管理员终端中输入以下重置脚本:irm https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_win_id_modifier.ps1 | iex
```

##### 0.1.4.1.3 方法三：通过搜索启动

![图片](data:image/svg+xml,%3C%3Fxml version='1.0' encoding='UTF-8'%3F%3E%3Csvg width='1px' height='1px' viewBox='0 0 1 1' version='1.1' xmlns='[http://www.w3.org/2000/svg'](http://www.w3.org/2000/svg') xmlns:xlink='[http://www.w3.org/1999/xlink'%3E%3Ctitle%3E%3C/title%3E%3Cg](http://www.w3.org/1999/xlink'%3E%3Ctitle%3E%3C/title%3E%3Cg) stroke='none' stroke-width='1' fill='none' fill-rule='evenodd' fill-opacity='0'%3E%3Cg transform='translate(-249.000000, -126.000000)' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)

在搜索框中输入 pwsh，右键选择"以管理员身份运行" 　

![图片](data:image/svg+xml,%3C%3Fxml version='1.0' encoding='UTF-8'%3F%3E%3Csvg width='1px' height='1px' viewBox='0 0 1 1' version='1.1' xmlns='[http://www.w3.org/2000/svg'](http://www.w3.org/2000/svg') xmlns:xlink='[http://www.w3.org/1999/xlink'%3E%3Ctitle%3E%3C/title%3E%3Cg](http://www.w3.org/1999/xlink'%3E%3Ctitle%3E%3C/title%3E%3Cg) stroke='none' stroke-width='1' fill='none' fill-rule='evenodd' fill-opacity='0'%3E%3Cg transform='translate(-249.000000, -126.000000)' fill='%23FFFFFF'%3E%3Crect x='249' y='126' width='1' height='1'%3E%3C/rect%3E%3C/g%3E%3C/g%3E%3C/svg%3E)

在管理员终端中输入重置脚本:　

```
irm https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_win_id_modifier.ps1 | iex
```

参考资料：[https://github.com/yuaotian/go-cursor-help/tree/master](https://github.com/yuaotian/go-cursor-help/tree/master)　

请遵守MIT许可协议：　

Copyright (c) 2024　

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:　

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.　

---

最后，你要使用老金最早推荐的删除账号fake方法，否则每日50次，3天共计150次后账号还是需要升级Pro。　

详情请查看Cursor 0.44版本说明最后的破解方法(即前文提到的Fake。　

项目地址：[https://github.com/bestk/cursor-fake-machine](https://github.com/bestk/cursor-fake-machine)
