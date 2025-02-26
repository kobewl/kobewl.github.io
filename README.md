# kobewl.github.io - 科幻主题个人博客

这是一个使用 [Hugo](https://gohugo.io/) 构建的科幻主题个人博客，基于 Dream 主题进行了大量自定义，添加了丰富的动画效果和现代化设计。

## 特色功能

- **科幻风格星空背景**：动态星空与流星效果，创造沉浸式体验
- **一言 API 集成**：自动获取并以打字机效果显示随机语录
- **响应式设计**：完美适配从手机到桌面的各种设备
- **精美动画效果**：
  - 淡入淡出和滑动动画
  - 鼠标悬停特效
  - 流星和星云效果
  - 霓虹灯光效果
- **现代化文章展示**：精美卡片布局和优化的排版

## 文件结构

- `config.toml`: 主配置文件，包含网站基本信息和社交媒体链接
- `content/`: 博客内容
  - `post/`: 博客文章
  - `about.md`: 关于页面
- `static/`: 静态资源
  - `css/`: 自定义 CSS 文件
  - `img/`: 图片资源，包括头像
- `themes/`: 主题文件
  - `dream/`: 修改后的 Dream 主题
    - `layouts/`: 布局模板
    - `static/`: 主题静态资源
- `archetypes/`: 文章模板
- `public/`: 生成的静态网站文件

## 如何使用

### 安装 Hugo

首先，您需要安装 Hugo。访问 [Hugo 官方网站](https://gohugo.io/getting-started/installing/) 了解如何安装。

#### Windows 用户

```
choco install hugo -confirm
```

或直接从 [Hugo Releases](https://github.com/gohugoio/hugo/releases) 下载可执行文件。

#### macOS 用户

```
brew install hugo
```

#### Linux 用户

```
sudo apt-get install hugo
```

### 本地预览

1. 在项目根目录运行:

```
hugo server -D
```

2. 在浏览器中访问 `http://localhost:1313/` 查看您的博客

### 创建新文章

运行以下命令创建新文章:

```
hugo new post/my-new-post.md
```

然后编辑 `content/post/my-new-post.md` 文件。文章顶部的 Front Matter 部分可以设置标题、日期、分类和标签。

### 构建网站

当您准备部署网站时，运行:

```
hugo
```

这将在 `public/` 目录中生成静态网站文件，可以部署到任何静态网站托管服务。

### 自定义

#### 基本设置

- 编辑 `config.toml` 文件更改网站设置：
  - 修改 `title` 和 `author` 为您的名字
  - 更新 `social` 部分的社交媒体链接
  - 自定义 `categories` 和 `tags` 分类

#### 视觉效果

- 替换 `static/img/avatar.jpg` 为您自己的头像
- 修改 `themes/dream/layouts/index.html` 中的 CSS 变量调整颜色主题
- 自定义 `static/css/custom.css` 添加您的样式覆盖

#### 高级定制

- 修改星空背景：调整 `nebula-effect` 和星星的 CSS
- 流星效果：调整 `createShootingStar` 函数中的参数
- 打字机效果：在 JavaScript 部分修改 `typeWriter` 函数

## 自动部署

本项目已配置 GitHub Actions 自动部署功能，每当推送到 main 分支时，会自动构建并部署到 GitHub Pages。

### 如何配置自动部署

1. 确保你的仓库已启用 GitHub Pages

   - 进入仓库设置 -> Pages
   - 选择 "GitHub Actions" 作为构建和部署的来源

2. 推送代码到 main 分支即可触发自动部署

   - 部署进度可在仓库的 Actions 标签页查看
   - 部署完成后，你的博客将在 https://用户名.github.io 可用

3. 自定义域名（可选）
   - 在仓库设置的 Pages 部分添加自定义域名
   - 在你的域名提供商处添加正确的 DNS 记录

## 技术实现

博客使用了多种现代 Web 技术：

- **CSS 动画和变换**：实现流畅的过渡效果
- **Intersection Observer API**：用于滚动检测和展示动画
- **Fetch API**：与一言 API 交互获取随机语录
- **CSS Grid 和 Flexbox**：实现响应式布局
- **Hugo 模板系统**：动态生成页面内容

## 许可证

MIT
