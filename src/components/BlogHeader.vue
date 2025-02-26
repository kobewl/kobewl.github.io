<template>
  <el-header class="blog-header">
    <div class="blog-header-container">
      <router-link to="/" class="blog-title-link">
        <div class="logo-container">
          <span class="logo-icon"><el-icon><Monitor /></el-icon></span>
          <h1 class="blog-title">我的个人博客</h1>
        </div>
      </router-link>
      
      <!-- 大屏幕导航 -->
      <el-menu
        mode="horizontal"
        :ellipsis="false"
        router
        class="blog-nav desktop-nav"
      >
        <el-menu-item index="/">
          <el-icon><HomeFilled /></el-icon>
          <span>首页</span>
        </el-menu-item>
        <el-menu-item index="/categories">
          <el-icon><FolderOpened /></el-icon>
          <span>分类</span>
        </el-menu-item>
        <el-menu-item index="/tags">
          <el-icon><Collection /></el-icon>
          <span>标签</span>
        </el-menu-item>
        <el-menu-item index="/about">
          <el-icon><InfoFilled /></el-icon>
          <span>关于</span>
        </el-menu-item>
      </el-menu>
      
      <!-- 移动端菜单按钮 -->
      <div class="mobile-menu-toggle" @click="toggleMobileMenu">
        <el-icon v-if="!mobileMenuOpen"><Menu /></el-icon>
        <el-icon v-else><Close /></el-icon>
      </div>
      
      <!-- 移动端导航 -->
      <transition name="mobile-nav">
        <div class="mobile-nav" v-if="mobileMenuOpen">
          <router-link to="/" class="mobile-nav-item" @click="toggleMobileMenu">
            <el-icon><HomeFilled /></el-icon>
            <span>首页</span>
          </router-link>
          <router-link to="/categories" class="mobile-nav-item" @click="toggleMobileMenu">
            <el-icon><FolderOpened /></el-icon>
            <span>分类</span>
          </router-link>
          <router-link to="/tags" class="mobile-nav-item" @click="toggleMobileMenu">
            <el-icon><Collection /></el-icon>
            <span>标签</span>
          </router-link>
          <router-link to="/about" class="mobile-nav-item" @click="toggleMobileMenu">
            <el-icon><InfoFilled /></el-icon>
            <span>关于</span>
          </router-link>
        </div>
      </transition>
    </div>
  </el-header>
</template>

<script setup>
// 使用setup语法
import { ref } from 'vue';
import { 
  HomeFilled, 
  FolderOpened, 
  Collection, 
  InfoFilled,
  Menu,
  Close,
  Monitor
} from '@element-plus/icons-vue';

const mobileMenuOpen = ref(false);

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value;
  
  if (mobileMenuOpen.value) {
    // 当菜单打开时，禁止滚动
    document.body.style.overflow = 'hidden';
  } else {
    // 当菜单关闭时，恢复滚动
    document.body.style.overflow = '';
  }
};
</script>

<style scoped>
.blog-header {
  background-color: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  box-shadow: var(--shadow-sm);
  padding: 0;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  transition: all 0.3s ease;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 100;
  transition: all 0.3s;
  height: 70px;
}

.blog-header-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
  padding: 0 20px;
}

.blog-title-link {
  text-decoration: none;
}

.logo-container {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  background: linear-gradient(135deg, #6366f1, #8b5cf6);
  border-radius: 8px;
  color: white;
  font-size: 20px;
}

.blog-title {
  margin: 0;
  font-size: 1.5rem;
  color: #fff;
  font-weight: 600;
}

.blog-nav {
  background-color: transparent;
  border-bottom: none;
}

/* 自定义菜单样式 */
:deep(.el-menu--horizontal .el-menu-item) {
  color: rgba(255, 255, 255, 0.8);
  border-bottom: none;
  padding: 0 20px;
  height: 70px;
  line-height: 70px;
  font-size: 0.95rem;
  font-weight: 500;
  transition: all 0.3s;
}

:deep(.el-menu--horizontal .el-menu-item:hover) {
  color: white;
  background-color: rgba(255, 255, 255, 0.1);
}

:deep(.el-menu--horizontal .el-menu-item.is-active) {
  color: #6366f1;
  border-bottom: 3px solid #6366f1;
}

:deep(.el-menu--horizontal .el-menu-item .el-icon) {
  margin-right: 6px;
}

/* 移动端菜单 */
.mobile-menu-toggle {
  display: none;
  color: white;
  font-size: 24px;
  cursor: pointer;
}

.mobile-nav {
  position: fixed;
  top: 70px;
  left: 0;
  width: 100%;
  background-color: rgba(10, 25, 47, 0.95);
  backdrop-filter: blur(10px);
  padding: 20px;
  z-index: 99;
  display: flex;
  flex-direction: column;
  gap: 15px;
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
}

.mobile-nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  padding: 15px;
  border-radius: 8px;
  transition: all 0.3s;
}

.mobile-nav-item:hover, .mobile-nav-item.router-link-active {
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
}

.mobile-nav-item.router-link-exact-active {
  color: #6366f1;
  background-color: rgba(99, 102, 241, 0.1);
}

/* 移动导航动画 */
.mobile-nav-enter-active, .mobile-nav-leave-active {
  transition: all 0.3s;
}

.mobile-nav-enter-from, .mobile-nav-leave-to {
  opacity: 0;
  transform: translateY(-20px);
}

/* 响应式导航 */
@media (max-width: 768px) {
  .desktop-nav {
    display: none;
  }
  
  .mobile-menu-toggle {
    display: block;
  }
  
  .blog-header {
    height: 60px;
  }
  
  .mobile-nav {
    top: 60px;
  }
  
  :deep(.el-menu--horizontal .el-menu-item) {
    height: 60px;
    line-height: 60px;
  }
  
  .blog-title {
    font-size: 1.3rem;
  }
}
</style>