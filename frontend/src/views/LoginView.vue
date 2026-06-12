<template>
  <div class="login-page">
    <section class="login-hero">
      <div class="hero-topline">
        <span class="brand-badge"><el-icon><Box /></el-icon></span>
        <span>智能仓库管理系统</span>
      </div>
      <div class="hero-copy">
        <p class="eyebrow">毕业设计演示系统</p>
        <h1>智能仓库管理系统</h1>
        <p class="subtitle">围绕仓库日常管理流程设计，支持基础资料维护、入库出库、库存盘点、预警处理和智能库存分析。</p>
      </div>
      <div class="process-board">
        <div class="process-card active">
          <strong>入库审核</strong>
          <small>登记采购到货信息，审核后自动进入库存台账。</small>
        </div>
        <div class="process-card">
          <strong>库存监控</strong>
          <small>跟踪安全库存、库存变化和异常预警。</small>
        </div>
        <div class="process-card">
          <strong>出库履约</strong>
          <small>完成出库确认，保留完整操作日志。</small>
        </div>
      </div>
    </section>

    <section class="login-card">
      <div class="card-head">
        <div>
          <h2>登录系统</h2>
          <p>请输入账号密码，进入后台管理工作台。</p>
        </div>
        <el-icon><Lock /></el-icon>
      </div>

      <div class="demo-switch">
        <button type="button" :class="{ selected: form.username === 'admin' }" @click="fillDemo('admin')">
          <strong>管理员</strong>
          <span>维护基础资料，查看全局统计。</span>
        </button>
        <button type="button" :class="{ selected: form.username === 'keeper' }" @click="fillDemo('keeper')">
          <strong>仓管员</strong>
          <span>处理入库、出库、盘点和预警。</span>
        </button>
      </div>

      <el-form ref="formRef" :model="form" :rules="rules" class="login-form" @keyup.enter="submit">
        <el-form-item prop="username">
          <el-input v-model="form.username" size="large" placeholder="请输入账号" prefix-icon="User" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" size="large" type="password" show-password placeholder="请输入密码" prefix-icon="Lock" />
        </el-form-item>
        <el-button type="primary" size="large" :loading="loading" @click="submit">
          {{ loading ? '正在登录...' : '进入系统' }}
        </el-button>
      </el-form>

      <div class="login-tips">
        <span>演示账号：admin / 123456</span>
        <span>仓管员：keeper / 123456</span>
      </div>
    </section>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useAuthStore } from '../store/auth'

const router = useRouter()
const auth = useAuthStore()
const formRef = ref()
const loading = ref(false)
const form = reactive({ username: '', password: '' })
const rules = {
  username: [{ required: true, message: '请输入账号', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const fillDemo = (username) => {
  form.username = username
  form.password = '123456'
}

const submit = async () => {
  await formRef.value.validate()
  loading.value = true
  try {
    await auth.signIn(form)
    router.push('/dashboard')
  } catch (error) {
    ElMessage.error(error.message || '登录失败，请检查账号和密码')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: grid;
  grid-template-columns: minmax(0, 1.16fr) 480px;
  background:
    linear-gradient(135deg, rgba(24, 48, 77, .94), rgba(22, 93, 84, .9)),
    #18304d;
  color: #172033;
  overflow: hidden;
}
.login-hero {
  position: relative;
  min-height: 100vh;
  padding: 56px 64px;
  color: #f8fafc;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 44px;
}
.login-hero::before {
  content: "";
  position: absolute;
  inset: 0;
  background:
    linear-gradient(rgba(255,255,255,.045) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255,255,255,.045) 1px, transparent 1px);
  background-size: 42px 42px;
  mask-image: linear-gradient(90deg, #000 0%, transparent 78%);
}
.hero-topline,
.hero-copy,
.process-board,
.hero-metrics {
  position: relative;
  z-index: 1;
}
.hero-topline {
  display: flex;
  align-items: center;
  gap: 12px;
  color: #dbeafe;
  font-weight: 700;
}
.brand-badge {
  width: 44px;
  height: 44px;
  display: grid;
  place-items: center;
  border-radius: 10px;
  background: #f8fafc;
  color: #14532d;
  font-size: 23px;
}
.eyebrow {
  margin: 0 0 12px;
  color: #d1fae5;
  font-weight: 700;
}
.hero-copy h1 {
  margin: 0;
  max-width: 740px;
  font-size: clamp(42px, 6vw, 76px);
  line-height: .98;
  letter-spacing: 0;
}
.subtitle {
  max-width: 680px;
  margin: 24px 0 0;
  color: #dbeafe;
  font-size: 18px;
  line-height: 1.8;
}
.process-board {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 14px;
  max-width: 860px;
}
.process-card {
  border: 1px solid rgba(255,255,255,.18);
  background: rgba(15, 23, 42, .36);
  backdrop-filter: blur(12px);
  border-radius: 8px;
  padding: 18px;
}
.process-card.active {
  background: rgba(34, 197, 94, .16);
  border-color: rgba(134, 239, 172, .48);
}
.process-card strong,
.process-card small {
  display: block;
}
.process-card strong {
  font-size: 18px;
}
.process-card small {
  margin-top: 8px;
  color: #cbd5e1;
  line-height: 1.6;
}
.login-card {
  align-self: center;
  width: 420px;
  margin-right: 56px;
  background: rgba(255, 255, 255, .96);
  border: 1px solid rgba(255,255,255,.72);
  border-radius: 8px;
  padding: 30px;
  box-shadow: 0 28px 70px rgba(2, 6, 23, .32);
}
.card-head {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  align-items: flex-start;
}
.card-head h2 {
  margin: 0;
  font-size: 26px;
}
.card-head p {
  margin: 8px 0 0;
  color: #64748b;
  line-height: 1.6;
}
.card-head .el-icon {
  width: 42px;
  height: 42px;
  border-radius: 8px;
  display: grid;
  place-items: center;
  background: #ecfdf5;
  color: #15803d;
  font-size: 22px;
}
.demo-switch {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
  margin: 24px 0;
}
.demo-switch button {
  border: 1px solid #dbe3ee;
  background: #f8fafc;
  border-radius: 8px;
  padding: 12px;
  text-align: left;
  cursor: pointer;
  color: #172033;
}
.demo-switch button.selected {
  border-color: #16a34a;
  background: #ecfdf5;
}
.demo-switch strong,
.demo-switch span {
  display: block;
}
.demo-switch span {
  margin-top: 5px;
  color: #64748b;
  font-size: 12px;
  line-height: 1.45;
}
.login-form .el-button {
  width: 100%;
  height: 44px;
  font-weight: 700;
}
.login-tips {
  margin-top: 16px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  color: #64748b;
  font-size: 13px;
}
@media (max-width: 980px) {
  .login-page {
    grid-template-columns: 1fr;
    padding: 24px;
    overflow: auto;
  }
  .login-hero {
    min-height: auto;
    padding: 24px 0;
    gap: 28px;
  }
  .process-board {
    grid-template-columns: 1fr;
  }
  .login-card {
    width: 100%;
    max-width: 460px;
    margin: 0 auto 28px;
  }
}
</style>
