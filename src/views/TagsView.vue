<template>
  <div class="tags-view">
    <h1 class="page-title">标签云</h1>
    <TagList :tags="tags" />
  </div>
</template>

<script>
import TagList from '@/components/TagList.vue';

export default {
  name: 'TagsView',
  components: {
    TagList
  },
  data() {
    return {
      tags: [
        // 示例数据，实际应用中应从API或Markdown文件获取
        { name: 'Java', count: 15 },
        { name: 'Python', count: 8 },
        { name: 'JavaScript', count: 12 },
        { name: 'CSS', count: 5 },
        { name: 'HTML', count: 7 },
        { name: 'Vue', count: 9 },
        { name: 'React', count: 6 },
        { name: 'Node.js', count: 8 },
        { name: '算法', count: 10 },
        { name: '数据结构', count: 9 },
        { name: '设计模式', count: 7 },
        { name: '网络编程', count: 5 },
        { name: '多线程', count: 11 },
        { name: '并发编程', count: 9 },
        { name: '数据库', count: 14 },
        { name: 'MySQL', count: 10 },
        { name: 'Redis', count: 7 },
        { name: 'MongoDB', count: 5 },
        { name: '微服务', count: 8 },
        { name: 'Spring', count: 12 },
        { name: 'Spring Boot', count: 9 },
        { name: 'Spring Cloud', count: 7 },
        { name: '面试', count: 15 },
        { name: '笔记', count: 10 },
        { name: '学习', count: 12 },
        { name: '工具', count: 8 },
        { name: 'IDE', count: 6 },
        { name: 'Git', count: 9 },
        { name: 'Linux', count: 11 },
        { name: 'Docker', count: 7 }
      ]
    };
  }
}
</script>

<style scoped>
.tags-view {
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