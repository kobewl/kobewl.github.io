<template>
  <div class="categories-view">
    <h1 class="page-title">文章分类</h1>
    <CategoryList :categories="categories" />
  </div>
</template>

<script>
import CategoryList from '@/components/CategoryList.vue';

export default {
  name: 'CategoriesView',
  components: {
    CategoryList
  },
  data() {
    return {
      categories: [
        // 示例数据，实际应用中应从API或Markdown文件获取
        { name: 'Java', count: 15 },
        { name: 'Python', count: 8 },
        { name: 'JavaScript', count: 12 },
        { name: 'Linux', count: 7 },
        { name: '数据结构与算法', count: 10 },
        { name: '设计模式', count: 5 },
        { name: '数据库', count: 9 },
        { name: '计算机网络', count: 6 },
        { name: '分布式', count: 4 },
        { name: '中间件', count: 3 },
        { name: 'Java框架', count: 11 },
        { name: 'GitHub', count: 2 },
        { name: 'AI IDE', count: 3 },
        { name: '面试', count: 8 },
        { name: '书籍', count: 5 },
        { name: '日记', count: 7 },
        { name: 'English Learning', count: 4 },
        { name: 'Poetry Learning', count: 2 }
      ]
    };
  }
}
</script>

<style scoped>
.categories-view {
  min-height: 100vh;
  padding: 20px;
}

.page-title {
  max-width: 1200px;
  margin: 40px auto 20px;
  font-size: 2.2rem;
  color: #333;
  text-align: center;
}
</style> 