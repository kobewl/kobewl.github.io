<template>
  <div class="quote-container">
    <div class="quote-text" :class="{ 'typing': isTyping }">
      {{ displayedText }}
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'

const quote = ref('')
const displayedText = ref('')
const isTyping = ref(false)
let typingTimer = null

// 模拟API调用获取随机语录
const fetchQuote = async () => {
  try {
    const response = await fetch('https://v1.hitokoto.cn')
    const data = await response.json()
    return data.hitokoto
  } catch (error) {
    console.error('获取语录失败:', error)
    return '生活不止眼前的苟且，还有诗和远方。' // 默认语录
  }
}

// 打字机效果
const typeWriter = (text) => {
  isTyping.value = true
  displayedText.value = ''
  let i = 0
  
  clearInterval(typingTimer)
  typingTimer = setInterval(() => {
    if (i < text.length) {
      displayedText.value += text.charAt(i)
      i++
    } else {
      clearInterval(typingTimer)
      isTyping.value = false
    }
  }, 100)
}

// 更新语录
const updateQuote = async () => {
  const newQuote = await fetchQuote()
  quote.value = newQuote
  typeWriter(newQuote)
}

onMounted(() => {
  updateQuote()
})

onBeforeUnmount(() => {
  if (typingTimer) {
    clearInterval(typingTimer)
  }
})
</script>

<style scoped>
.quote-container {
  margin: 20px 0;
  padding: 20px;
  text-align: center;
  width: 100%;
  max-width: 800px;
}

.quote-text {
  font-size: 2.2rem;
  color: rgba(255, 255, 255, 0.95);
  line-height: 1.4;
  margin: 0 0 20px;
  min-height: 2.4em;
  font-weight: 600;
  animation: fadeInUp 0.8s ease-out;
}

.quote-text.typing::after {
  content: '|';
  animation: blink 1s infinite;
  margin-left: 4px;
}

@keyframes blink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0; }
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
</style>