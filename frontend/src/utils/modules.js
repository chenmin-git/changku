export const statusOptions = {
  enabled: ['启用', '禁用'],
  warehouse: ['启用', '维护中'],
  shelf: ['上架', '下架'],
  supplier: ['合作中', '暂停'],
  customer: ['正常', '停用'],
  inbound: ['待审核', '已入库', '已驳回'],
  outbound: ['待出库', '已出库', '已取消'],
  pending: ['待处理', '已完成'],
  alert: ['待处理', '已处理'],
  notice: ['已发布', '草稿']
}

export const dictionary = {
  role_id: [
    { label: '管理员', value: 1 },
    { label: '仓管员', value: 2 }
  ],
  warehouse_id: [
    { label: '一号原料仓', value: 1 },
    { label: '二号包装仓', value: 2 },
    { label: '三号设备仓', value: 3 },
    { label: '四号冷链仓', value: 4 }
  ],
  category_id: [
    { label: '安全防护', value: 1 },
    { label: '包装耗材', value: 2 },
    { label: '设备备件', value: 3 },
    { label: '办公耗材', value: 4 },
    { label: '电子配件', value: 5 }
  ],
  unit: ['个', '件', '套', '箱', '包', '卷', '台', '米', '张', '枚'],
  level: ['高', '中', '低'],
  alert_type: ['低库存', '接近下限', '周转偏高', '临期提醒']
}

export const fieldLabels = {
  id: '编号',
  username: '账号',
  password: '密码',
  real_name: '姓名',
  role_id: '角色',
  phone: '手机号',
  avatar: '头像',
  status: '状态',
  last_login_time: '最近登录时间',
  created_at: '创建时间',
  updated_at: '更新时间',
  name: '名称',
  code: '编码',
  location: '位置',
  manager: '负责人',
  capacity: '容量',
  sort_no: '排序',
  category_id: '货品分类',
  specification: '规格',
  unit: '单位',
  image: '图片',
  stock_quantity: '当前库存',
  min_stock: '安全下限',
  max_stock: '库存上限',
  warehouse_id: '所属仓库',
  contact_name: '联系人',
  level: '等级',
  address: '地址',
  order_no: '单号',
  supplier_name: '供应商',
  customer_name: '客户',
  goods_name: '货品',
  quantity: '数量',
  amount: '金额',
  operator_name: '经办人',
  check_no: '盘点单号',
  book_quantity: '账面数量',
  real_quantity: '实盘数量',
  difference_quantity: '差异数量',
  alert_type: '预警类型',
  current_stock: '当前库存',
  remark: '备注',
  title: '标题',
  content: '内容',
  publisher: '发布人',
  module: '模块',
  action: '动作'
}

