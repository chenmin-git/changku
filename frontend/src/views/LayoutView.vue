<template>
  <el-container class="layout">
    <el-aside :width="collapsed ? '72px' : '232px'" class="aside">
      <div class="system-title" :class="{ collapsed }">
        <el-icon><Box /></el-icon>
        <span v-show="!collapsed">智能仓库管理系统</span>
      </div>
      <el-scrollbar class="aside-scroll">
        <el-menu
          router
          :collapse="collapsed"
          :collapse-transition="false"
          :default-active="$route.path"
          background-color="#152238"
          text-color="#cbd5e1"
          active-text-color="#ffffff"
        >
          <template v-for="group in filteredMenus" :key="group.title">
            <el-menu-item-group v-if="!collapsed" :title="group.title">
              <el-menu-item v-for="item in group.items" :key="item.path" :index="item.path">
                <el-icon><component :is="item.icon" /></el-icon>
                <span>{{ item.label }}</span>
              </el-menu-item>
            </el-menu-item-group>
            <template v-else>
              <el-tooltip v-for="item in group.items" :key="item.path" :content="item.label" placement="right">
                <el-menu-item :index="item.path">
                  <el-icon><component :is="item.icon" /></el-icon>
                </el-menu-item>
              </el-tooltip>
            </template>
          </template>
        </el-menu>
      </el-scrollbar>
    </el-aside>
    <el-container class="content-shell">
      <el-header class="header">
        <div class="header-left">
          <el-button text class="collapse-btn" @click="toggleCollapsed">
            <el-icon><component :is="collapsed ? 'Expand' : 'Fold'" /></el-icon>
          </el-button>
          <div>
            <strong>{{ route.meta.title || modules[route.params.module]?.title || '业务管理' }}</strong>
            <span class="muted header-sub">仓储业务实时协同</span>
          </div>
        </div>
        <el-dropdown>
          <span class="user-entry"><el-icon><User /></el-icon>{{ auth.user?.realName }}（{{ auth.user?.roleName }}）</span>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item @click="router.push('/profile')">个人中心</el-dropdown-item>
              <el-dropdown-item divided @click="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </el-header>
      <el-main class="main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../store/auth'
import { menuGroups, modules } from '../utils/modules'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const collapsed = ref(localStorage.getItem('warehouse_menu_collapsed') === '1')
const isAdmin = computed(() => auth.user?.roleCode === 'ADMIN')
const filteredMenus = computed(() => menuGroups.map(group => ({
  ...group,
  items: group.items.filter(item => !item.adminOnly || isAdmin.value)
})).filter(group => group.items.length))
const toggleCollapsed = () => {
  collapsed.value = !collapsed.value
  localStorage.setItem('warehouse_menu_collapsed', collapsed.value ? '1' : '0')
}
const logout = () => {
  auth.logout()
  router.push('/login')
}
</script>

<style scoped>
.layout {
  height: 100vh;
  overflow: hidden;
}
.aside {
  background: #152238;
  color: #fff;
  overflow: hidden;
  transition: width .18s ease;
}
.aside-scroll {
  height: calc(100vh - 60px);
}
.system-title {
  height: 60px;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0 18px;
  font-weight: 700;
  border-bottom: 1px solid rgba(255,255,255,.08);
  white-space: nowrap;
}
.system-title.collapsed {
  justify-content: center;
  padding: 0;
}
.system-title .el-icon { font-size: 26px; flex-shrink: 0; }
.content-shell { min-width: 0; }
.header {
  height: 60px;
  background: #fff;
  border-bottom: 1px solid #e5e7eb;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-shrink: 0;
}
.header-left {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;
}
.collapse-btn {
  width: 34px;
  height: 34px;
  font-size: 20px;
}
.header-sub {
  margin-left: 12px;
  font-size: 13px;
}
.user-entry {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
}
.main {
  height: calc(100vh - 60px);
  padding: 16px;
  overflow: auto;
}
:deep(.el-menu) { border-right: 0; }
:deep(.el-menu--collapse) { width: 72px; }
:deep(.el-menu--collapse .el-menu-item) { justify-content: center; }
</style>
