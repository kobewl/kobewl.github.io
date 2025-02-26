<template>
  <el-container class="app">
    <BlogHeader />
    <el-main class="main-content">
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </el-main>
    <BlogFooter />
  </el-container>
</template>

<script setup>
// 使用setup语法导入组件
import BlogHeader from './components/BlogHeader.vue'
import BlogFooter from './components/BlogFooter.vue'
</script>

<style>
/* 全局样式 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

:root {
  --primary-color: #6366f1;
  --primary-light: #818cf8;
  --primary-dark: #4f46e5;
  --dark-bg: #0a192f;
  --header-height: 70px;
  --text-color: #334155;
  --light-bg: #f7f9fc;
}

html,
body {
  height: 100%;
  width: 100%;
  overflow-x: hidden;
  margin: 0;
  padding: 0;
  background-color: var(--dark-bg);
  color: #ffffff;
  font-family: 'Inter', 'Helvetica Neue', Helvetica, Arial, sans-serif;
  line-height: 1.6;
  font-size: 16px;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  width: 100%;
  overflow-x: hidden;
}

.el-main {
  padding: 0;
  flex: 1;
  margin-top: var(--header-height);
  overflow-x: hidden;
}

/* 首页组件不需要顶部margin */
.home + .el-main,
.home .el-main {
  margin-top: 0;
}

/* Element Plus 自定义样式 */
:root {
  --el-color-primary: var(--primary-color);
}

.el-button {
  border-radius: 6px;
}

.el-button:focus,
.el-button:hover {
  border-color: var(--primary-color);
  color: var(--primary-color);
}

.el-tag {
  background-color: rgba(99, 102, 241, 0.1);
  border-color: rgba(99, 102, 241, 0.2);
  color: var(--primary-color);
  border-radius: 4px;
  padding: 0 10px;
}

/* 滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

/* 链接全局样式 */
a {
  color: var(--primary-color);
  text-decoration: none;
  transition: color 0.3s;
}

a:hover {
  color: var(--primary-dark);
}

/* 动画效果 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* 响应式布局 */
@media (max-width: 768px) {
  :root {
    --header-height: 60px;
  }

  .el-footer {
    padding: 20px 15px;
  }

  .blog-header-container,
  .blog-post-list,
  .category-list,
  .tag-list,
  .blog-post-detail,
  .about-container {
    padding: 0 15px;
  }
}

/* 其他页面可以使用浅色背景 */
.el-main:not(.home) {
  background-color: var(--light-bg);
  color: var(--text-color);
}
</style>
