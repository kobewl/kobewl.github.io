<template>
  <div class="home">
    <section class="hero">
      <div class="hero-content">
        <div class="avatar-container">
          <img
            v-if="useGithubAvatar"
            src="/avatar.png"
            class="profile-avatar github-avatar"
            alt="GitHub头像"
          />
          <el-avatar v-else :size="140" class="profile-avatar">
            <el-icon :size="80"><UserFilled /></el-icon>
          </el-avatar>
          <div class="avatar-glow"></div>
        </div>
        <QuoteDisplay />
        <p class="hero-subtitle">记录技术、分享生活、思考未来</p>
        <div class="social-links">
          <a href="https://github.com" target="_blank" class="social-btn github-btn">
            <el-icon><Platform /></el-icon>
          </a>
          <a href="#" class="social-btn twitter-btn">
            <el-icon><ChatDotSquare /></el-icon>
          </a>
          <a href="mailto:example@example.com" class="social-btn email-btn">
            <el-icon><Message /></el-icon>
          </a>
        </div>
        <div class="scroll-down" @click="scrollToContent">
          <span>发现更多</span>
          <el-icon><ArrowDown /></el-icon>
        </div>
      </div>
      <div class="hero-background">
        <div class="particles"></div>
      </div>
    </section>

    <section class="post-section" id="content">
      <div class="post-container">
        <h2 class="section-title">最新文章</h2>
        <el-row :gutter="30">
          <el-col :xs="24" :sm="12" :md="8" v-for="post in posts" :key="post.id">
            <el-card class="post-card" shadow="hover">
              <div class="post-card-content">
                <div class="post-category-label">{{ post.category }}</div>
                <router-link :to="`/post/${post.id}`" class="post-link">
                  <h3 class="post-title">{{ post.title }}</h3>
                  <div class="post-meta">
                    <span class="post-date">
                      <el-icon><Calendar /></el-icon>
                      {{ formatDate(post.date) }}
                    </span>
                  </div>
                  <p class="post-summary">{{ post.summary }}</p>
                  <div class="post-tags">
                    <el-tag
                      v-for="tag in post.tags"
                      :key="tag"
                      size="small"
                      effect="plain"
                      class="post-tag"
                    >
                      {{ tag }}
                    </el-tag>
                  </div>
                  <div class="read-more">
                    <span>阅读全文</span>
                    <el-icon><ArrowRight /></el-icon>
                  </div>
                </router-link>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </section>

    <section class="featured-section">
      <div class="featured-container">
        <h2 class="section-title">推荐分类</h2>
        <div class="featured-categories">
          <router-link
            to="/category/Java"
            class="featured-category"
            style="background: linear-gradient(135deg, #ff9a9e 0%, #fad0c4 100%)"
          >
            <el-icon :size="36"><TopRight /></el-icon>
            <h3>Java</h3>
            <p>15 篇文章</p>
          </router-link>
          <router-link
            to="/category/Python"
            class="featured-category"
            style="background: linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%)"
          >
            <el-icon :size="36"><Connection /></el-icon>
            <h3>Python</h3>
            <p>8 篇文章</p>
          </router-link>
          <router-link
            to="/category/JavaScript"
            class="featured-category"
            style="background: linear-gradient(135deg, #f6d365 0%, #fda085 100%)"
          >
            <el-icon :size="36"><Operation /></el-icon>
            <h3>JavaScript</h3>
            <p>12 篇文章</p>
          </router-link>
          <router-link
            to="/category/Vue"
            class="featured-category"
            style="background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%)"
          >
            <el-icon :size="36"><Histogram /></el-icon>
            <h3>Vue</h3>
            <p>9 篇文章</p>
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import {
  Calendar,
  FolderOpened,
  Message,
  Platform,
  ArrowDown,
  UserFilled,
  ArrowRight,
  ChatDotSquare,
  TopRight,
  Connection,
  Operation,
  Histogram,
} from '@element-plus/icons-vue'
import { onMounted, ref } from 'vue'
import QuoteDisplay from '@/components/QuoteDisplay.vue'

// 控制是否使用GitHub头像
const useGithubAvatar = ref(true)

// 示例数据
const posts = [
  {
    id: '1',
    title: 'Java基础知识',
    date: '2023-01-01',
    category: 'Java',
    summary: 'Java的基础知识，包括语法、面向对象编程等内容',
    tags: ['Java', '编程语言'],
  },
  {
    id: '2',
    title: 'Java集合',
    date: '2023-01-02',
    category: 'Java',
    summary: '详解Java集合框架，包括List、Set、Map等数据结构的使用',
    tags: ['Java', '集合框架', '数据结构'],
  },
  {
    id: '3',
    title: 'Java异常处理',
    date: '2023-01-03',
    category: 'Java',
    summary: 'Java异常处理机制，包括异常的捕获、抛出和自定义异常',
    tags: ['Java', '异常处理'],
  },
  {
    id: '4',
    title: 'JavaScript ES6特性',
    date: '2023-01-04',
    category: 'JavaScript',
    summary: 'ES6引入的新特性，包括箭头函数、解构赋值、Promise等',
    tags: ['JavaScript', 'ES6', '前端'],
  },
  {
    id: '5',
    title: 'Vue 3组合式API',
    date: '2023-01-05',
    category: 'Vue',
    summary: 'Vue 3组合式API的使用方法和最佳实践',
    tags: ['Vue', '前端', '组合式API'],
  },
  {
    id: '6',
    title: 'Python数据分析',
    date: '2023-01-06',
    category: 'Python',
    summary: '使用Python进行数据分析，包括Pandas、NumPy等库的使用',
    tags: ['Python', '数据分析', 'Pandas'],
  },
]

