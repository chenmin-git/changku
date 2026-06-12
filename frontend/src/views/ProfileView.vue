<template>
  <div class="profile page-card">
    <h2>个人中心</h2>
    <el-descriptions :column="1" border>
      <el-descriptions-item label="账号">{{ auth.user?.username }}</el-descriptions-item>
      <el-descriptions-item label="姓名">{{ auth.user?.realName }}</el-descriptions-item>
      <el-descriptions-item label="角色">{{ auth.user?.roleName }}</el-descriptions-item>
    </el-descriptions>
    <h3>修改密码</h3>
    <el-form :model="form" label-width="92px" class="password-form">
      <el-form-item label="原密码"><el-input v-model="form.oldPassword" type="password" show-password /></el-form-item>
      <el-form-item label="新密码"><el-input v-model="form.newPassword" type="password" show-password /></el-form-item>
      <el-form-item><el-button type="primary" @click="save">保存</el-button></el-form-item>
    </el-form>
  </div>
</template>

<script setup>
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { useAuthStore } from '../store/auth'
const auth = useAuthStore()
const form = reactive({ oldPassword: '', newPassword: '' })
const save = () => ElMessage.success('演示系统已收到修改密码请求')
</script>

<style scoped>
.profile { max-width: 720px; }
h2 { margin: 0 0 16px; }
h3 { margin: 24px 0 14px; font-size: 16px; }
.password-form { max-width: 420px; }
</style>
