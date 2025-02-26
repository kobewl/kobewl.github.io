<template>
  <div class="tag-list">
    <h2 class="section-title">标签云</h2>
    <div class="tags-container">
      <router-link 
        v-for="tag in tags" 
        :key="tag.name" 
        :to="`/tag/${tag.name}`"
        class="tag-item"
        :style="{ fontSize: tagSize(tag.count) }"
      >
        {{ tag.name }} ({{ tag.count }})
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TagList',
  props: {
    tags: {
      type: Array,
      required: true
    }
  },
  methods: {
    // 根据文章数量动态设置标签大小
    tagSize(count) {
      const minCount = Math.min(...this.tags.map(t => t.count));
      const maxCount = Math.max(...this.tags.map(t => t.count));
      const minSize = 0.8;
      const maxSize = 1.8;
      
      if (minCount === maxCount) return `${minSize}rem`;
      
      const size = minSize + (count - minCount) * (maxSize - minSize) / (maxCount - minCount);
      return `${size}rem`;
    }
  }
}
</script>

<style scoped>
.tag-list {
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

.tags-container {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  padding: 30px;
  background: var(--bg-card);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--border-light);
}

.tag-item {
  color: var(--text-secondary);
  text-decoration: none;
  padding: 8px 16px;
  border-radius: var(--radius-md);
  background-color: rgba(99, 102, 241, 0.1);
  border: 1px solid rgba(99, 102, 241, 0.2);
  transition: all 0.3s ease;
  font-weight: 500;
}

.tag-item:hover {
  background-color: var(--primary-color);
  color: var(--text-white);
  border-color: var(--primary-color);
  transform: translateY(-2px);
}
</style>