export const modules = {
  users: {
    title: '用户管理',
    adminOnly: true,
    columns: [['username', '账号', 130], ['real_name', '姓名', 120], ['role_id', '角色', 110], ['phone', '手机号', 140], ['status', '状态', 100], ['created_at', '创建时间', 180]],
    filters: [{ key: 'status', label: '状态', options: statusOptions.enabled }, { key: 'role_id', label: '角色', options: dictionary.role_id }],
    form: [['username', '账号'], ['password', '密码'], ['real_name', '姓名'], ['role_id', '角色'], ['phone', '手机号'], ['status', '状态']]
  },
  warehouses: {
    title: '仓库管理',
    adminOnly: true,
    columns: [['name', '仓库名称', 180], ['code', '编码', 140], ['location', '位置', 240], ['manager', '负责人', 120], ['capacity', '容量', 110], ['status', '状态', 100], ['remark', '备注', 240]],
    filters: [{ key: 'status', label: '状态', options: statusOptions.warehouse }],
    form: [['name', '仓库名称'], ['code', '编码'], ['location', '位置'], ['manager', '负责人'], ['capacity', '容量'], ['status', '状态'], ['remark', '备注']]
  },
  categories: {
    title: '货品分类',
    adminOnly: true,
    columns: [['name', '分类名称', 180], ['code', '编码', 140], ['sort_no', '排序', 90], ['status', '状态', 100], ['remark', '备注', 280]],
    filters: [{ key: 'status', label: '状态', options: statusOptions.enabled }],
    form: [['name', '分类名称'], ['code', '编码'], ['sort_no', '排序'], ['status', '状态'], ['remark', '备注']]
  },
  goods: {
    title: '货品档案',
    columns: [['image', '图片', 92], ['name', '货品名称', 220], ['code', '编码', 140], ['category_id', '分类', 130], ['specification', '规格', 180], ['stock_quantity', '库存', 100], ['min_stock', '下限', 100], ['warehouse_id', '仓库', 140], ['status', '状态', 100], ['remark', '备注', 220]],
    filters: [{ key: 'status', label: '状态', options: statusOptions.shelf }, { key: 'category_id', label: '分类', options: dictionary.category_id }],
    form: [['name', '货品名称'], ['code', '编码'], ['category_id', '分类'], ['specification', '规格'], ['unit', '单位'], ['image', '图片'], ['stock_quantity', '库存'], ['min_stock', '下限'], ['max_stock', '上限'], ['warehouse_id', '仓库'], ['status', '状态'], ['remark', '备注']]
  },
  suppliers: {
    title: '供应商管理',
    adminOnly: true,
    columns: [['name', '供应商', 220], ['contact_name', '联系人', 120], ['phone', '电话', 140], ['level', '等级', 100], ['status', '状态', 110], ['address', '地址', 280], ['remark', '备注', 220]],
    filters: [{ key: 'level', label: '等级', options: ['A 级', 'B 级', 'C 级'] }, { key: 'status', label: '状态', options: statusOptions.supplier }],
    form: [['name', '供应商'], ['contact_name', '联系人'], ['phone', '电话'], ['level', '等级'], ['address', '地址'], ['status', '状态'], ['remark', '备注']]
  },
  customers: {
    title: '客户管理',
    adminOnly: true,
    columns: [['name', '客户名称', 220], ['contact_name', '联系人', 120], ['phone', '电话', 140], ['level', '等级', 100], ['status', '状态', 110], ['address', '地址', 280], ['remark', '备注', 220]],
    filters: [{ key: 'level', label: '等级', options: ['重点', '普通'] }, { key: 'status', label: '状态', options: statusOptions.customer }],
    form: [['name', '客户名称'], ['contact_name', '联系人'], ['phone', '电话'], ['level', '等级'], ['address', '地址'], ['status', '状态'], ['remark', '备注']]
  },
  inbounds: {
    title: '入库管理',
    actions: [
      { name: 'approve', label: '审核入库', visible: row => row.status === '待审核' },
      { name: 'reject', label: '驳回', visible: row => row.status === '待审核' }
    ],
    columns: [['order_no', '单号', 170], ['supplier_name', '供应商', 220], ['goods_name', '货品', 220], ['warehouse_id', '仓库', 140], ['quantity', '数量', 100], ['amount', '金额', 120], ['status', '状态', 110], ['operator_name', '经办人', 120], ['remark', '备注', 220]],
    filters: [{ key: 'status', label: '状态', options: statusOptions.inbound }, { key: 'warehouse_id', label: '仓库', options: dictionary.warehouse_id }],
    form: [['order_no', '单号'], ['supplier_name', '供应商'], ['goods_name', '货品'], ['warehouse_id', '仓库'], ['quantity', '数量'], ['amount', '金额'], ['status', '状态'], ['operator_name', '经办人'], ['remark', '备注']]
  },
  outbounds: {
    title: '出库管理',
    actions: [
      { name: 'ship', label: '确认出库', visible: row => row.status === '待出库' },
      { name: 'cancel', label: '取消', visible: row => row.status === '待出库' }
    ],
    columns: [['order_no', '单号', 170], ['customer_name', '客户', 220], ['goods_name', '货品', 220], ['warehouse_id', '仓库', 140], ['quantity', '数量', 100], ['amount', '金额', 120], ['status', '状态', 110], ['operator_name', '经办人', 120], ['remark', '备注', 220]],
    filters: [{ key: 'status', label: '状态', options: statusOptions.outbound }, { key: 'warehouse_id', label: '仓库', options: dictionary.warehouse_id }],
    form: [['order_no', '单号'], ['customer_name', '客户'], ['goods_name', '货品'], ['warehouse_id', '仓库'], ['quantity', '数量'], ['amount', '金额'], ['status', '状态'], ['operator_name', '经办人'], ['remark', '备注']]
  },
  checks: {
    title: '库存盘点',
    actions: [{ name: 'finish', label: '完成盘点', visible: row => row.status === '待处理' }],
    columns: [['check_no', '盘点单号', 170], ['goods_name', '货品', 220], ['warehouse_id', '仓库', 140], ['book_quantity', '账面数', 100], ['real_quantity', '实盘数', 100], ['difference_quantity', '差异', 100], ['status', '状态', 110], ['operator_name', '盘点人', 120], ['remark', '备注', 240]],
    filters: [{ key: 'status', label: '状态', options: statusOptions.pending }, { key: 'warehouse_id', label: '仓库', options: dictionary.warehouse_id }],
    form: [['check_no', '盘点单号'], ['goods_name', '货品'], ['warehouse_id', '仓库'], ['book_quantity', '账面数'], ['real_quantity', '实盘数'], ['difference_quantity', '差异'], ['status', '状态'], ['operator_name', '盘点人'], ['remark', '备注']]
  },
  alerts: {
    title: '库存预警',
    actions: [{ name: 'handle', label: '标记处理', visible: row => row.status === '待处理' }],
    columns: [['goods_name', '货品', 220], ['alert_type', '预警类型', 120], ['current_stock', '当前库存', 110], ['min_stock', '安全下限', 110], ['level', '等级', 100], ['status', '状态', 110], ['remark', '建议', 320]],
    filters: [{ key: 'level', label: '等级', options: dictionary.level }, { key: 'status', label: '状态', options: statusOptions.alert }],
    form: [['goods_name', '货品'], ['alert_type', '预警类型'], ['current_stock', '当前库存'], ['min_stock', '安全下限'], ['level', '等级'], ['status', '状态'], ['remark', '建议']]
  },
  notices: {
    title: '公告管理',
    adminOnly: true,
    columns: [['title', '标题', 260], ['status', '状态', 100], ['publisher', '发布人', 130], ['created_at', '发布时间', 180], ['content', '内容', 380]],
    filters: [{ key: 'status', label: '状态', options: statusOptions.notice }],
    form: [['title', '标题'], ['content', '内容'], ['status', '状态'], ['publisher', '发布人']]
  },
  logs: {
    title: '操作日志',
    adminOnly: true,
    readonly: true,
    columns: [['operator_name', '操作人', 130], ['module', '模块', 120], ['action', '动作', 110], ['content', '内容', 380], ['created_at', '时间', 180]],
    filters: [{ key: 'module', label: '模块', options: ['用户', '入库单', '出库单', '库存预警', '盘点'] }],
    form: []
  }
}

