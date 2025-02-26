<template>
  <div class="category-list">
    <h2 class="section-title">文章分类</h2>
    <div class="categories-container">
      <router-link 
        v-for="category in categories" 
        :key="category.name" 
        :to="`/category/${category.name}`"
        class="category-item"
      >
        <div class="category-name">{{ category.name }}</div>
        <div class="category-count">{{ category.count }} 篇文章</div>
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CategoryList',
  props: {
    categories: {
      type: Array,
      required: true
    }
  }
}
</script>

<style scoped>
.category-list {
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

.categories-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 25px;
}

.category-item {
  background: var(--bg-card);
  padding: 25px;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  transition: all 0.3s ease;
  text-decoration: none;
  color: inherit;
  display: flex;
  flex-direction: column;
  border: 1px solid var(--border-light);
}

.category-item:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
  border-color: var(--primary-light);
}

.category-name {
  font-size: 1.3rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 10px;
}

.category-count {
  font-size: 0.95rem;
  color: var(--text-secondary);
}
</style>