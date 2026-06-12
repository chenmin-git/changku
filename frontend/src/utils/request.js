import axios from 'axios'
import { ElMessage } from 'element-plus'

export const API_BASE_URL = import.meta.env.VITE_API_BASE || '/api'
export const ASSET_BASE_URL = API_BASE_URL.endsWith('/api')
  ? API_BASE_URL.slice(0, -4)
  : API_BASE_URL.replace(/\/$/, '')

const request = axios.create({
  baseURL: API_BASE_URL,
  timeout: 60000
})

let redirecting = false

export const clearAuthAndRedirect = (message = '登录已过期，请重新登录') => {
  localStorage.removeItem('warehouse_token')
  localStorage.removeItem('warehouse_user')
  if (!redirecting) {
    redirecting = true
    ElMessage.error(message)
    setTimeout(() => {
      redirecting = false
      if (window.location.pathname !== '/login') {
        window.location.href = '/login'
      }
    }, 200)
  }
}

const isAuthExpired = (message = '', status) => {
  return status === 401 || message.includes('登录已过期') || message.includes('重新登录') || message.includes('无效')
}

request.interceptors.request.use((config) => {
  const token = localStorage.getItem('warehouse_token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

request.interceptors.response.use(
  (response) => {
    const body = response.data
    if (body.code && body.code !== 200) {
      if (isAuthExpired(body.message, response.status)) {
        clearAuthAndRedirect(body.message)
      } else {
        ElMessage.error(body.message || '请求失败')
      }
      return Promise.reject(new Error(body.message || '请求失败'))
    }
    return body.data
  },
  (error) => {
    const message = error.response?.data?.message || error.message || '网络异常'
    if (isAuthExpired(message, error.response?.status)) {
      clearAuthAndRedirect(message)
    } else {
      ElMessage.error(message)
    }
    return Promise.reject(error)
  }
)

export default request