// 格式化日期
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

// 社交媒体导航
const navigateToSocial = (platform) => {
  // 实际应用中应该跳转到对应的社交媒体页面
  console.log(`Navigate to ${platform}`)
}

// 滚动到内容部分
const scrollToContent = () => {
  document.getElementById('content').scrollIntoView({
    behavior: 'smooth',
  })
}

// 粒子效果
onMounted(() => {
  const createParticles = () => {
    const particles = document.querySelector('.particles')
    if (!particles) return

    particles.innerHTML = ''

    // 创建星星
    for (let i = 0; i < 50; i++) {
      const particle = document.createElement('div')
      particle.classList.add('particle')
      particle.style.top = `${Math.random() * 100}%`
      particle.style.left = `${Math.random() * 100}%`
      const size = Math.random() * 5 + 1
      particle.style.width = `${size}px`
      particle.style.height = `${size}px`
      particle.style.opacity = Math.random() * 0.5 + 0.1
      particle.style.animationDelay = `${Math.random() * 2}s`
      particle.style.animationDuration = `${Math.random() * 8 + 4}s`
      particles.appendChild(particle)
    }

    // 创建流星
    const createMeteor = () => {
      const meteor = document.createElement('div')
      meteor.classList.add('meteor')
      meteor.style.top = `${Math.random() * 60}%`  // 扩大流星出现的高度范围
      meteor.style.left = `${Math.random() * 150 + 100}%`  // 让流星从更分散的位置开始
      meteor.style.animationDuration = `${Math.random() * 1.2 + 0.6}s`  // 增加动画持续时间
      particles.appendChild(meteor)

      // 流星消失后移除DOM元素
      meteor.addEventListener('animationend', () => {
        meteor.remove()
      })
    }

    // 定期创建新的流星，进一步增加频率
    setInterval(createMeteor, 100)  // 更高的生成频率
    // 初始创建大量流星
    for (let i = 0; i < 20; i++) {  // 显著增加初始流星数量
      setTimeout(() => createMeteor(), i * 50)  // 更短的初始创建间隔
    }
  }

  createParticles()
})
</script>

<style scoped>
.home {
  min-height: 100vh;
}

/* 英雄区域 - 设置为满屏 */
.hero {
  height: 100vh;
  width: 100%;
  background-color: #0a192f;
  background-image: linear-gradient(to bottom right, #0a192f, #112240, #233554);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  position: relative;
  overflow: hidden;
  padding: 0;
  margin: 0;
}

.hero-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
  overflow: hidden;
}

.particles {
  width: 100%;
  height: 100%;
  position: absolute;
}

.particle {
  position: absolute;
  background-color: rgba(255, 255, 255, 0.7);
  border-radius: 50%;
  animation: float linear infinite;
}

/* 添加流星雨效果 */
.meteor {
  position: absolute;
  width: 4px;
  height: 4px;
  background: linear-gradient(to right, rgba(255, 255, 255, 1), transparent 90%);
  animation: meteor linear forwards;
  transform: rotate(-45deg);
  z-index: 2;
  box-shadow: 0 0 20px rgba(255, 255, 255, 0.9), 0 0 40px rgba(255, 255, 255, 0.4);
}

.meteor::before {
  content: '';
  position: absolute;
  width: 300px;
  height: 2px;
  background: linear-gradient(to right, rgba(255, 255, 255, 1), transparent 90%);
  box-shadow: 0 0 40px rgba(255, 255, 255, 0.5);
}

@keyframes meteor {
  0% {
    transform: translate(0, 0) rotate(-45deg) scale(1.5);
    opacity: 1;
  }
  30% {
    transform: translate(-100%, 100%) rotate(-45deg) scale(1);
    opacity: 0.8;
  }
  100% {
    transform: translate(-300%, 300%) rotate(-45deg) scale(0.5);
    opacity: 0;
  }
}

@keyframes float {
  0% {
    transform: translateY(0) translateX(0);
  }
  25% {
    transform: translateY(-20px) translateX(10px);
  }
  50% {
    transform: translateY(-40px) translateX(0);
  }
  75% {
    transform: translateY(-20px) translateX(-10px);
  }
  100% {
    transform: translateY(0) translateX(0);
  }
}

.hero-content {
  text-align: center;
  max-width: 900px;
  padding: 0 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 2;
  position: relative;
}

.avatar-container {
  position: relative;
  margin-bottom: 30px;
}

