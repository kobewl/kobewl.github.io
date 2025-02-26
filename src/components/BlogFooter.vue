<template>
  <el-footer class="blog-footer">
    <div class="footer-content">
      <el-row :gutter="30">
        <el-col :xs="24" :sm="24" :md="8">
          <div class="footer-section">
            <h3>关于博客</h3>
            <p>这是我的个人技术博客，记录学习和工作中的点滴，分享知识和经验，希望我的文章能对你有所帮助。</p>
            <div class="social-links">
              <a href="#" class="social-link">
                <el-icon><Platform /></el-icon>
              </a>
              <a href="#" class="social-link">
                <el-icon><Message /></el-icon>
              </a>
              <a href="#" class="social-link">
                <el-icon><ChatDotSquare /></el-icon>
              </a>
            </div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <div class="footer-section">
            <h3>快速链接</h3>
            <ul class="quick-links">
              <li>
                <router-link to="/">首页</router-link>
              </li>
              <li>
                <router-link to="/categories">分类</router-link>
              </li>
              <li>
                <router-link to="/tags">标签</router-link>
              </li>
              <li>
                <router-link to="/about">关于</router-link>
              </li>
            </ul>
          </div>
        </el-col>
        <el-col :xs="24" :sm="12" :md="8">
          <div class="footer-section">
            <h3>技术栈</h3>
            <div class="tech-tags">
              <span class="tech-tag">Vue 3</span>
              <span class="tech-tag">Element Plus</span>
              <span class="tech-tag">JavaScript</span>
              <span class="tech-tag">CSS3</span>
              <span class="tech-tag">HTML5</span>
              <span class="tech-tag">Node.js</span>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
    <div class="copyright">
      <div class="divider"></div>
      <p>© {{ new Date().getFullYear() }} 我的个人博客 | 基于 <a href="https://vuejs.org/" target="_blank">Vue 3</a> + <a href="https://element-plus.org/" target="_blank">Element Plus</a> 构建</p>
    </div>
  </el-footer>
</template>

<script setup>
import { Message, Platform, ChatDotSquare } from '@element-plus/icons-vue';
</script>

<style scoped>
.blog-footer {
  background-color: var(--dark-bg);
  background-image: linear-gradient(to bottom right, #0a192f, #112240);
  padding: 80px 20px 30px;
  color: rgba(255, 255, 255, 0.8);
  margin-top: 0;
  height: auto;
  position: relative;
}

.blog-footer::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, var(--primary-color), var(--primary-light));
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  margin-bottom: 50px;
}

.footer-section {
  margin-bottom: 40px;
}

.footer-section h3 {
  color: #fff;
  font-size: 1.2rem;
  margin-bottom: 20px;
  position: relative;
  display: inline-block;
  font-weight: 600;
}

.footer-section h3:after {
  content: '';
  position: absolute;
  bottom: -8px;
  left: 0;
  width: 40px;
  height: 2px;
  background: linear-gradient(90deg, var(--primary-color), var(--primary-light));
}

.footer-section p {
  line-height: 1.7;
  margin-bottom: 20px;
}

.social-links {
  display: flex;
  gap: 15px;
  margin-top: 20px;
}

.social-link {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  background-color: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  color: white;
  transition: all 0.3s;
}

.social-link:hover {
  background-color: var(--primary-color);
  transform: translateY(-3px);
}

.quick-links {
  list-style: none;
  padding: 0;
}

.quick-links li {
  margin-bottom: 12px;
}

.quick-links a {
  color: rgba(255, 255, 255, 0.8);
  text-decoration: none;
  transition: all 0.3s;
  display: inline-block;
  padding: 3px 0;
}

.quick-links a:hover {
  color: var(--primary-light);
  transform: translateX(5px);
}

.tech-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.tech-tag {
  background-color: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.9);
  padding: 5px 12px;
  border-radius: 20px;
  font-size: 0.85rem;
  transition: all 0.3s;
}

.tech-tag:hover {
  background-color: rgba(99, 102, 241, 0.3);
  transform: translateY(-2px);
}

.divider {
  height: 1px;
  background: linear-gradient(to right, transparent, rgba(255, 255, 255, 0.1), transparent);
  margin-bottom: 25px;
}

.copyright {
  text-align: center;
  font-size: 0.9rem;
  opacity: 0.8;
}

.copyright a {
  color: var(--primary-light);
  transition: all 0.3s;
}

.copyright a:hover {
  color: white;
}

@media (max-width: 768px) {
  .blog-footer {
    padding: 60px 20px 30px;
  }
  
  .footer-section {
    margin-bottom: 30px;
  }
}
</style> 