<template>
  <div class="page-card table-page">
    <div class="toolbar">
      <el-input v-model="query.keyword" placeholder="请输入关键词" clearable @keyup.enter="load(1)" />
      <el-select
        v-for="filter in meta.filters"
        :key="filter.key"
        v-model="query[filter.key]"
        :placeholder="filter.label"
        clearable
      >
        <el-option
          v-for="option in normalizeOptions(filter.options)"
          :key="option.value"
          :label="option.label"
          :value="option.value"
        />
      </el-select>
      <el-button type="primary" icon="Search" @click="load(1)">查询</el-button>
      <el-button icon="Refresh" @click="reset">重置</el-button>
      <el-button icon="Download" :disabled="!rows.length" @click="exportExcel">导出Excel</el-button>
      <el-button v-if="!meta.readonly" type="success" icon="Plus" @click="openForm()">新增</el-button>
      <el-button v-if="!meta.readonly" type="danger" icon="Delete" :disabled="!selection.length" @click="removeBatch">批量删除</el-button>
    </div>

    <div class="table-wrap">
      <el-table
        v-loading="loading"
        :data="rows"
        empty-text="暂无数据"
        border
        height="100%"
        style="width: 100%"
        @selection-change="selection = $event"
      >
        <el-table-column v-if="!meta.readonly" type="selection" width="48" fixed />
        <el-table-column
          v-for="col in meta.columns"
          :key="col[0]"
          :prop="col[0]"
          :label="col[1]"
          :width="fixedColumnWidth(col)"
          :min-width="flexColumnWidth(col)"
          show-overflow-tooltip
        >
          <template #default="{ row }">
            <el-image v-if="col[0] === 'image'" :src="imageUrl(row[col[0]])" fit="cover" class="thumb">
              <template #error><div class="thumb-error">无图</div></template>
            </el-image>
            <el-tag v-else-if="col[0] === 'level'" :type="levelType(row[col[0]])" size="small">{{ displayValue(col[0], row[col[0]]) }}</el-tag>
            <el-tag v-else-if="col[0] === 'status'" :type="statusType(row[col[0]])" size="small">{{ displayValue(col[0], row[col[0]]) }}</el-tag>
            <span v-else>{{ displayValue(col[0], row[col[0]]) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="" min-width="1" class-name="fill-column" />
        <el-table-column label="操作" width="132" fixed="right" align="center" class-name="action-column">
          <template #default="{ row }">
            <div class="icon-actions">
              <el-tooltip content="详情" placement="top">
                <el-button circle size="small" icon="View" @click="showDetail(row)" />
              </el-tooltip>
              <el-tooltip v-if="!meta.readonly" content="编辑" placement="top">
                <el-button circle size="small" type="primary" icon="Edit" @click="openForm(row)" />
              </el-tooltip>
              <el-dropdown v-if="!meta.readonly" trigger="click" @command="handleCommand($event, row)">
                <el-button circle size="small" icon="MoreFilled" />
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item v-for="action in visibleActions(row)" :key="action.name" :command="action.name">
                      {{ action.label }}
                    </el-dropdown-item>
                    <el-dropdown-item command="delete" divided>删除</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-pagination
      v-model:current-page="query.page"
      v-model:page-size="query.size"
      layout="total, sizes, prev, pager, next, jumper"
      :total="total"
      :page-sizes="[10, 20, 50]"
      class="pagination"
      @current-change="load"
      @size-change="load(1)"
    />

    <el-dialog v-model="formVisible" :title="form.id ? `编辑${meta.title}` : `新增${meta.title}`" width="680px" append-to-body>
      <div class="dialog-body">
        <el-form :model="form" label-width="104px">
          <el-form-item v-for="field in meta.form" :key="field[0]" :label="field[1]">
            <el-upload
              v-if="field[0] === 'image'"
              :show-file-list="false"
              :http-request="uploadFile"
              :before-upload="beforeUpload"
            >
              <el-image v-if="form.image" :src="imageUrl(form.image)" class="preview" fit="cover" />
              <el-button v-else icon="Upload">上传图片</el-button>
            </el-upload>
            <el-select
              v-else-if="selectOptions(field[0]).length"
              v-model="form[field[0]]"
              :placeholder="`请选择${field[1]}`"
              clearable
              filterable
            >
              <el-option
                v-for="option in selectOptions(field[0])"
                :key="option.value"
                :label="option.label"
                :value="option.value"
              />
            </el-select>
            <el-input v-else-if="['remark', 'content', 'address'].includes(field[0])" v-model="form[field[0]]" type="textarea" :rows="3" />
            <el-input v-else-if="field[0] === 'password'" v-model="form[field[0]]" type="password" show-password />
            <el-input-number v-else-if="numberFields.has(field[0])" v-model="form[field[0]]" :min="0" :precision="field[0] === 'amount' ? 2 : 0" controls-position="right" />
            <el-input v-else v-model="form[field[0]]" />
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <el-button @click="formVisible = false">取消</el-button>
        <el-button type="primary" @click="save">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="detailVisible" :title="`${meta.title}详情`" width="720px" append-to-body>
      <div class="dialog-body">
        <el-descriptions :column="1" border>
          <el-descriptions-item v-for="[key, value] in detailEntries" :key="key" :label="fieldLabel(key)">
            <el-image v-if="key === 'image' && value" :src="imageUrl(value)" class="preview" fit="cover" />
            <span v-else>{{ displayValue(key, value) }}</span>
          </el-descriptions-item>
        </el-descriptions>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { batchDeleteModule, createModule, deleteModule, flowModule, pageModule, updateModule, uploadImage } from '../api'
import { dictionary, fieldLabels, modules, statusOptions } from '../utils/modules'
import { ASSET_BASE_URL } from '../utils/request'

const route = useRoute()
const moduleName = computed(() => route.params.module)
const meta = computed(() => modules[moduleName.value] || modules.goods)
const rows = ref([])
const total = ref(0)
const loading = ref(false)
const selection = ref([])
const formVisible = ref(false)
const detailVisible = ref(false)
const detail = ref({})
const form = reactive({})
const query = reactive({ page: 1, size: 10, keyword: '' })

const strictColumns = new Set(['image', 'status', 'level', 'role_id', 'category_id', 'warehouse_id', 'stock_quantity', 'min_stock', 'max_stock', 'quantity', 'amount', 'sort_no', 'book_quantity', 'real_quantity', 'difference_quantity', 'current_stock'])
const numberFields = new Set(['capacity', 'sort_no', 'stock_quantity', 'min_stock', 'max_stock', 'quantity', 'amount', 'book_quantity', 'real_quantity', 'difference_quantity', 'current_stock'])
const statusFieldMap = {
  users: statusOptions.enabled,
  warehouses: statusOptions.warehouse,
  categories: statusOptions.enabled,
  goods: statusOptions.shelf,
  suppliers: statusOptions.supplier,
  customers: statusOptions.customer,
  inbounds: statusOptions.inbound,
  outbounds: statusOptions.outbound,
  checks: statusOptions.pending,
  alerts: statusOptions.alert,
  notices: statusOptions.notice
}

const fixedColumnWidth = (col) => strictColumns.has(col[0]) ? col[2] : undefined
const flexColumnWidth = (col) => strictColumns.has(col[0]) ? undefined : col[2]
const detailEntries = computed(() => Object.entries(detail.value || {}).filter(([key]) => !['password'].includes(key)))

const normalizeOptions = (options = []) => options.map(item => {
  if (typeof item === 'object') return { label: item.label, value: item.value }
  return { label: item, value: item }
})

const imageUrl = (path) => {
  if (!path) return ''
  if (/^https?:\/\//.test(path)) return path
  return `${ASSET_BASE_URL}${path.startsWith('/') ? path : `/${path}`}`
}

const statusType = (status) => {
  if (['已入库', '已出库', '已完成', '已处理', '启用', '上架', '正常', '合作中', '已发布'].includes(status)) return 'success'
  if (['待审核', '待出库', '待处理', '维护中', '草稿'].includes(status)) return 'warning'
  if (['已驳回', '已取消', '禁用', '暂停', '停用', '下架'].includes(status)) return 'danger'
  return 'info'
}
const levelType = (level) => level === '高' ? 'danger' : level === '中' ? 'warning' : 'success'

const fieldLabel = (key) => fieldLabels[key]
  || meta.value.form.find(item => item[0] === key)?.[1]
  || meta.value.columns.find(item => item[0] === key)?.[1]
  || key

const selectOptions = (key) => {
  if (key === 'status') return normalizeOptions(statusFieldMap[moduleName.value] || [])
  if (dictionary[key]) return normalizeOptions(dictionary[key])
  return []
}

const displayValue = (key, value) => {
  if (value === null || value === undefined || value === '') return '-'
  const option = selectOptions(key).find(item => String(item.value) === String(value))
  return option ? option.label : value
}

const load = async (page = query.page) => {
  query.page = page
  loading.value = true
  try {
    const data = await pageModule(moduleName.value, query)
    rows.value = data.records || []
    total.value = data.total || 0
  } finally {
    loading.value = false
  }
}

const reset = () => {
  Object.keys(query).forEach(key => {
    if (!['page', 'size'].includes(key)) query[key] = ''
  })
  load(1)
}

const openForm = (row = null) => {
  Object.keys(form).forEach(key => delete form[key])
  Object.assign(form, row || {})
  formVisible.value = true
}

const save = async () => {
  if (form.id) await updateModule(moduleName.value, form.id, form)
  else await createModule(moduleName.value, form)
  ElMessage.success('保存成功')
  formVisible.value = false
  load()
}

const showDetail = (row) => {
  detail.value = row
  detailVisible.value = true
}

const remove = async (row) => {
  await ElMessageBox.confirm('确认删除该数据吗？', '删除确认', { type: 'warning' })
  await deleteModule(moduleName.value, row.id)
  ElMessage.success('删除成功')
  load()
}

const removeBatch = async () => {
  await ElMessageBox.confirm('确认批量删除选中的数据吗？', '批量删除确认', { type: 'warning' })
  await batchDeleteModule(moduleName.value, selection.value.map(item => item.id))
  ElMessage.success('批量删除成功')
  load()
}

const visibleActions = (row) => (meta.value.actions || []).filter(action => !action.visible || action.visible(row))

const handleCommand = async (command, row) => {
  if (command === 'delete') {
    await remove(row)
    return
  }
  const action = visibleActions(row).find(item => item.name === command)
  await ElMessageBox.confirm(`确认执行“${action?.label || '业务操作'}”吗？`, '业务确认', { type: 'warning' })
  await flowModule(moduleName.value, row.id, command)
  ElMessage.success('业务处理成功')
  load()
}

const beforeUpload = (file) => {
  const okType = ['image/jpeg', 'image/png', 'image/webp', 'image/svg+xml'].includes(file.type)
  const okSize = file.size / 1024 / 1024 <= 5
  if (!okType) ElMessage.error('仅支持 jpg、png、webp、svg 图片')
  if (!okSize) ElMessage.error('图片大小不能超过 5MB')
  return okType && okSize
}

const uploadFile = async ({ file }) => {
  const data = new FormData()
  data.append('file', file)
  data.append('module', moduleName.value)
  const result = await uploadImage(data)
  form.image = result.url
}

const exportExcel = () => {
  const columns = meta.value.columns.filter(col => col[0] !== 'image')
  const header = columns.map(col => csvCell(col[1])).join(',')
  const body = rows.value.map(row => columns.map(col => csvCell(displayValue(col[0], row[col[0]]))).join(',')).join('\r\n')
  const blob = new Blob([`\ufeff${header}\r\n${body}`], { type: 'text/csv;charset=utf-8;' })
  const link = document.createElement('a')
  link.href = URL.createObjectURL(blob)
  link.download = `${meta.value.title}-${new Date().toISOString().slice(0, 10)}.csv`
  link.click()
  URL.revokeObjectURL(link.href)
  ElMessage.success('已导出当前页数据，可用 Excel 打开')
}

const csvCell = (value) => {
  const text = String(value ?? '').replace(/"/g, '""')
  return `"${text}"`
}

watch(moduleName, () => {
  reset()
})
onMounted(load)
</script>

<style scoped>
.toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  align-items: center;
  margin-bottom: 14px;
}
.toolbar .el-input,
.toolbar .el-select {
  width: 210px;
}
.table-wrap {
  width: 100%;
  height: calc(100vh - 250px);
  min-height: 460px;
}
.pagination {
  justify-content: flex-end;
  margin-top: 14px;
}
.icon-actions {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  width: 100%;
  white-space: nowrap;
}
.icon-actions :deep(.el-button + .el-button) {
  margin-left: 0;
}
.thumb,
.thumb-error {
  width: 52px;
  height: 52px;
  border-radius: 6px;
  border: 1px solid #e5e7eb;
}
.thumb-error {
  display: grid;
  place-items: center;
  background: #f1f5f9;
  color: #94a3b8;
  font-size: 12px;
}
.preview {
  width: 140px;
  height: 104px;
  border-radius: 6px;
  border: 1px solid #e5e7eb;
}
.dialog-body {
  max-height: 62vh;
  overflow: auto;
  padding-right: 4px;
}
.el-input-number,
.dialog-body .el-select {
  width: 100%;
}
@media (max-width: 900px) {
  .toolbar .el-input,
  .toolbar .el-select {
    width: 100%;
  }
  .table-wrap {
    height: 520px;
  }
}
</style>
