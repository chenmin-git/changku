<template>
  <div class="assistant-workspace">
    <aside class="assistant-panel">
      <div class="panel-title">
        <el-icon><DataAnalysis /></el-icon>
        <div>
          <strong>库存洞察</strong>
          <span>实时读取库存、预警、出入库和待办数据</span>
        </div>
      </div>

      <div class="metric-grid">
        <button v-for="card in contextCards" :key="card.title" class="metric" @click="go(card.path)">
          <span>{{ card.title }}</span>
          <strong>{{ card.value }}</strong>
        </button>
      </div>

      <div class="quick-section">
        <h3>分析工具箱</h3>
        <button v-for="item in toolPrompts" :key="item.title" class="tool-btn" :disabled="loading" @click="ask(item.prompt)">
          <el-icon><component :is="item.icon" /></el-icon>
          <span>{{ item.title }}</span>
          <small>{{ item.desc }}</small>
        </button>
      </div>

      <div class="quick-section">
        <h3>高风险货品</h3>
        <div v-if="riskGoods.length" class="risk-list">
          <div v-for="item in riskGoods" :key="item.name || item.goods_name" class="risk-item">
            <span>{{ item.name || item.goods_name }}</span>
            <small>库存 {{ item.stock_quantity ?? item.current_stock }} / 下限 {{ item.min_stock }}</small>
          </div>
        </div>
        <el-empty v-else description="暂无风险数据" :image-size="72" />
      </div>
    </aside>

    <section class="chat-shell">
      <div class="chat-header">
        <div>
          <h2>智能库存助手</h2>
          <p>支持补货建议、预警解读、出入库趋势、盘点优先级和自然语言库存问答。</p>
        </div>
        <div class="chat-tools">
          <el-tag :type="loading ? 'warning' : 'success'">{{ loading ? '正在生成' : provider }}</el-tag>
          <el-button v-if="loading" icon="Close" @click="cancelStream">停止</el-button>
          <el-button icon="Delete" @click="clearChat">清空</el-button>
        </div>
      </div>

      <el-scrollbar ref="scrollbarRef" class="message-scroll">
        <div class="messages">
          <div v-for="message in messages" :key="message.id" class="message" :class="message.role">
            <div class="avatar">
              <el-icon><component :is="message.role === 'assistant' ? 'Service' : 'User'" /></el-icon>
            </div>
            <div class="bubble">
              <div class="meta">
                <span>{{ message.role === 'assistant' ? '智能助手' : '我' }} · {{ message.time }}</span>
                <el-button v-if="message.role === 'assistant' && message.content" text size="small" icon="CopyDocument" @click="copyText(message.content)">复制</el-button>
              </div>
              <div v-if="message.pending && !message.content" class="typing">
                <span></span><span></span><span></span> 正在分析库存数据...
              </div>
              <div v-else class="content markdown-body" v-html="renderMarkdown(message.content)"></div>
              <div v-if="message.notice" class="notice">{{ message.notice }}</div>
            </div>
          </div>
        </div>
      </el-scrollbar>

      <div class="suggestions" v-if="suggestions.length">
        <el-button v-for="item in suggestions" :key="item" size="small" plain :disabled="loading" @click="ask(item)">{{ item }}</el-button>
      </div>

      <div class="composer">
        <el-input
          v-model="question"
          type="textarea"
          :rows="3"
          resize="none"
          placeholder="输入库存相关问题，例如：哪些货品需要优先补货？"
          @keydown.enter.exact.prevent="submit"
        />
        <div class="composer-actions">
          <span class="muted">Enter 发送，Shift + Enter 换行；回答会流式显示</span>
          <el-button type="primary" icon="Promotion" :loading="loading" @click="submit">发送</el-button>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { computed, nextTick, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { askAssistantContext } from '../api'
import { clearAuthAndRedirect } from '../utils/request'

const toolPrompts = [
  { title: '生成补货计划', desc: '按安全库存和缺口排序', icon: 'ShoppingCart', prompt: '请基于当前库存生成补货计划，并列出优先级。' },
  { title: '高风险预警', desc: '解释风险原因和处理建议', icon: 'Warning', prompt: '分析当前高风险库存预警，并给出处理顺序。' },
  { title: '7天趋势总结', desc: '解读近 7 天入出库变化', icon: 'TrendCharts', prompt: '总结近 7 天入出库趋势，并指出需要关注的异常。' },
  { title: '盘点任务清单', desc: '按风险生成盘点优先级', icon: 'Checked', prompt: '生成本周库存盘点任务清单，并说明优先级。' },
  { title: '按仓库建议', desc: '分仓库生成补货建议', icon: 'OfficeBuilding', prompt: '按仓库维度给出补货和调拨建议。' },
  { title: '待办优先级', desc: '解释待审核、待出库和预警顺序', icon: 'Tickets', prompt: '解释当前待处理事项的优先级，并给出处理路径。' }
]
const router = useRouter()
const question = ref('')
const loading = ref(false)
const provider = ref('系统默认 AI 服务')
const suggestions = ref([])
const context = ref({ cards: [], lowGoods: [], alerts: [], weekTrend: [], pendingTodos: [] })
const scrollbarRef = ref()
const controller = ref(null)
const messages = ref([
  {
    id: Date.now(),
    role: 'assistant',
    time: new Date().toLocaleTimeString(),
    content: '你好，我可以根据库存、入库、出库、盘点和预警数据生成建议。你可以直接提问，也可以点击左侧分析工具箱。'
  }
])

const contextCards = computed(() => context.value.pendingTodos || context.value.cards || [])
const riskGoods = computed(() => {
  const alerts = context.value.alerts || []
  const lowGoods = context.value.lowGoods || []
  return alerts.length ? alerts.slice(0, 5) : lowGoods.slice(0, 5)
})

const escapeHtml = (text) => String(text)
  .replace(/&/g, '&amp;')
  .replace(/</g, '&lt;')
  .replace(/>/g, '&gt;')

const renderMarkdown = (text = '') => {
  const inline = (value) => escapeHtml(value)
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/`([^`]+)`/g, '<code>$1</code>')
  const normalized = String(text)
    .replace(/\r\n/g, '\n')
    .replace(/[ \t]+(#{1,6}\s+)/g, '\n$1')
    .replace(/[ \t]+([-*]\s+)/g, '\n$1')
    .replace(/[ \t]+(\d+[.、]\s*)/g, '\n$1')
  const lines = normalized.split('\n')
  const html = []
  let listType = ''

  const closeList = () => {
    if (listType) {
      html.push(`</${listType}>`)
      listType = ''
    }
  }
  const openList = (type) => {
    if (listType !== type) {
      closeList()
      listType = type
      html.push(`<${type}>`)
    }
  }

  for (const rawLine of lines) {
    const line = rawLine.trim()
    if (!line) {
      closeList()
      continue
    }
    if (/^#{1,6}\s+/.test(line)) {
      closeList()
      const level = Math.min(line.match(/^#+/)?.[0].length || 3, 4)
      html.push(`<h${level}>${inline(line.replace(/^#{1,6}\s+/, ''))}</h${level}>`)
      continue
    }
    if (/^[-*]\s+/.test(line)) {
      openList('ul')
      html.push(`<li>${inline(line.replace(/^[-*]\s+/, ''))}</li>`)
      continue
    }
    if (/^\d+[.、]\s*/.test(line)) {
      openList('ol')
      html.push(`<li>${inline(line.replace(/^\d+[.、]\s*/, ''))}</li>`)
      continue
    }
    closeList()
    html.push(`<p>${inline(line)}</p>`)
  }
  closeList()
  return html.join('')
}

