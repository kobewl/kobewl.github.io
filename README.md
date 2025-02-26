# 个人博客系统

一个基于 Vue 3 + Vite 构建的现代化个人博客系统，具有清晰的界面设计和完整的博客功能。

## 技术栈

- **前端框架**：Vue 3
- **构建工具**：Vite
- **UI 框架**：Element Plus
- **路由管理**：Vue Router
- **状态管理**：Pinia
- **Markdown 渲染**：markdown-it
- **代码高亮**：highlight.js

## 主要功能

### 1. 博客文章
- 文章列表展示
- 文章详情页面
- Markdown 内容渲染
- 代码块语法高亮

### 2. 分类管理
- 文章分类展示
- 分类统计
- 分类导航

### 3. 标签系统
- 标签云展示
- 标签大小动态计算
- 标签筛选

### 4. 响应式设计
- 适配桌面和移动设备
- 移动端导航菜单
- 流畅的过渡动画

### 5. 个性化页面
- 个人介绍页面
- 社交媒体链接
- 技术栈展示

## 项目结构

```
src/
├── components/        # 组件目录
│   ├── BlogHeader.vue    # 博客头部导航
│   ├── BlogFooter.vue    # 博客底部信息
│   ├── BlogPostList.vue  # 文章列表组件
│   ├── BlogPostDetail.vue # 文章详情组件
│   ├── CategoryList.vue  # 分类列表组件
│   └── TagList.vue       # 标签列表组件
├── views/            # 页面视图
│   ├── HomeView.vue     # 首页
│   ├── PostView.vue     # 文章页
│   ├── CategoriesView.vue # 分类页
│   ├── TagsView.vue     # 标签页
│   └── AboutView.vue    # 关于页面
├── router/           # 路由配置
└── stores/           # 状态管理
```

## 开发指南

### 环境要求
- Node.js >= 16.0.0
- npm >= 7.0.0

### 安装依赖
```bash
npm install
```

### 开发环境运行
```bash
npm run dev
```

### 生产环境构建
```bash
npm run build
```

### 代码检查和格式化
```bash
npm run lint
npm run format
```

## 自定义配置

请参考 [Vite 配置参考](https://vite.dev/config/)。

## 许可证

MIT License
