<template>
  <div class="not-found">
    <h1>404</h1>
    <p>页面不存在或已被移动</p>
    <el-button type="primary" @click="$router.push('/dashboard')">返回工作台</el-button>
  </div>
</template>

<style scoped>
.not-found {
  min-height: 100vh;
  display: grid;
  place-content: center;
  text-align: center;
  gap: 12px;
}
h1 { font-size: 60px; margin: 0; color: #1f4e79; }
p { color: #64748b; }
</style>
