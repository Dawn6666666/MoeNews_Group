<script setup>
import { onMounted, ref } from 'vue'
import { adminApi } from '../../api'
import { useRouter } from 'vue-router'
import { NIcon } from 'naive-ui'
import {
  PeopleOutline,
  NewspaperOutline,
  ChatboxEllipsesOutline,
  PricetagsOutline,
  CheckmarkCircleOutline,
  DocumentTextOutline,
  AlertCircleOutline,
  GridOutline
} from '@vicons/ionicons5'

const router = useRouter()
const stats = ref({})
const newsList = ref([])
const commentList = ref([])
const loading = ref(false)

const labels = {
  userCount: { 
    label: '用户总数', 
    unit: '人',
    icon: PeopleOutline,
    bg: '#ffffff',
    borderColor: 'rgba(0, 0, 0, 0.05)',
    iconColor: '#6e6e73',
    iconBg: '#f5f5f7'
  },
  newsCount: { 
    label: '新闻总数', 
    unit: '篇',
    icon: NewspaperOutline,
    bg: '#ffffff',
    borderColor: 'rgba(0, 0, 0, 0.05)',
    iconColor: '#6e6e73',
    iconBg: '#f5f5f7'
  },
  commentCount: { 
    label: '评论总数', 
    unit: '条',
    icon: ChatboxEllipsesOutline,
    bg: '#ffffff',
    borderColor: 'rgba(0, 0, 0, 0.05)',
    iconColor: '#6e6e73',
    iconBg: '#f5f5f7'
  },
  categoryCount: { 
    label: '分类总数', 
    unit: '个',
    icon: PricetagsOutline,
    bg: '#ffffff',
    borderColor: 'rgba(0, 0, 0, 0.05)',
    iconColor: '#6e6e73',
    iconBg: '#f5f5f7'
  }
}

