<template>
  <div class="about-view">
    <div class="about-container">
      <h1 class="page-title">关于我</h1>
      <div class="about-content">
        <div v-if="aboutContent" v-html="renderedContent"></div>
        <div v-else class="loading">加载中...</div>
      </div>
    </div>
  </div>
</template>

<script>
import MarkdownIt from 'markdown-it';
import hljs from 'highlight.js';
import 'highlight.js/styles/github.css';

export default {
  name: 'AboutView',
  data() {
    return {
      aboutContent: `
# 关于我

## 个人简介

你好，我是一名热爱技术的程序员，专注于Java和Web开发技术栈。

## 技术栈

### 编程语言
- Java
- Python
- JavaScript
- HTML/CSS

### 框架和库
- Spring Framework
- Spring Boot
- Spring Cloud
- Vue.js
- React.js

### 数据库
- MySQL
- Redis
- MongoDB

### 工具
- Git
- Docker
- Linux
- IntelliJ IDEA
- VS Code

## 我的博客

这个博客用于记录我在学习和工作中的技术心得、问题解决方案以及一些有趣的技术探索。主要包括以下内容：

- Java相关技术
- 前端开发技巧
- 数据库使用与优化
- 算法与数据结构
- 系统设计与架构
- 开发工具使用技巧
- 个人学习笔记

## 联系方式

如果你有任何问题或想法，欢迎通过以下方式联系我：

- Email: example@example.com
- GitHub: [我的GitHub主页](https://github.com/)
- 微信公众号: 技术笔记

## 致谢

感谢您访问我的博客，希望这里的内容对您有所帮助！
      `
    };
  },
  computed: {
    renderedContent() {
      const md = new MarkdownIt({
        html: true,
        linkify: true,
        typographer: true,
        highlight: function (str, lang) {
          if (lang && hljs.getLanguage(lang)) {
            try {
              return hljs.highlight(str, { language: lang }).value;
            } catch (__) {}
          }
          return ''; // 使用默认的转义
        }
      });
      return md.render(this.aboutContent || '');
    }
  }
}
</script>

<style scoped>
.about-view {
  min-height: 100vh;
  padding: 20px;
}

.about-container {
  max-width: 800px;
  margin: 0 auto;
  background-color: #fff;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.page-title {
  font-size: 2.2rem;
  color: #333;
  margin-bottom: 30px;
  text-align: center;
}

.about-content {
  line-height: 1.7;
  color: #333;
}

.about-content :deep(h2) {
  font-size: 1.6rem;
  color: #42b883;
  margin-top: 30px;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.about-content :deep(h3) {
  font-size: 1.3rem;
  color: #333;
  margin-top: 25px;
  margin-bottom: 15px;
}

.about-content :deep(p) {
  margin-bottom: 15px;
}

.about-content :deep(ul) {
  padding-left: 20px;
  margin-bottom: 20px;
}

.about-content :deep(li) {
  margin-bottom: 5px;
}

.about-content :deep(a) {
  color: #42b883;
  text-decoration: none;
}

.about-content :deep(a:hover) {
  text-decoration: underline;
}

.loading {
  text-align: center;
  font-size: 1.2rem;
  color: #666;
  padding: 50px 0;
}
</style> 