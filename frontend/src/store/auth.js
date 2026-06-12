import { defineStore } from 'pinia'
import { login, profile } from '../api'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem('warehouse_token') || '',
    user: JSON.parse(localStorage.getItem('warehouse_user') || 'null')
  }),
  actions: {
    async signIn(form) {
      const data = await login(form)
      this.token = data.token
      this.user = data.user
      localStorage.setItem('warehouse_token', data.token)
      localStorage.setItem('warehouse_user', JSON.stringify(data.user))
    },
    async loadProfile() {
      this.user = await profile()
      localStorage.setItem('warehouse_user', JSON.stringify(this.user))
    },
    logout() {
      this.token = ''
      this.user = null
      localStorage.removeItem('warehouse_token')
      localStorage.removeItem('warehouse_user')
    }
  }
})