const loadData = async () => {
  loading.value = true
  try {
    stats.value = await adminApi.statistics()
    // 加载最新的5条新闻与5条评论
    const newsData = await adminApi.adminNews({ page: 1, size: 5 })
    newsList.value = newsData.records || []
    const commentData = await adminApi.comments({ page: 1, size: 5 })
    commentList.value = commentData.records || []
  } catch (error) {
    console.error('加载统计数据失败', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadData()
})
</script>

<template>
  <n-space vertical :size="16">
    <!-- 核心统计网格 -->
    <div class="stat-grid">
      <div
        v-for="(item, key) in labels"
        :key="key"
        class="glass-stat-card"
        :style="{
          background: item.bg,
          border: '1px solid ' + item.borderColor
        }"
      >
        <div style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
          <div>
            <div style="color: var(--text-muted); font-size: 13px; font-weight: 600; margin-bottom: 4px;">{{ item.label }}</div>
            <div style="display: flex; align-items: baseline; gap: 4px;">
              <span style="font-family: var(--font-title); font-size: 30px; font-weight: 800; color: var(--text-main); line-height: 1;">
                {{ stats[key] || 0 }}
              </span>
              <span style="font-size: 12px; color: var(--text-muted); font-weight: 600;">{{ item.unit }}</span>
            </div>
          </div>
          <div :style="{ background: item.iconBg, color: item.iconColor }" class="icon-wrapper">
            <n-icon size="22"><component :is="item.icon" /></n-icon>
          </div>
        </div>
      </div>
    </div>

    <!-- 文章状态次级卡片 -->
    <n-card title="文章发布状态分布" :bordered="false" :content-style="{ padding: '10px 16px' }">
      <n-grid cols="1 s:3" responsive="screen" :x-gap="20" :y-gap="12">
        <!-- 已发布 -->
        <n-grid-item>
          <div class="status-card border-primary">
            <div style="flex: 1; text-align: left;">
              <div style="color: var(--text-muted); font-size: 13px; margin-bottom: 4px; font-weight: 600;">已发布文章</div>
              <div style="font-size: 22px; font-weight: 800; color: var(--primary-color); font-family: var(--font-title); line-height: 1.1;">
                {{ stats.publishedNewsCount || 0 }} <span style="font-size: 12px; color: var(--text-muted); font-weight: 600; margin-left: 2px;">篇</span>
              </div>
            </div>
            <n-icon size="28" class="status-bg-icon text-primary"><CheckmarkCircleOutline /></n-icon>
          </div>
        </n-grid-item>

        <!-- 草稿箱 -->
        <n-grid-item>
          <div class="status-card border-secondary">
            <div style="flex: 1; text-align: left;">
              <div style="color: var(--text-muted); font-size: 13px; margin-bottom: 4px; font-weight: 600;">草稿箱</div>
              <div style="font-size: 22px; font-weight: 800; color: var(--secondary-color); font-family: var(--font-title); line-height: 1.1;">
                {{ stats.draftNewsCount || 0 }} <span style="font-size: 12px; color: var(--text-muted); font-weight: 600; margin-left: 2px;">篇</span>
              </div>
            </div>
            <n-icon size="28" class="status-bg-icon text-secondary"><DocumentTextOutline /></n-icon>
          </div>
        </n-grid-item>

        <!-- 已下架 -->
        <n-grid-item>
          <div class="status-card border-accent">
            <div style="flex: 1; text-align: left;">
              <div style="color: var(--text-muted); font-size: 13px; margin-bottom: 4px; font-weight: 600;">已下架文章</div>
              <div style="font-size: 22px; font-weight: 800; color: var(--accent-color); font-family: var(--font-title); line-height: 1.1;">
                {{ stats.offlineNewsCount || 0 }} <span style="font-size: 12px; color: var(--text-muted); font-weight: 600; margin-left: 2px;">篇</span>
              </div>
            </div>
            <n-icon size="28" class="status-bg-icon text-accent"><AlertCircleOutline /></n-icon>
          </div>
        </n-grid-item>
      </n-grid>
    </n-card>

    <n-grid cols="1 l:3" responsive="screen" :x-gap="20" :y-gap="16">
      <!-- 快捷通道 -->
      <n-grid-item span="1">
        <n-card title="快捷管理通道" style="height: 100%;" :bordered="false" :content-style="{ padding: '12px 14px' }">
          <n-grid :cols="2" :x-gap="12" :y-gap="12">
            <n-grid-item>
              <div class="quick-link-btn btn-primary" @click="router.push('/admin/news/add')">
                <n-icon size="20"><NewspaperOutline /></n-icon>
                <span>撰写发布</span>
              </div>
            </n-grid-item>
            <n-grid-item>
              <div class="quick-link-btn btn-info" @click="router.push('/admin/news')">
                <n-icon size="20"><GridOutline /></n-icon>
                <span>文章管理</span>
              </div>
            </n-grid-item>
            <n-grid-item>
              <div class="quick-link-btn btn-success" @click="router.push('/admin/categories')">
                <n-icon size="20"><PricetagsOutline /></n-icon>
                <span>分类维护</span>
              </div>
            </n-grid-item>
            <n-grid-item>
              <div class="quick-link-btn btn-warning" @click="router.push('/admin/comments')">
                <n-icon size="20"><ChatboxEllipsesOutline /></n-icon>
                <span>评论审核</span>
              </div>
            </n-grid-item>
          </n-grid>
        </n-card>
      </n-grid-item>

      <!-- 最新发布与最新评论 -->
      <n-grid-item span="2">
        <n-card title="系统最新动态" style="height: 100%;" :bordered="false" :content-style="{ padding: '8px 16px' }">
          <n-tabs type="line" animated style="margin-top: -4px;">
            <!-- 最新发布 -->
            <n-tab-pane name="news" tab="最近发布">
              <div v-if="newsList.length === 0" style="padding: 20px 0; text-align: center;">
                <n-empty description="暂无发布内容" />
              </div>
              <n-list v-else style="background: transparent;">
                <n-list-item v-for="item in newsList" :key="item.id" class="dynamic-item" style="padding: 6px 12px; margin-bottom: 4px;">
                  <div style="display: flex; justify-content: space-between; align-items: center;">
                    <n-space vertical :size="2">
                      <a style="font-weight: 700; font-size: 13px; color: var(--text-main); cursor: pointer; transition: color 0.2s; max-width: 320px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; display: inline-block;" @click="router.push(`/admin/news/edit/${item.id}`)" class="title-link">
                        {{ item.title }}
                      </a>
                      <span style="font-size: 11px; color: var(--text-muted); font-weight: 500;">{{ item.createTime }}</span>
                    </n-space>
                    <n-tag :bordered="false" size="small" :type="item.status === 1 ? 'primary' : item.status === 0 ? 'warning' : 'error'" style="border-radius: 6px; font-weight: 600;">
                      {{ item.status === 1 ? '已发布' : item.status === 0 ? '草稿' : '已下架' }}
                    </n-tag>
                  </div>
                </n-list-item>
              </n-list>
            </n-tab-pane>

            <!-- 最近评论 -->
            <n-tab-pane name="comments" tab="最新评论">
              <div v-if="commentList.length === 0" style="padding: 20px 0; text-align: center;">
                <n-empty description="暂无最新评论" />
              </div>
              <n-list v-else style="background: transparent;">
                <n-list-item v-for="item in commentList" :key="item.id" class="dynamic-item" style="padding: 6px 12px; margin-bottom: 4px;">
                  <n-space vertical :size="2">
                    <div style="font-size: 12px; color: var(--text-main); line-height: 1.4; max-width: 480px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                      <strong style="color: var(--primary-color);">{{ item.nickname }}</strong>：{{ item.content }}
                    </div>
                    <span style="font-size: 11px; color: var(--text-muted); font-weight: 500;">发表于 {{ item.createTime }}</span>
                  </n-space>
                </n-list-item>
              </n-list>
            </n-tab-pane>
          </n-tabs>
        </n-card>
      </n-grid-item>
    </n-grid>
  </n-space>
