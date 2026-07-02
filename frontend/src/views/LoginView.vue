<script setup>
import { reactive } from 'vue'
import { useMessage } from 'naive-ui'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const message = useMessage()
const auth = useAuthStore()
const form = reactive({ username: '', password: '' })

const submit = async () => {
  try {
    const user = await auth.login(form)
    message.success('登录成功')
    router.push(user.role === 'ADMIN' ? '/admin/dashboard' : '/news')
  } catch (error) {
    message.error(error.message)
  }
}
</script>

<template>
  <div class="auth-page">
    <!-- 动态背景气泡 -->
    <div class="auth-bg-bubbles">
      <div class="auth-bubble auth-bubble-1"></div>
      <div class="auth-bubble auth-bubble-2"></div>
    </div>

    <!-- 登录毛玻璃面板 -->
    <n-card class="auth-panel" :bordered="false" style="padding: 16px 20px;">
      <div style="text-align: center; margin-bottom: 32px;">
        <span style="font-family: var(--font-title); font-size: 32px; font-weight: 800; background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; letter-spacing: -1px;">MoeNews</span>
        <p style="color: var(--text-muted); font-size: 14px; margin: 8px 0 0; font-weight: 500;">欢迎回来，请登录您的账号</p>
      </div>

      <n-form :model="form" label-placement="top">
        <n-form-item label="用户名">
          <n-input v-model:value="form.username" placeholder="请输入用户名" />
        </n-form-item>
        <n-form-item label="密码">
          <n-input v-model:value="form.password" type="password" placeholder="请输入密码" show-password-on="click" />
        </n-form-item>
        <n-button type="primary" block round size="large" style="margin-top: 14px; font-weight: 600;" @click="submit">
          立即登录
        </n-button>
      </n-form>
      <n-divider />
      <div style="text-align: center; margin-top: -8px;">
        <n-button text style="font-weight: 600; color: var(--secondary-color);" @click="router.push('/register')">没有账号？去注册</n-button>
      </div>
    </n-card>
  </div>
</template>
