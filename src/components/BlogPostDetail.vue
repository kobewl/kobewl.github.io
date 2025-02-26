<template>
  <div class="blog-post-detail" v-if="post">
    <h1 class="post-title">{{ post.title }}</h1>
    <div class="post-meta">
      <span class="post-date">{{ formatDate(post.date) }}</span>
      <span class="post-category">分类：{{ post.category }}</span>
    </div>
    <div class="post-tags">
      <span v-for="tag in post.tags" :key="tag" class="post-tag">{{ tag }}</span>
    </div>
    <div class="post-content markdown-body" v-html="renderedContent"></div>
  </div>
  <div v-else class="loading">正在加载文章...</div>
</template>

<script>
import MarkdownIt from 'markdown-it'
import hljs from 'highlight.js'
// 引入更合适的代码高亮样式 - 改为 github 风格以便更好地显示代码
import 'highlight.js/styles/github.css'

export default {
  name: 'BlogPostDetail',
  props: {
    post: {
      type: Object,
      required: true,
    },
  },
  computed: {
    // 渲染Markdown内容为HTML
    renderedContent() {
      // 创建 markdown-it 实例并配置
      const md = new MarkdownIt({
        html: true,
        linkify: true,
        typographer: true,
        breaks: true, // 启用自动换行
        highlight: function (str, lang) {
          if (lang && hljs.getLanguage(lang)) {
            try {
              return (
                '<pre class="hljs"><code>' +
                hljs.highlight(str, { language: lang }).value +
                '</code></pre>'
              )
            } catch (__) {}
          }

          // 如果未指定语言或者高亮失败，使用普通代码块
          return '<pre class="hljs"><code>' + md.utils.escapeHtml(str) + '</code></pre>'
        },
      })

      // 处理特殊字符转义
      const processedContent = this.post.content
        // 确保代码块内的反引号被正确处理
        .replace(/```([a-z]*)([\s\S]*?)```/g, function (match, language, code) {
          // 处理代码块中的特殊字符
          return '```' + language + code.replace(/`/g, '\\`') + '```'
        })

      return md.render(processedContent || '')
    },
  },
  methods: {
    formatDate(dateString) {
      const date = new Date(dateString)
      return date.toLocaleDateString('zh-CN', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
      })
    },
  },
}
</script>

<style>
/* 非 scoped 样式，确保可以影响 v-html 内容 */
.markdown-body {
  color: #24292e;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
  font-size: 16px;
  line-height: 1.5;
  word-wrap: break-word;
  background-color: #fff;
  padding: 20px;
  border-radius: 8px;
}

.markdown-body pre {
  background-color: #f6f8fa;
  border-radius: 6px;
  padding: 16px;
  overflow: auto;
  margin: 1em 0;
}

/* 内联代码样式 */
.markdown-body code {
  font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
  font-size: 85%;
  padding: 0.2em 0.4em;
  margin: 0;
  background-color: rgba(27, 31, 35, 0.05);
  border-radius: 3px;
}

/* 代码块中的代码不应用内联代码样式 */
.markdown-body pre code {
  background-color: transparent;
  padding: 0;
  margin: 0;
  font-size: 100%;
  word-break: normal;
  white-space: pre;
  overflow: visible;
}

.markdown-body blockquote {
  padding: 0 1em;
  color: #6a737d;
  border-left: 0.25em solid #dfe2e5;
  margin: 1em 0;
}

.markdown-body h1,
.markdown-body h2 {
  border-bottom: 1px solid #eaecef;
  padding-bottom: 0.3em;
}

.markdown-body h1,
.markdown-body h2,
.markdown-body h3,
.markdown-body h4,
.markdown-body h5,
.markdown-body h6 {
  margin-top: 24px;
  margin-bottom: 16px;
  font-weight: 600;
  line-height: 1.25;
}

.markdown-body ul,
.markdown-body ol {
  padding-left: 2em;
  margin-top: 0;
  margin-bottom: 16px;
}

.markdown-body table {
  border-collapse: collapse;
  width: 100%;
  margin: 1em 0;
}

.markdown-body table th,
.markdown-body table td {
  padding: 6px 13px;
  border: 1px solid #dfe2e5;
}

.markdown-body table tr {
  background-color: #fff;
  border-top: 1px solid #c6cbd1;
}

.markdown-body table tr:nth-child(2n) {
  background-color: #f6f8fa;
}
</style>

<style scoped>
.blog-post-detail {
  max-width: 850px;
  margin: 40px auto;
  padding: 0 20px;
}

.post-title {
  font-size: 2.2rem;
  margin-bottom: 15px;
  color: #333;
}

.post-meta {
  display: flex;
  gap: 20px;
  color: #666;
  margin-bottom: 20px;
  font-size: 0.9rem;
}

.post-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 30px;
}

.post-tag {
  background-color: #f0f0f0;
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 0.8rem;
  color: #666;
}

.post-content {
  line-height: 1.7;
  color: #333;
  font-size: 1.05rem;
}

.post-content h1,
.post-content h2,
.post-content h3,
.post-content h4,
.post-content h5,
.post-content h6 {
  margin-top: 1.5em;
  margin-bottom: 0.8em;
  color: #333;
}

.post-content p {
  margin-bottom: 1.2em;
}

.post-content img {
  max-width: 100%;
  height: auto;
  border-radius: 5px;
  margin: 10px 0;
}

.post-content a {
  color: #3498db;
  text-decoration: none;
}

.post-content a:hover {
  text-decoration: underline;
}

.post-content pre {
  background-color: #f6f8fa;
  border-radius: 5px;
  padding: 15px;
  overflow-x: auto;
  margin: 20px 0;
}

.post-content code {
  font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
  font-size: 0.9em;
}

.post-content blockquote {
  border-left: 4px solid #dfe2e5;
  padding-left: 15px;
  color: #6a737d;
  margin: 20px 0;
}

.loading {
  text-align: center;
  font-size: 1.2rem;
  color: #666;
  margin: 80px 0;
}
</style>
