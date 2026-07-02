<script setup>
import { computed, h } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { NIcon } from 'naive-ui'
import { ChatboxEllipsesOutline, GridOutline, NewspaperOutline, PeopleOutline, PricetagsOutline, HomeOutline } from '@vicons/ionicons5'
import { useAuthStore } from '../stores/auth'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const renderIcon = (icon) => () => h(NIcon, null, { default: () => h(icon) })
const menuOptions = [
  { label: () => h(RouterLink, { to: '/admin/dashboard' }, { default: () => '首页统计' }), key: '/admin/dashboard', icon: renderIcon(GridOutline) },
  { label: () => h(RouterLink, { to: '/admin/users' }, { default: () => '用户管理' }), key: '/admin/users', icon: renderIcon(PeopleOutline) },
  { label: () => h(RouterLink, { to: '/admin/categories' }, { default: () => '分类管理' }), key: '/admin/categories', icon: renderIcon(PricetagsOutline) },
  { label: () => h(RouterLink, { to: '/admin/news' }, { default: () => '新闻管理' }), key: '/admin/news', icon: renderIcon(NewspaperOutline) },
  { label: () => h(RouterLink, { to: '/admin/comments' }, { default: () => '评论管理' }), key: '/admin/comments', icon: renderIcon(ChatboxEllipsesOutline) }
]
const activeKey = computed(() => menuOptions.find((item) => route.path.startsWith(item.key))?.key)

const logout = () => {
  auth.logout()
  router.push('/login')
}

// 下拉菜单配置
const dropdownOptions = [
  { label: '前台首页', key: 'front' },
  { label: '退出登录', key: 'logout' }
]

const handleDropdownSelect = (key) => {
  if (key === 'front') {
    router.push('/news')
  } else if (key === 'logout') {
    logout()
  }
}

// 萌系二次元色头像辅助函数
const getAvatarColor = (nickname) => {
  if (!nickname) return '#FF6B8B'
  let hash = 0
  for (let i = 0; i < nickname.length; i++) {
    hash = nickname.charCodeAt(i) + ((hash << 5) - hash)
  }
  const colors = ['#FF6B8B', '#4EA8DE', '#FF8E3C', '#B388FF', '#FF80AB', '#80D8FF', '#FFD180']
  return colors[Math.abs(hash) % colors.length]
}

const getAvatarLabel = (nickname) => {
  return nickname ? nickname.charAt(0).toUpperCase() : 'M'
}

const adminThemeOverrides = {
  common: {
    primaryColor: '#ff5f8a',
    primaryColorHover: '#e04670',
    primaryColorPressed: '#c9345a',
    primaryColorSuppl: '#fcf8f9',
    borderRadius: '6px',
    borderRadiusSmall: '4px',
    borderColor: '#e5e7eb'
  },
  Card: {
    borderRadius: '8px',
    borderColor: '#e5e7eb',
    boxShadow: '0 1px 3px 0 rgba(0, 0, 0, 0.05)',
    paddingMedium: '16px 20px',
    titleFontSizeMedium: '16px'
  },
  Menu: {
    borderRadius: '6px',
    itemColorActive: 'rgba(255, 95, 138, 0.06)',
    itemColorActiveHover: 'rgba(255, 95, 138, 0.06)',
    itemTextColorActive: '#ff5f8a',
    itemTextColorActiveHover: '#e04670',
    itemIconColorActive: '#ff5f8a',
    itemIconColorActiveHover: '#e04670'
  },
  Breadcrumb: {
    fontSize: '13px',
    itemTextColor: '#6e6e73',
    itemTextColorHover: '#ff5f8a',
    itemTextColorPressed: '#e04670',
    itemTextColorActive: '#1d1d1f',
    separatorColor: '#d2d2d7',
    fontWeightActive: '700'
  },
  DataTable: {
    thPaddingMedium: '8px 12px',
    tdPaddingMedium: '8px 12px',
    fontSizeMedium: '13px',
    thColor: '#f9fafb',
    thTextColor: '#374151',
    tdTextColor: '#1f2937',
    borderColor: '#f3f4f6'
  }
}
</script>

<template>
  <n-config-provider :theme-overrides="adminThemeOverrides" style="height: 100%">
    <n-layout has-sider class="admin-shell">
    <n-layout-sider class="admin-sider" :width="220" collapse-mode="width" :collapsed-width="64" show-trigger bordered>
      <div style="height: 64px; display: flex; align-items: center; justify-content: center; border-bottom: 1px solid var(--border-color)">
        <span style="font-family: var(--font-title); font-size: 22px; font-weight: 800; background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; letter-spacing: -0.5px; transition: var(--transition);">MoeNews</span>
      </div>
      <n-menu :value="activeKey" :options="menuOptions" style="padding: 12px 6px;" />
    </n-layout-sider>
    <n-layout>
      <n-layout-header class="admin-header">
          <n-breadcrumb style="font-size: 14px;">
            <n-breadcrumb-item @click="router.push('/admin/dashboard')" style="cursor: pointer;">系统后台</n-breadcrumb-item>
            <n-breadcrumb-item v-if="route.path.includes('/dashboard')">首页统计</n-breadcrumb-item>
            <n-breadcrumb-item v-else-if="route.path.includes('/users')">用户管理</n-breadcrumb-item>
            <n-breadcrumb-item v-else-if="route.path.includes('/categories')">分类管理</n-breadcrumb-item>
            <n-breadcrumb-item v-else-if="route.path.includes('/news/add')">发布新闻</n-breadcrumb-item>
            <n-breadcrumb-item v-else-if="route.path.includes('/news/edit')">编辑新闻</n-breadcrumb-item>
            <n-breadcrumb-item v-else-if="route.path.includes('/news')">新闻管理</n-breadcrumb-item>
            <n-breadcrumb-item v-else-if="route.path.includes('/comments')">评论管理</n-breadcrumb-item>
          </n-breadcrumb>
        <n-space align="center" :size="12">
          <n-button secondary round size="small" type="primary" @click="router.push('/news')">
            <template #icon>
              <n-icon><HomeOutline /></n-icon>
            </template>
            返回前台
          </n-button>
          <n-dropdown :options="dropdownOptions" @select="handleDropdownSelect" trigger="hover">
            <div style="display: flex; align-items: center; gap: 8px; cursor: pointer; padding: 6px 12px; border-radius: var(--radius-sm); transition: var(--transition);" class="front-link">
              <n-avatar
                round
                size="small"
                :style="{ backgroundColor: getAvatarColor(auth.user?.nickname), color: '#ffffff', fontWeight: 'bold' }"
              >
                {{ getAvatarLabel(auth.user?.nickname) }}
              </n-avatar>
              <span style="font-weight: 600; color: var(--text-main); font-size: 14px;">{{ auth.user?.nickname }}</span>
            </div>
          </n-dropdown>
        </n-space>
      </n-layout-header>
      <n-layout-content class="admin-content">
        <router-view />
      </n-layout-content>
    </n-layout>
  </n-layout>
 </n-config-provider>
</template>
