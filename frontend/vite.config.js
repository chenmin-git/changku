import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 15174,
    strictPort: true,
    proxy: {
      '/api': 'http://localhost:18080',
      '/uploads': 'http://localhost:18080'
    }
  }
})
