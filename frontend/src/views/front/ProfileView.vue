<script setup>
import { reactive } from 'vue'
import { useMessage } from 'naive-ui'
import { authApi } from '../../api'
import { useAuthStore } from '../../stores/auth'

const auth = useAuthStore()
const message = useMessage()
const form = reactive({ ...auth.user })

const submit = async () => {
  try {
    const user = await authApi.updateMe(form)
    auth.user = user
    localStorage.setItem('user', JSON.stringify(user))
    message.success('资料已更新')
  } catch (error) {
    message.error(error.message)
  }
}

// 萌系二次元头像辅助函数
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
</script>

<template>
  <section class="page" style="display: flex; justify-content: center; align-items: center; padding: 40px 0;">
    <n-card
      title="个人中心"
      :bordered="false"
      style="max-width: 580px; width: 100%; border-radius: var(--radius-lg); box-shadow: var(--shadow-md);"
    >
      <div style="display: flex; flex-direction: column; align-items: center; margin-bottom: 24px;">
        <n-avatar
          round
          :size="88"
          :style="{ backgroundColor: getAvatarColor(form.nickname), color: '#ffffff', fontWeight: 'bold', fontSize: '36px', marginBottom: '16px', boxShadow: '0 8px 20px rgba(255, 107, 139, 0.2)' }"
        >
          {{ getAvatarLabel(form.nickname) }}
        </n-avatar>
        <span style="font-size: 22px; font-weight: 800; color: var(--text-main);">{{ form.nickname || '未设置昵称' }}</span>
        <span style="font-size: 13px; color: var(--text-muted); margin-top: 6px; font-weight: 500;">角色属性：{{ form.role === 'ADMIN' ? '管理员' : '普通用户' }}</span>
      </div>

      <n-divider style="margin: 0 0 28px;" />

      <n-form :model="form" label-placement="left" label-width="80">
        <n-form-item label="登录账号">
          <n-input v-model:value="form.username" disabled placeholder="请输入用户名" />
        </n-form-item>
        <n-form-item label="我的昵称">
          <n-input v-model:value="form.nickname" placeholder="请输入您的昵称" />
        </n-form-item>
        <n-form-item label="绑定邮箱">
          <n-input v-model:value="form.email" placeholder="请输入您的邮箱" />
        </n-form-item>
        <n-form-item label="联系电话">
          <n-input v-model:value="form.phone" placeholder="请输入您的手机号" />
        </n-form-item>
        
        <n-space justify="end" style="margin-top: 24px;">
          <n-button type="primary" round style="padding: 0 32px; font-weight: 600;" @click="submit">
            保存资料
          </n-button>
        </n-space>
      </n-form>
    </n-card>
  </section>
</template>