</template>

<style scoped>
.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 4px;
}

.glass-stat-card {
  padding: 18px 24px;
  border-radius: var(--radius-sm);
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  display: flex;
  align-items: center;
  backdrop-filter: blur(12px);
  transition: var(--transition);
}

.glass-stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

.icon-wrapper {
  width: 44px;
  height: 44px;
  border-radius: var(--radius-sm);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: var(--transition);
}

.glass-stat-card:hover .icon-wrapper {
  transform: scale(1.05);
}

.status-card {
  background: #ffffff;
  padding: 8px 14px;
  border-radius: var(--radius-sm);
  display: flex;
  align-items: center;
  justify-content: space-between;
  border: 1px solid var(--border-color);
  box-shadow: 0 1px 2px rgba(0,0,0,0.03);
  transition: var(--transition);
  position: relative;
  overflow: hidden;
}

.status-card:hover {
  transform: translateY(-1px);
  box-shadow: 0 3px 8px rgba(0,0,0,0.06);
}

.border-primary {
  border-left: 4px solid var(--primary-color);
}
.border-secondary {
  border-left: 4px solid var(--secondary-color);
}
.border-accent {
  border-left: 4px solid var(--accent-color);
}

.status-bg-icon {
  opacity: 0.08;
  transition: var(--transition);
}

.status-card:hover .status-bg-icon {
  opacity: 0.15;
  transform: scale(1.05);
}

.text-primary {
  color: var(--primary-color);
}
.text-secondary {
  color: var(--secondary-color);
}
.text-accent {
  color: var(--accent-color);
}

.quick-link-btn {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 8px;
  height: 54px;
  border-radius: var(--radius-sm);
  cursor: pointer;
  font-weight: 700;
  font-size: 13px;
  transition: var(--transition);
  border: 1px solid var(--border-color);
  background: #ffffff;
  color: var(--text-main);
  box-shadow: 0 1px 2px rgba(0,0,0,0.03);
}

.quick-link-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 10px rgba(0,0,0,0.06);
}

.btn-primary:hover {
  border-color: var(--primary-color);
  background: var(--primary-light);
  color: var(--primary-color);
}

.btn-info:hover {
  border-color: var(--secondary-color);
  background: #e0f2fe;
  color: var(--secondary-color);
}

.btn-success:hover {
  border-color: #4caf50;
  background: #e8f5e9;
  color: #4caf50;
}

.btn-warning:hover {
  border-color: var(--accent-color);
  background: #fff3e0;
  color: var(--accent-color);
}

.dynamic-item {
  border-radius: var(--radius-sm);
  background: rgba(255, 255, 255, 0.4);
  border: 1px solid transparent;
  transition: var(--transition);
}

.dynamic-item:hover {
  background: #ffffff !important;
  border-color: var(--border-color) !important;
  box-shadow: var(--shadow-sm) !important;
  transform: translateX(4px);
}

.title-link:hover {
  color: var(--primary-color) !important;
}

@media (max-width: 1200px) {
  .stat-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 600px) {
  .stat-grid {
    grid-template-columns: 1fr;
  }
}
</style>