export const menuGroups = [
  { title: '首页', items: [{ path: '/dashboard', label: '工作台', icon: 'DataBoard' }, { path: '/assistant', label: '智能助手', icon: 'ChatDotRound' }] },
  { title: '基础资料', items: [{ path: '/warehouses', label: '仓库管理', icon: 'OfficeBuilding', adminOnly: true }, { path: '/categories', label: '货品分类', icon: 'CollectionTag', adminOnly: true }, { path: '/goods', label: '货品档案', icon: 'Box' }, { path: '/suppliers', label: '供应商管理', icon: 'Van', adminOnly: true }, { path: '/customers', label: '客户管理', icon: 'User', adminOnly: true }] },
  { title: '库存业务', items: [{ path: '/inbounds', label: '入库管理', icon: 'Bottom' }, { path: '/outbounds', label: '出库管理', icon: 'Top' }, { path: '/checks', label: '库存盘点', icon: 'Checked' }, { path: '/alerts', label: '库存预警', icon: 'Warning' }] },
  { title: '系统管理', items: [{ path: '/users', label: '用户管理', icon: 'UserFilled', adminOnly: true }, { path: '/notices', label: '公告管理', icon: 'Bell', adminOnly: true }, { path: '/logs', label: '操作日志', icon: 'Document', adminOnly: true }, { path: '/profile', label: '个人中心', icon: 'Setting' }] }
]
