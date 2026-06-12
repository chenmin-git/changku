import request from '../utils/request'

export const login = (data) => request.post('/auth/login', data)
export const profile = () => request.get('/auth/profile')
export const dashboardSummary = () => request.get('/dashboard/summary')
export const askAssistant = (data) => request.post('/ai/warehouse-assistant', data)
export const askAssistantContext = () => request.get('/ai/context')
export const uploadImage = (data) => request.post('/upload', data, { headers: { 'Content-Type': 'multipart/form-data' } })

export const pageModule = (module, params) => request.get(`/${module}`, { params })
export const detailModule = (module, id) => request.get(`/${module}/${id}`)
export const createModule = (module, data) => request.post(`/${module}`, data)
export const updateModule = (module, id, data) => request.put(`/${module}/${id}`, data)
export const deleteModule = (module, id) => request.delete(`/${module}/${id}`)
export const batchDeleteModule = (module, ids) => request.post(`/${module}/batch-delete`, { ids })
export const flowModule = (module, id, action) => request.post(`/${module}/${id}/flow`, { action })
