<template>
  <div class="dashboard">
    <div class="stats">
      <div class="stat-card" v-for="card in data.cards" :key="card.title">
        <span>{{ card.title }}</span>
        <strong>{{ card.value }}<small>{{ card.unit }}</small></strong>
      </div>
    </div>

    <el-row :gutter="16">
      <el-col :xl="16" :lg="15" :md="24">
        <div class="page-card chart-box" ref="weekRef"></div>
      </el-col>
      <el-col :xl="8" :lg="9" :md="24">
        <div class="page-card quick-panel">
          <div class="section-head">
            <h3>待处理事项快捷入口</h3>
            <span>{{ data.role }}视角</span>
          </div>
          <div class="quick-grid">
            <button v-for="item in data.quickTodos" :key="item.title" class="quick-card" @click="go(item.path)">
              <el-icon><component :is="item.icon" /></el-icon>
              <span>{{ item.title }}</span>
              <strong>{{ item.value }}</strong>
            </button>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="16" class="block-row">
      <el-col :xl="10" :lg="12" :md="24">
        <div class="page-card chart-box small" ref="monthRef"></div>
      </el-col>
      <el-col :xl="7" :lg="12" :md="24">
        <div class="page-card chart-box small" ref="pieRef"></div>
      </el-col>
      <el-col :xl="7" :lg="24" :md="24">
        <div class="page-card risk-panel">
          <div class="section-head">
            <h3>高风险库存 TOP5</h3>
            <span>按库存缺口排序</span>
          </div>
          <div class="risk-list">
            <div v-for="item in data.riskTop" :key="item.name" class="risk-item">
              <div>
                <strong>{{ item.name }}</strong>
                <span>{{ item.warehouse_name || '未分仓库' }} / 下限 {{ item.min_stock }}</span>
              </div>
              <el-tag :type="levelType(item.level)" size="small">{{ item.level }}</el-tag>
              <em>库存 {{ item.current_stock }}</em>
              <small>{{ item.suggestion }}</small>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="16" class="block-row">
      <el-col :span="12">
        <div class="page-card board-table">
          <div class="section-head">
            <h3>{{ data.role }}待办事项</h3>
            <span>最新 {{ data.todo.length }} 条</span>
          </div>
          <el-table :data="pagedTodo" height="250" empty-text="暂无待办" @row-click="row => go(row.path)">
            <el-table-column prop="type" label="类型" width="110" />
            <el-table-column prop="title" label="事项" show-overflow-tooltip />
            <el-table-column prop="status" label="状态" width="90">
              <template #default="{ row }">
                <el-tag :type="statusType(row.status)" size="small">{{ row.status }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="created_at" label="时间" width="170" />
          </el-table>
          <el-pagination
            v-model:current-page="todoPage"
            layout="total, prev, pager, next"
            :page-size="5"
            :total="data.todo.length"
            class="pagination compact"
          />
        </div>
      </el-col>
      <el-col :span="12">
        <div class="page-card board-table">
          <div class="section-head">
            <h3>最近操作</h3>
            <span>业务留痕</span>
          </div>
          <el-table :data="pagedRecent" height="250" empty-text="暂无记录">
            <el-table-column prop="operator_name" label="操作人" width="110" />
            <el-table-column prop="module" label="模块" width="110" />
            <el-table-column prop="action" label="动作" width="100" />
            <el-table-column prop="content" label="内容" show-overflow-tooltip />
            <el-table-column prop="created_at" label="时间" width="170" />
          </el-table>
          <el-pagination
            v-model:current-page="recentPage"
            layout="total, prev, pager, next"
            :page-size="5"
            :total="data.recent.length"
            class="pagination compact"
          />
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { computed, nextTick, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import * as echarts from 'echarts'
import { dashboardSummary } from '../api'

const router = useRouter()
const data = reactive({
  cards: [],
  trend: [],
  weekTrend: [],
  categoryStock: [],
  quickTodos: [],
  riskTop: [],
  todo: [],
  recent: [],
  role: ''
})
const weekRef = ref()
const monthRef = ref()
const pieRef = ref()
const todoPage = ref(1)
const recentPage = ref(1)
let weekChart
let monthChart
let pieChart

const pageSlice = (list, page, size = 5) => list.slice((page - 1) * size, page * size)
const pagedTodo = computed(() => pageSlice(data.todo, todoPage.value))
const pagedRecent = computed(() => pageSlice(data.recent, recentPage.value))

const levelType = (level) => level === '高' ? 'danger' : level === '中' ? 'warning' : 'success'
const statusType = (status) => {
  if (['高', '待处理', '待审核', '待出库'].includes(status)) return 'warning'
  if (['已完成', '已处理', '已入库', '已出库'].includes(status)) return 'success'
  return 'info'
}
const go = (path) => {
  if (path) router.push(path)
}

const renderCharts = () => {
  weekChart?.dispose()
  monthChart?.dispose()
  pieChart?.dispose()
  weekChart = echarts.init(weekRef.value)
  monthChart = echarts.init(monthRef.value)
  pieChart = echarts.init(pieRef.value)

  weekChart.setOption({
    title: { text: '近 7 天入出库趋势', left: 8, top: 6, textStyle: { fontSize: 15, fontWeight: 700 } },
    tooltip: { trigger: 'axis' },
    legend: { top: 8, right: 12 },
    grid: { left: 46, right: 24, bottom: 36, top: 58 },
    xAxis: { type: 'category', data: data.weekTrend.map(i => i.day) },
    yAxis: { type: 'value' },
    series: [
      { name: '入库', type: 'line', smooth: true, symbolSize: 7, areaStyle: { opacity: 0.1 }, data: data.weekTrend.map(i => i.inbound) },
      { name: '出库', type: 'line', smooth: true, symbolSize: 7, areaStyle: { opacity: 0.08 }, data: data.weekTrend.map(i => i.outbound) }
    ]
  })

  const monthData = [...data.trend].reverse()
  monthChart.setOption({
    title: { text: '近 6 个月入出库对比', left: 8, top: 6, textStyle: { fontSize: 15, fontWeight: 700 } },
    tooltip: { trigger: 'axis' },
    legend: { top: 8, right: 12 },
    grid: { left: 44, right: 18, bottom: 36, top: 58 },
    xAxis: { type: 'category', data: monthData.map(i => i.month) },
    yAxis: { type: 'value' },
    series: [
      { name: '入库', type: 'bar', barWidth: 18, data: monthData.map(i => i.inbound) },
      { name: '出库', type: 'bar', barWidth: 18, data: monthData.map(i => i.outbound) }
    ]
  })

  pieChart.setOption({
    title: { text: '分类库存占比', left: 8, top: 6, textStyle: { fontSize: 15, fontWeight: 700 } },
    tooltip: { trigger: 'item' },
    legend: { bottom: 8, type: 'scroll' },
    series: [{ type: 'pie', radius: ['42%', '66%'], center: ['50%', '48%'], data: data.categoryStock }]
  })
}

const load = async () => {
  Object.assign(data, await dashboardSummary())
  todoPage.value = 1
  recentPage.value = 1
  await nextTick()
  renderCharts()
}
const resize = () => {
  weekChart?.resize()
  monthChart?.resize()
  pieChart?.resize()
}
onMounted(() => {
  load()
  window.addEventListener('resize', resize)
})
onBeforeUnmount(() => {
  window.removeEventListener('resize', resize)
  weekChart?.dispose()
  monthChart?.dispose()
  pieChart?.dispose()
})
</script>

<style scoped>
.dashboard {
  min-height: 100%;
}
.stats {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
  margin-bottom: 16px;
}
.stat-card {
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  padding: 18px;
}
.stat-card span { color: #64748b; }
.stat-card strong { display: block; margin-top: 10px; font-size: 28px; color: #102033; }
.stat-card small { margin-left: 4px; font-size: 14px; color: #64748b; }
.chart-box { height: 342px; }
.chart-box.small { height: 320px; }
.block-row { margin-top: 16px; }
.quick-panel,
.risk-panel,
.board-table {
  min-height: 320px;
}
.section-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 14px;
}
.section-head h3 { margin: 0; font-size: 16px; }
.section-head span { color: #64748b; font-size: 13px; }
.quick-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}
.quick-card {
  min-height: 112px;
  border: 1px solid #dce6f1;
  border-radius: 6px;
  background: #f8fafc;
  padding: 14px;
  text-align: left;
  cursor: pointer;
}
.quick-card:hover {
  border-color: #1f4e79;
  background: #f3f8fc;
}
.quick-card .el-icon {
  width: 30px;
  height: 30px;
  border-radius: 6px;
  display: grid;
  place-items: center;
  background: #1f4e79;
  color: #fff;
  margin-bottom: 10px;
}
.quick-card span,
.quick-card strong {
  display: block;
}
.quick-card span { color: #516072; }
.quick-card strong { margin-top: 6px; font-size: 26px; color: #102033; }
.risk-list {
  display: grid;
  gap: 10px;
}
.risk-item {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 6px 10px;
  border: 1px solid #e5e7eb;
  border-left: 3px solid #e11d48;
  border-radius: 6px;
  padding: 10px 12px;
  background: #fff;
}
.risk-item strong,
.risk-item span,
.risk-item small,
.risk-item em {
  display: block;
}
.risk-item strong { color: #102033; }
.risk-item span,
.risk-item small { color: #64748b; }
.risk-item em { grid-column: 1 / -1; font-style: normal; color: #1f4e79; }
.compact {
  margin-top: 10px;
}
:deep(.el-table__row) {
  cursor: pointer;
}
@media (max-width: 1100px) {
  .stats {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
@media (max-width: 720px) {
  .stats,
  .quick-grid {
    grid-template-columns: 1fr;
  }
}
</style>
