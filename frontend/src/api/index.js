import request from './request'

export const authApi = {
  register: (data) => request.post('/auth/register', data),
  login: (data) => request.post('/auth/login', data),
  me: () => request.get('/auth/me'),
  updateMe: (data) => request.put('/auth/me', data)
}

export const newsApi = {
  categories: () => request.get('/categories'),
  list: (params) => request.get('/news', { params }),
  detail: (id) => request.get(`/news/${id}`),
  comments: (newsId, params) => request.get(`/news/${newsId}/comments`, { params }),
  comment: (newsId, data) => request.post(`/news/${newsId}/comments`, data),
  deleteComment: (id) => request.delete(`/comments/${id}`)
}

export const adminApi = {
  statistics: () => request.get('/admin/dashboard/statistics'),
  users: (params) => request.get('/admin/users', { params }),
  createUser: (data) => request.post('/admin/users', data),
  updateUser: (id, data) => request.put(`/admin/users/${id}`, data),
  deleteUser: (id) => request.delete(`/admin/users/${id}`),
  userStatus: (id, status) => request.put(`/admin/users/${id}/status`, { status }),
  resetPassword: (id, password) => request.put(`/admin/users/${id}/password`, { password }),
  categories: (params) => request.get('/admin/categories', { params }),
  createCategory: (data) => request.post('/admin/categories', data),
  updateCategory: (id, data) => request.put(`/admin/categories/${id}`, data),
  deleteCategory: (id) => request.delete(`/admin/categories/${id}`),
  categoryStatus: (id, status) => request.put(`/admin/categories/${id}/status`, { status }),
  adminNews: (params) => request.get('/admin/news', { params }),
  adminNewsDetail: (id) => request.get(`/admin/news/${id}`),
  createNews: (data) => request.post('/admin/news', data),
  updateNews: (id, data) => request.put(`/admin/news/${id}`, data),
  deleteNews: (id) => request.delete(`/admin/news/${id}`),
  newsStatus: (id, status) => request.put(`/admin/news/${id}/status`, { status }),
  comments: (params) => request.get('/admin/comments', { params }),
  deleteComment: (id) => request.delete(`/admin/comments/${id}`),
  commentStatus: (id, status) => request.put(`/admin/comments/${id}/status`, { status })
}
