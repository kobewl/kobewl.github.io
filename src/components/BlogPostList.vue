<template>
  <div class="blog-post-list">
    <h2 class="section-title">最新文章</h2>
    <div class="posts-container">
      <div v-for="post in posts" :key="post.id" class="post-card">
        <router-link :to="`/post/${post.id}`" class="post-link">
          <h3 class="post-title">{{ post.title }}</h3>
          <div class="post-meta">
            <span class="post-date">{{ formatDate(post.date) }}</span>
            <span class="post-category">{{ post.category }}</span>
          </div>
          <p class="post-summary">{{ post.summary }}</p>
          <div class="post-tags">
            <span v-for="tag in post.tags" :key="tag" class="post-tag">{{ tag }}</span>
          </div>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BlogPostList',
  props: {
    posts: {
      type: Array,
      required: true
    }
  },
  methods: {
    formatDate(dateString) {
      const date = new Date(dateString);
      return date.toLocaleDateString('zh-CN', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    }
  }
}
</script>

<style scoped>
.blog-post-list {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;
}

.section-title {
  font-size: 2rem;
  color: var(--text-primary);
  margin-bottom: 40px;
  font-weight: 600;
  text-align: center;
}

.posts-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 30px;
}

.post-card {
  background: var(--bg-card);
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
  border: 1px solid var(--border-light);
}

.post-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
  border-color: var(--primary-light);
}

.post-link {
  display: block;
  padding: 20px;
  text-decoration: none;
  color: inherit;
}

.post-title {
  margin-top: 0;
  margin-bottom: 10px;
  font-size: 1.4rem;
  color: #333;
}

.post-meta {
  display: flex;
  gap: 15px;
  font-size: 0.85rem;
  color: #666;
  margin-bottom: 15px;
}

.post-summary {
  color: #555;
  margin-bottom: 20px;
  line-height: 1.5;
}

.post-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.post-tag {
  background-color: #f0f0f0;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.75rem;
  color: #666;
}
</style>