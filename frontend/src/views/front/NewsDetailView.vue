<script setup>
import { onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useMessage, useDialog } from 'naive-ui'
import { MdPreview } from 'md-editor-v3'
import { newsApi } from '../../api'
import { useAuthStore } from '../../stores/auth'
import { assetUrl } from '../../utils/url'

const route = useRoute()
const router = useRouter()
const message = useMessage()
const dialog = useDialog()
const auth = useAuthStore()
const detail = ref({})
const comments = ref([])
const content = ref('')
const loading = ref(false)
const error = ref(null)
const pager = reactive({ page: 1, size: 10, itemCount: 0 })

const loadDetail = async () => {
  loading.value = true
  error.value = null
  try {
    detail.value = await newsApi.detail(route.params.id)
  } catch (err) {
    error.value = err.message || '加载新闻失败'
  } finally {
    loading.value = false
  }
}
const loadComments = async () => {
  try {
    const data = await newsApi.comments(route.params.id, pager)
    comments.value = data.records
    pager.itemCount = data.total
  } catch (err) {
    message.error(err.message || '加载评论失败')
  }
}
const submitComment = async () => {
  if (!auth.token) {
    router.push('/login')
    return
  }
  if (!content.value.trim()) {
    message.warning('评论内容不能为空')
    return
  }
  try {
    await newsApi.comment(route.params.id, { content: content.value })
    content.value = ''
    message.success('评论成功')
    loadComments()
  } catch (err) {
    message.error(err.message || '评论失败')
  }
}
const remove = (id) => {
  dialog.warning({
    title: '确认删除评论',
    content: '删除后前台将不再展示该评论。',
    positiveText: '删除',
    negativeText: '取消',
    onPositiveClick: async () => {
      try {
        await newsApi.deleteComment(id)
        message.success('删除成功')
        loadComments()
      } catch (err) {
        message.error(err.message || '删除失败')
      }
    }
  })
}

// 根据昵称计算二次元彩色头像背景色
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

onMounted(() => {
  loadDetail()
  loadComments()
})
</script>

