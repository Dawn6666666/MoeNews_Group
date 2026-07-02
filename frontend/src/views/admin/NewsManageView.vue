<script setup>
import { h, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { NButton, NSpace, NTag, NIcon, useDialog, useMessage } from 'naive-ui'
import { 
  SearchOutline, 
  RefreshOutline, 
  AddOutline, 
  CreateOutline, 
  TrashOutline, 
  SendOutline, 
  ArrowDownCircleOutline 
} from '@vicons/ionicons5'
import { adminApi } from '../../api'
import { newsStatusOptions } from '../../utils/options'

const router = useRouter()
const message = useMessage()
const dialog = useDialog()
const rows = ref([])
const categories = ref([])
const loading = ref(false)
const query = reactive({ page: 1, size: 10, keyword: '', categoryId: null, status: null, itemCount: 0 })

const loadCategories = async () => {
  try {
    const data = await adminApi.categories({ page: 1, size: 100, status: 1 })
    categories.value = data.records.map((item) => ({ label: item.name, value: item.id }))
  } catch (error) {
    message.error(error.message || '加载分类列表失败')
  }
}
const load = async () => {
  loading.value = true
  try {
    const data = await adminApi.adminNews(query)
    rows.value = data.records
    query.itemCount = data.total
  } catch (error) {
    message.error(error.message || '加载新闻列表失败')
  } finally {
    loading.value = false
  }
}
const remove = (id) => dialog.warning({
  title: '确认删除新闻',
  content: '删除采用逻辑删除，删除后前台将不再展示该新闻。',
  positiveText: '删除',
  negativeText: '取消',
  onPositiveClick: async () => {
    try {
      await adminApi.deleteNews(id)
      message.success('删除成功')
      load()
    } catch (error) {
      message.error(error.message || '删除失败')
    }
  }
})

const toggleNewsStatus = (row, status) => {
  const action = status === 1 ? '发布' : '下架'
  dialog.warning({
    title: `确认${action}新闻`,
    content: `您确定要${action}新闻“${row.title}”吗？`,
    positiveText: '确认',
    negativeText: '取消',
    onPositiveClick: async () => {
      try {
        await adminApi.newsStatus(row.id, status)
        message.success(`${action}成功`)
        load()
      } catch (error) {
        message.error(error.message || `${action}失败`)
      }
    }
  })
}

// 格式化标签与按钮样式以匹配 Soybean Admin 柔和风格并整合微图标
const columns = [
  { title: 'ID', key: 'id', width: 70 },
  { title: '标题', key: 'title', ellipsis: { tooltip: true } },
  { title: '分类', key: 'categoryName', width: 120, ellipsis: { tooltip: true } },
  { title: '浏览量', key: 'viewCount', width: 90 },
  { 
    title: '状态', 
    key: 'status', 
    width: 100, 
    render: (row) => {
      const type = row.status === 1 ? 'success' : row.status === 0 ? 'warning' : 'error'
      const label = row.status === 1 ? '已发布' : row.status === 0 ? '草稿' : '已下架'
      return h(
        NTag, 
        { type, bordered: false, style: { fontWeight: '600' } }, 
        { default: () => label }
      )
    } 
  },
  { title: '操作', key: 'actions', width: 310, fixed: 'right', render: (row) => h(NSpace, { size: 4, wrap: false }, { default: () => [
    h(NButton, { size: 'small', type: 'primary', quaternary: true, onClick: () => router.push(`/admin/news/edit/${row.id}`) }, { 
      default: () => '编辑',
      icon: () => h(NIcon, null, { default: () => h(CreateOutline) })
    }),
    h(NButton, { size: 'small', type: 'success', secondary: true, disabled: row.status === 1, onClick: () => toggleNewsStatus(row, 1) }, { 
      default: () => '发布',
      icon: () => h(NIcon, null, { default: () => h(SendOutline) })
    }),
    h(NButton, { size: 'small', type: 'warning', secondary: true, disabled: row.status === 2, onClick: () => toggleNewsStatus(row, 2) }, { 
      default: () => '下架',
      icon: () => h(NIcon, null, { default: () => h(ArrowDownCircleOutline) })
    }),
    h(NButton, { size: 'small', type: 'error', quaternary: true, onClick: () => remove(row.id) }, { 
      default: () => '删除',
      icon: () => h(NIcon, null, { default: () => h(TrashOutline) })
    })
  ]}) }
]
onMounted(() => { loadCategories(); load() })
</script>

<template>
  <div class="toolbar">
    <n-input v-model:value="query.keyword" clearable placeholder="搜索新闻标题..." style="max-width: 240px" @keyup.enter="query.page = 1; load()" />
    <n-select v-model:value="query.categoryId" clearable :options="categories" placeholder="选择新闻分类" style="max-width: 170px" @update:value="query.page = 1; load()" />
    <n-select v-model:value="query.status" clearable :options="newsStatusOptions" placeholder="选择状态" style="max-width: 150px" @update:value="query.page = 1; load()" />
    <n-button type="primary" round @click="query.page = 1; load()">
      <template #icon><n-icon><SearchOutline /></n-icon></template>
      查询
    </n-button>
    <n-button round @click="query.keyword = ''; query.categoryId = null; query.status = null; query.page = 1; load()">
      <template #icon><n-icon><RefreshOutline /></n-icon></template>
      重置
    </n-button>
  </div>
  
  <n-card title="新闻列表" style="border-radius: var(--radius-md); box-shadow: var(--shadow-sm);">
    <template #header-extra>
      <n-button type="primary" round @click="router.push('/admin/news/add')">
        <template #icon><n-icon><AddOutline /></n-icon></template>
        发布新闻
      </n-button>
    </template>
    
    <n-data-table :columns="columns" :data="rows" :loading="loading" :pagination="false" :bordered="false" :scroll-x="1000" size="small" />
    
    <n-space justify="end" style="margin-top: 20px">
      <n-pagination 
        v-model:page="query.page" 
        :page-size="query.size" 
        :item-count="query.itemCount" 
        show-size-picker
        :page-sizes="[10, 20, 50]"
        @update:page="load" 
        @update:page-size="(val) => { query.size = val; query.page = 1; load(); }"
      />
    </n-space>
  </n-card>
</template>