.profile-avatar {
  background: linear-gradient(135deg, #6366f1, #8b5cf6);
  border: 4px solid rgba(255, 255, 255, 0.1);
  position: relative;
  z-index: 2;
}

.github-avatar {
  width: 140px;
  height: 140px;
  border-radius: 50%;
  object-fit: cover;
}

.avatar-glow {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 140px;
  height: 140px;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  background: rgba(99, 102, 241, 0.3);
  filter: blur(20px);
  animation: pulse 3s infinite;
}

@keyframes pulse {
  0% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.5;
  }
  50% {
    transform: translate(-50%, -50%) scale(1.2);
    opacity: 0.3;
  }
  100% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.5;
  }
}

.hero-title {
  font-size: 2.2rem;
  margin: 0 0 20px;
  line-height: 1.4;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.95);
  animation: fadeInUp 0.8s ease-out;
}

.hero-subtitle {
  font-size: 1.2rem;
  margin: 0 0 30px;
  color: rgba(255, 255, 255, 0.7);
  animation: fadeInUp 1s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.social-links {
  display: flex;
  gap: 15px;
  margin: 20px 0 40px;
  animation: fadeInUp 1.2s ease-out;
}

.social-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 48px;
  background-color: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: white;
  transition: all 0.3s;
  backdrop-filter: blur(10px);
  border-radius: 50%;
  text-decoration: none;
}

.social-btn:hover {
  background-color: rgba(255, 255, 255, 0.15);
  border-color: white;
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
}

.github-btn:hover {
  background-color: #24292e;
}

.twitter-btn:hover {
  background-color: #1da1f2;
}

.email-btn:hover {
  background-color: #ea4335;
}

.scroll-down {
  position: absolute;
  bottom: 40px;
  display: flex;
  flex-direction: column;
  align-items: center;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
  cursor: pointer;
  animation: bounce 2s infinite;
  transition: all 0.3s;
}

.scroll-down:hover {
  color: white;
}

@keyframes bounce {
  0%,
  20%,
  50%,
  80%,
  100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-10px);
  }
  60% {
    transform: translateY(-5px);
  }
}

/* 文章区域 */
.post-section {
  padding: 100px 0 80px;
  background-color: #f7f9fc;
}

.post-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.section-title {
  font-size: 2.2rem;
  color: #333;
  margin-bottom: 60px;
  text-align: center;
  position: relative;
  font-weight: 600;
}

.section-title:after {
  content: '';
  position: absolute;
  width: 80px;
  height: 3px;
  background: linear-gradient(90deg, #6366f1, #8b5cf6);
  bottom: -15px;
  left: 50%;
  transform: translateX(-50%);
  border-radius: 3px;
}

.post-card {
  margin-bottom: 40px;
  height: 100%;
  transition: all 0.4s;
  border: none;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
  border-radius: 12px;
  overflow: hidden;
}

.post-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

.post-card-content {
  position: relative;
  padding: 25px;
}

.post-category-label {
  position: absolute;
  top: -12px;
  left: 25px;
  background: linear-gradient(90deg, #6366f1, #8b5cf6);
  color: white;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 500;
  box-shadow: 0 5px 15px rgba(107, 114, 255, 0.3);
}

.post-link {
  text-decoration: none;
  color: inherit;
  display: block;
}

.post-title {
  margin-top: 15px;
  margin-bottom: 15px;
  font-size: 1.4rem;
  color: #333;
  transition: color 0.3s;
  line-height: 1.4;
}

.post-link:hover .post-title {
  color: #6366f1;
}

.post-meta {
  display: flex;
  font-size: 0.85rem;
  color: #666;
  margin-bottom: 15px;
  align-items: center;
}

.post-date {
  display: flex;
  align-items: center;
  gap: 5px;
}

.post-summary {
  color: #555;
  margin-bottom: 20px;
  line-height: 1.6;
}

.post-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 25px;
}

.post-tag {
  background-color: rgba(99, 102, 241, 0.1);
  border-color: rgba(99, 102, 241, 0.2);
  color: #6366f1;
}

.read-more {
  display: flex;
  align-items: center;
  gap: 5px;
  color: #6366f1;
  font-weight: 500;
  transition: gap 0.3s;
}

.post-link:hover .read-more {
  gap: 10px;
}

/* 推荐分类区域 */
.featured-section {
  padding: 80px 0;
  background-color: white;
}

.featured-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.featured-categories {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 30px;
}

.featured-category {
  background-color: #f5f5f5;
  padding: 30px;
  border-radius: 16px;
  text-decoration: none;
  color: white;
  transition: all 0.3s;
  display: flex;
  flex-direction: column;
  position: relative;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
}

.featured-category h3 {
  font-size: 1.6rem;
  margin: 20px 0 10px;
}

.featured-category p {
  margin: 0;
  opacity: 0.9;
}

.featured-category:hover {
  transform: translateY(-10px);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .hero-title {
    font-size: 1.7rem;
  }

  .hero-subtitle {
    font-size: 1rem;
  }

  .section-title {
    font-size: 1.8rem;
  }

  .featured-categories {
    grid-template-columns: 1fr;
  }
}
</style>
