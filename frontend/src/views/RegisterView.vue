<script setup>
import { reactive } from 'vue'
import { useMessage } from 'naive-ui'
import { useRouter } from 'vue-router'
import { authApi } from '../api'

const router = useRouter()
const message = useMessage()
const form = reactive({ username: '', password: '', confirmPassword: '', nickname: '' })

const submit = async () => {
  if (!form.username || !form.password || !form.nickname) {
    message.warning('请填写完整的注册信息')
    return
  }
  if (form.password !== form.confirmPassword) {
    message.error('两次输入的密码不一致')
    return
  }
  try {
    await authApi.register(form)
    message.success('注册成功，请登录')
    router.push('/login')
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

    <!-- 注册毛玻璃面板 -->
    <n-card class="auth-panel" :bordered="false" style="padding: 16px 20px;">
      <div style="text-align: center; margin-bottom: 28px;">
        <span style="font-family: var(--font-title); font-size: 32px; font-weight: 800; background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; letter-spacing: -1px;">MoeNews</span>
        <p style="color: var(--text-muted); font-size: 14px; margin: 8px 0 0; font-weight: 500;">欢迎加入 MoeNews，开启探索之旅</p>
      </div>

      <n-form :model="form" label-placement="top">
        <n-form-item label="用户名">
          <n-input v-model:value="form.username" placeholder="可以使用英文字母或数字" />
        </n-form-item>
        <n-form-item label="昵称">
          <n-input v-model:value="form.nickname" placeholder="请输入您的个性昵称" />
        </n-form-item>
        <n-form-item label="密码">
          <n-input v-model:value="form.password" type="password" placeholder="请输入密码" show-password-on="click" />
        </n-form-item>
        <n-form-item label="确认密码">
          <n-input v-model:value="form.confirmPassword" type="password" placeholder="请再次输入密码" show-password-on="click" />
        </n-form-item>
        
        <n-button type="primary" block round size="large" style="margin-top: 14px; font-weight: 600;" @click="submit">
          立即注册
        </n-button>
      </n-form>
      <n-divider />
      <div style="text-align: center; margin-top: -8px;">
        <n-button text style="font-weight: 600; color: var(--secondary-color);" @click="router.push('/login')">已有账号？去登录</n-button>
      </div>
    </n-card>
  </div>
</template>