<template>
  <section class="page" style="max-width: 860px;">
    <!-- 加载状态 -->
    <div v-if="loading" style="display: flex; justify-content: center; align-items: center; min-height: 400px; background: #ffffff; border-radius: var(--radius-lg); box-shadow: var(--shadow-md);">
      <n-spin size="large" description="正在加载新闻内容..." />
    </div>

    <!-- 异常或内容为空 -->
    <div v-else-if="error || !detail.id" style="background: #ffffff; border-radius: var(--radius-lg); box-shadow: var(--shadow-md); padding: 60px 40px; text-align: center;">
      <n-result status="error" title="无法获取新闻内容" :description="error || '该新闻可能不存在或已被删除'">
        <template #footer>
          <n-button type="primary" round @click="router.push('/news')">返回新闻列表</n-button>
        </template>
      </n-result>
    </div>

    <!-- 详情内容 -->
    <div v-else>
      <!-- 优雅的返回导航 -->
      <div style="margin-bottom: 20px; display: flex; align-items: center; gap: 8px;">
        <n-button 
          secondary 
          round 
          size="medium" 
          style="font-weight: 700; border-radius: var(--radius-sm); box-shadow: var(--shadow-sm);" 
          @click="router.push('/news')"
        >
          <template #icon>
            <span style="font-weight: 900;">&larr;</span>
          </template>
          返回列表
        </n-button>
      </div>

      <!-- 详情卡片 -->
      <n-card :bordered="false" style="border-radius: var(--radius-md); box-shadow: var(--shadow-sm); padding: 12px 16px;">
        <!-- 顶部优雅大图 -->
        <div v-if="detail.coverImage" style="width: 100%; aspect-ratio: 21 / 9; overflow: hidden; border-radius: var(--radius-md); margin-bottom: 28px;">
          <img :src="assetUrl(detail.coverImage)" alt="封面" style="width: 100%; height: 100%; object-fit: cover;">
        </div>

        <!-- 杂志化标题与元数据区域 -->
        <div style="margin-bottom: 32px; text-align: left; padding: 0 10px;">
          <n-tag :bordered="false" type="primary" size="small" style="border-radius: 4px; font-weight: 700; margin-bottom: 12px;">
            {{ detail.categoryName || '资讯' }}
          </n-tag>
          <h1 style="font-family: var(--font-title); font-size: clamp(24px, 2.5vw, 36px); font-weight: 800; color: var(--text-main); line-height: 1.25; margin: 0 0 16px;">
            {{ detail.title }}
          </h1>
          <div style="display: flex; gap: 16px; color: var(--text-muted); font-size: 13px; font-weight: 500; border-bottom: 1px solid rgba(0, 0, 0, 0.05); padding-bottom: 16px;">
            <span>发布时间：{{ detail.createTime }}</span>
            <span>•</span>
            <span>浏览次数：{{ detail.viewCount || 0 }} 次</span>
          </div>
        </div>

        <!-- 正文渲染 -->
        <div style="padding: 0 10px; max-width: 720px; margin: 0 auto;" class="moe-markdown">
          <MdPreview editor-id="front-preview" :model-value="detail.content || ''" />
        </div>
      </n-card>

    <!-- 评论区域 -->
    <n-card title="发表评论" style="margin-top: 24px; border-radius: var(--radius-md); box-shadow: var(--shadow-sm);" :bordered="false">
      <n-input
        v-model:value="content"
        type="textarea"
        maxlength="500"
        show-count
        placeholder="发表你的友善评论，一起交流吧..."
        :rows="3"
        style="border-radius: var(--radius-sm);"
      />
      <n-space justify="end" style="margin-top: 14px">
        <n-button type="primary" round style="padding: 0 24px; font-weight: 700;" @click="submitComment">发表评论</n-button>
      </n-space>

      <n-divider title-placement="left" style="margin-top: 32px;">
        <span style="font-weight: 800; font-size: 16px; color: var(--text-main); font-family: var(--font-title);">评论列表 ({{ pager.itemCount }})</span>
      </n-divider>

      <!-- 空评论状态 -->
      <div v-if="comments.length === 0" style="padding: 40px 0; text-align: center;">
        <n-empty description="暂无评论，快来发表第一条评论吧！" size="large" />
      </div>

      <!-- 评论列表 -->
      <n-list v-else style="background: transparent;">
        <n-list-item
          v-for="item in comments"
          :key="item.id"
          class="comment-card slide-up-fade"
          style="padding: 16px 20px; margin-bottom: 12px;"
        >
          <n-thing>
            <!-- 头像插槽 -->
            <template #avatar>
              <n-avatar
                round
                :size="42"
                :style="{ backgroundColor: getAvatarColor(item.nickname), color: '#ffffff', fontWeight: '800', boxShadow: '0 4px 10px rgba(0,0,0,0.05)' }"
              >
                {{ getAvatarLabel(item.nickname) }}
              </n-avatar>
            </template>
            <!-- 昵称与时间 -->
            <template #title>
              <div style="display: flex; align-items: center; gap: 8px;">
                <span style="font-weight: 700; color: var(--text-main); font-size: 14px;">{{ item.nickname }}</span>
                <!-- 管理员/读者标签 -->
                <n-tag v-if="item.userId === 1 || item.nickname === 'admin'" :bordered="false" size="mini" type="error" style="border-radius: 4px; font-size: 10px; font-weight: 800; padding: 0 6px;">
                  管理员
                </n-tag>
                <n-tag v-else :bordered="false" size="mini" type="info" style="border-radius: 4px; font-size: 10px; font-weight: 800; padding: 0 6px;">
                  读者
                </n-tag>
              </div>
            </template>
            <template #description>
              <span style="font-size: 11px; color: var(--text-muted); font-weight: 500;">{{ item.createTime }}</span>
            </template>
            <!-- 评论内容 -->
            <div style="font-size: 14px; color: var(--text-main); line-height: 1.6; margin-top: 6px; word-break: break-all;">
              {{ item.content }}
            </div>
            <!-- 底部删除操作 -->
            <template #footer>
              <n-space justify="end" v-if="auth.user?.id === item.userId || auth.user?.role === 'ADMIN'">
                <n-button text type="error" size="small" style="font-weight: 600; font-size: 12px;" @click="remove(item.id)">
                  删除评论
                </n-button>
              </n-space>
            </template>
          </n-thing>
        </n-list-item>
      </n-list>

      <!-- 评论分页 -->
      <n-space v-if="pager.itemCount > pager.size" justify="center" style="margin-top: 24px;">
        <n-pagination
          v-model:page="pager.page"
          :page-size="pager.size"
          :item-count="pager.itemCount"
          simple
          @update:page="loadComments"
        />
      </n-space>
    </n-card>
    </div>
    <!-- 回到顶部 -->
    <n-back-top :right="40" :bottom="80" />
  </section>
</template>
