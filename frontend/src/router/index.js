import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const routes = [
  { path: '/', redirect: '/news' },
  { path: '/login', component: () => import('../views/LoginView.vue') },
  { path: '/register', component: () => import('../views/RegisterView.vue') },
  {
    path: '/',
    component: () => import('../layout/FrontLayout.vue'),
    children: [
      { path: 'news', component: () => import('../views/front/NewsListView.vue') },
      { path: 'news/:id', component: () => import('../views/front/NewsDetailView.vue') },
      { path: 'profile', meta: { requiresAuth: true }, component: () => import('../views/front/ProfileView.vue') }
    ]
  },
  {
    path: '/admin',
    component: () => import('../layout/AdminLayout.vue'),
    meta: { requiresAuth: true, requiresAdmin: true },
    children: [
      { path: '', redirect: '/admin/dashboard' },
      { path: 'dashboard', component: () => import('../views/admin/DashboardView.vue') },
      { path: 'users', component: () => import('../views/admin/UserManageView.vue') },
      { path: 'categories', component: () => import('../views/admin/CategoryManageView.vue') },
      { path: 'news', component: () => import('../views/admin/NewsManageView.vue') },
      { path: 'news/add', component: () => import('../views/admin/NewsEditView.vue') },
      { path: 'news/edit/:id', component: () => import('../views/admin/NewsEditView.vue') },
      { path: 'comments', component: () => import('../views/admin/CommentManageView.vue') }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    }
    return { top: 0 }
  }
})

router.beforeEach((to) => {
  const auth = useAuthStore()
  if (to.meta.requiresAuth && !auth.token) {
    return '/login'
  }
  if (to.meta.requiresAdmin && auth.user?.role !== 'ADMIN') {
    return '/news'
  }
  return true
})

export default router