const scrollBottom = async () => {
  await nextTick()
  const wrap = scrollbarRef.value?.wrapRef
  if (wrap) wrap.scrollTop = wrap.scrollHeight
}

const pushMessage = (role, content, extra = {}) => {
  const message = { id: Date.now() + Math.random(), role, content, time: new Date().toLocaleTimeString(), ...extra }
  messages.value.push(message)
  scrollBottom()
  return message.id
}

const patchMessage = (id, patch) => {
  const index = messages.value.findIndex(item => item.id === id)
  if (index >= 0) {
    messages.value[index] = { ...messages.value[index], ...patch }
  }
}

const appendMessageContent = (id, text) => {
  if (!text) return
  const index = messages.value.findIndex(item => item.id === id)
  if (index >= 0) {
    const current = messages.value[index]
    const trimmed = String(text).trimStart()
    const shouldBreak = /^(#{1,6}\s|[-*]\s|\d+[.、]\s*)/.test(trimmed)
    const prefix = shouldBreak && current.content && !current.content.endsWith('\n') ? '\n' : ''
    messages.value[index] = { ...current, content: `${current.content || ''}${prefix}${text}` }
  }
}

const loadContext = async () => {
  try {
    const data = await askAssistantContext()
    provider.value = data.provider || provider.value
    suggestions.value = data.suggestions || toolPrompts.map(item => item.title)
    context.value = data.context || context.value
  } catch (error) {
    suggestions.value = toolPrompts.map(item => item.title)
    console.warn('AI 上下文加载失败，已使用默认快捷问题', error)
  }
}

const submit = async () => {
  const text = question.value.trim()
  if (!text) {
    ElMessage.warning('请输入问题')
    return
  }
  if (loading.value) {
    ElMessage.warning('上一条回答仍在生成，请稍等')
    return
  }
  pushMessage('user', text)
  question.value = ''
  const assistantId = pushMessage('assistant', '', { pending: true })
  loading.value = true
  controller.value = new AbortController()
  try {
    await streamAnswer(text, assistantId)
  } catch (error) {
    if (error.name !== 'AbortError') {
      appendMessageContent(assistantId, '\n\nAI 生成失败，请稍后重试。')
      ElMessage.error(error.message || 'AI 生成失败')
    }
  } finally {
    patchMessage(assistantId, { pending: false })
    loading.value = false
    controller.value = null
    scrollBottom()
  }
}

const streamAnswer = async (text, assistantId) => {
  const token = localStorage.getItem('warehouse_token')
  const response = await fetch('/api/ai/warehouse-assistant/stream', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`
    },
    body: JSON.stringify({ question: text, module: 'stock' }),
    signal: controller.value.signal
  })
  if (response.status === 401) {
    clearAuthAndRedirect()
    throw new Error('登录已过期，请重新登录')
  }
  if (!response.ok || !response.body) {
    const bodyText = await response.text()
    if (bodyText.includes('登录已过期') || bodyText.includes('重新登录')) {
      clearAuthAndRedirect()
      throw new Error('登录已过期，请重新登录')
    }
    throw new Error('AI 流式接口不可用')
  }
  const reader = response.body.getReader()
  const decoder = new TextDecoder('utf-8')
  let buffer = ''
  while (true) {
    const { value, done } = await reader.read()
    if (done) break
    buffer += decoder.decode(value, { stream: true }).replace(/\r\n/g, '\n')
    const events = buffer.split(/\n\n+/)
    buffer = events.pop() || ''
    for (const event of events) {
      handleSseEvent(event, assistantId)
    }
    await scrollBottom()
  }
  const tail = decoder.decode()
  if (tail) buffer += tail
  if (buffer.trim()) handleSseEvent(buffer, assistantId)
}

const handleSseEvent = (raw, assistantId) => {
  const lines = raw.split('\n')
  const event = lines.find(line => line.startsWith('event:'))?.replace('event:', '').trim()
  const data = lines
    .filter(line => line.startsWith('data:'))
    .map(line => line.replace(/^data:\s?/, ''))
    .join('\n')
  if (event === 'delta') {
    patchMessage(assistantId, { pending: false })
    appendMessageContent(assistantId, data)
  } else if (event === 'error') {
    patchMessage(assistantId, { notice: data, pending: false })
  }
}

const ask = (text) => {
  question.value = text
  submit()
}
const go = (path) => {
  if (path) router.push(path)
}
const cancelStream = () => {
  controller.value?.abort()
}
const clearChat = () => {
  if (!loading.value) messages.value = messages.value.slice(0, 1)
}
const copyText = async (text) => {
  await navigator.clipboard.writeText(text)
  ElMessage.success('已复制回答')
}

onMounted(async () => {
  await loadContext()
})
</script>

<style scoped>
.assistant-workspace {
  height: calc(100vh - 92px);
  min-height: 660px;
  display: grid;
  grid-template-columns: 340px minmax(0, 1fr);
  gap: 16px;
}
.assistant-panel,
.chat-shell {
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  overflow: hidden;
}
.assistant-panel { padding: 16px; overflow: auto; }
.panel-title { display: flex; gap: 10px; align-items: center; margin-bottom: 16px; }
.panel-title .el-icon {
  width: 38px; height: 38px; border-radius: 6px; display: grid; place-items: center;
  background: #1f4e79; color: #fff; font-size: 20px;
}
.panel-title span { display: block; color: #64748b; font-size: 12px; margin-top: 3px; }
.metric-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px; }
.metric {
  border: 1px solid #e5e7eb; border-radius: 6px; padding: 10px; background: #f8fafc;
  text-align: left; cursor: pointer;
}
.metric span { font-size: 12px; color: #64748b; }
.metric strong { display: block; font-size: 22px; margin-top: 4px; color: #102033; }
.quick-section { margin-top: 18px; }
.quick-section h3 { margin: 0 0 10px; font-size: 15px; }
.tool-btn {
  width: 100%; display: grid; grid-template-columns: 28px 1fr; gap: 2px 10px; align-items: center;
  text-align: left; border: 1px solid #dbe3ee; background: #fff;
  border-radius: 6px; padding: 10px 12px; margin-bottom: 8px; cursor: pointer; color: #1f2937;
}
.tool-btn .el-icon { grid-row: 1 / 3; color: #1f4e79; font-size: 18px; }
.tool-btn small { color: #64748b; }
.tool-btn:hover { border-color: #1f4e79; background: #f4f8fb; }
.tool-btn:disabled { cursor: not-allowed; opacity: .6; }
.risk-list { display: grid; gap: 8px; }
.risk-item { border-left: 3px solid #e11d48; background: #fff7f8; border-radius: 4px; padding: 9px 10px; }
.risk-item span, .risk-item small { display: block; }
.risk-item small { color: #64748b; margin-top: 4px; }
.chat-shell { display: flex; flex-direction: column; min-width: 0; }
.chat-header {
  min-height: 78px; padding: 14px 16px; border-bottom: 1px solid #e5e7eb;
  display: flex; align-items: center; justify-content: space-between; gap: 12px;
}
.chat-header h2 { margin: 0 0 4px; font-size: 20px; }
.chat-header p { margin: 0; color: #64748b; }
.chat-tools { display: flex; align-items: center; gap: 10px; }
.message-scroll { flex: 1; min-height: 0; }
.messages { padding: 18px; }
.message { display: flex; gap: 10px; margin-bottom: 16px; }
.message.user { flex-direction: row-reverse; }
.avatar {
  width: 34px; height: 34px; border-radius: 6px; background: #eef2f7;
  display: grid; place-items: center; flex-shrink: 0;
}
.message.assistant .avatar { background: #1f4e79; color: #fff; }
.bubble { max-width: min(78%, 880px); border: 1px solid #e5e7eb; border-radius: 6px; padding: 10px 12px; background: #fff; overflow-wrap: anywhere; }
.message.user .bubble { background: #1f4e79; color: #fff; border-color: #1f4e79; }
.meta { display: flex; justify-content: space-between; gap: 10px; align-items: center; font-size: 12px; opacity: .82; margin-bottom: 6px; }
.content { line-height: 1.75; white-space: normal; word-break: break-word; }
.typing { color: #64748b; }
.typing span {
  display: inline-block; width: 6px; height: 6px; margin-right: 3px; border-radius: 50%;
  background: #1f4e79; animation: pulse 1s infinite ease-in-out;
}
.typing span:nth-child(2) { animation-delay: .15s; }
.typing span:nth-child(3) { animation-delay: .3s; }
@keyframes pulse { 0%, 80%, 100% { opacity: .3; transform: translateY(0); } 40% { opacity: 1; transform: translateY(-3px); } }
.notice { margin-top: 8px; color: #b45309; font-size: 13px; }
.suggestions { padding: 10px 16px; border-top: 1px solid #eef2f7; display: flex; flex-wrap: wrap; gap: 8px; }
.composer { border-top: 1px solid #e5e7eb; padding: 12px 16px; }
.composer-actions { margin-top: 10px; display: flex; justify-content: space-between; align-items: center; }
.markdown-body :deep(h1), .markdown-body :deep(h2), .markdown-body :deep(h3), .markdown-body :deep(h4) {
  margin: 10px 0 8px; font-size: 16px; color: #1f2937;
}
.markdown-body :deep(strong) { color: #163f63; font-weight: 700; }
.markdown-body :deep(p) { margin: 6px 0; }
.markdown-body :deep(ul), .markdown-body :deep(ol) { margin: 6px 0 8px 20px; padding: 0; }
.markdown-body :deep(li) { margin: 5px 0; padding-left: 2px; }
.markdown-body :deep(code) {
  padding: 1px 5px;
  border-radius: 4px;
  background: #eef2f7;
  color: #163f63;
}
@media (max-width: 1100px) {
  .assistant-workspace { grid-template-columns: 1fr; height: auto; }
  .chat-shell { height: 720px; }
}
</style>
