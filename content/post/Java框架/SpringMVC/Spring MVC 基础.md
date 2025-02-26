---
title: "1 SpringMvc的处理流程是什么？"
date: 2023-01-01T01:01:01+08:00
categories: ["D:"]
tags: ["D:"]
draft: false
---
# 1 SpringMvc的处理流程是什么？

^8d2bdd

![[Pasted image 20250220120757.png]]


在 **Spring MVC** 中，处理请求的流程是一个清晰且可扩展的流程，主要包括以下步骤：

---

1. **客户端请求发送到 DispatcherServlet**

- 所有的 HTTP 请求首先会被 Spring MVC 的核心前端控制器 `DispatcherServlet` 接收。
- `DispatcherServlet` 是 Spring MVC 的中央控制器，负责协调整个请求处理流程。

---

2. **根据 HandlerMapping 找到处理器（Handler）**

- `DispatcherServlet` 根据请求的 URL，使用配置的 **HandlerMapping** 寻找与之对应的处理器（通常是一个控制器方法）。
- 常见的 `HandlerMapping`：

- `RequestMappingHandlerMapping`（处理基于注解的映射，如 `@RequestMapping`）
- `SimpleUrlHandlerMapping`（处理基于配置文件的映射）

---

3. **通过 HandlerAdapter 调用处理器**

- 找到合适的处理器后，`DispatcherServlet` 会通过合适的 **HandlerAdapter** 调用该处理器。
- `HandlerAdapter` 是一种适配器，用来屏蔽不同类型处理器的实现差异，统一调用方式。

- 常见的 HandlerAdapter：

- `RequestMappingHandlerAdapter`：用于注解驱动的控制器
- `HttpRequestHandlerAdapter`：用于实现 `HttpRequestHandler` 接口的处理器

---

4. **处理器处理请求，返回 ModelAndView**

- 控制器方法处理业务逻辑后，返回一个 `ModelAndView` 对象。

- **Model**：封装业务数据（以键值对的形式）。
- **View**：指定逻辑视图名称。

---

5. **视图解析器解析逻辑视图名**

- `DispatcherServlet` 使用 **ViewResolver** 解析逻辑视图名为具体的视图对象（如 JSP 文件）。
- 常见的 ViewResolver：

- `InternalResourceViewResolver`：解析 JSP 视图
- `ThymeleafViewResolver`：解析 Thymeleaf 视图

---

6. **视图渲染**

- 具体视图渲染数据并生成最终的 HTML 页面或其他格式的响应。

---

7. **返回响应给客户端**

- 渲染完成后，`DispatcherServlet` 将响应返回给客户端。

---

**流程图概述**

1. 客户端发送请求。
2. `DispatcherServlet` 接收请求。
3. 通过 `HandlerMapping` 找到处理器。
4. `HandlerAdapter` 调用处理器。
5. 处理器返回 `ModelAndView`。
6. 通过 `ViewResolver` 解析视图。
7. 渲染视图并返回给客户端。



