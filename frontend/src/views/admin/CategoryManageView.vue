<script setup>
import { h, onMounted, reactive, ref } from 'vue'
import { NButton, NSpace, NTag, NIcon, useDialog, useMessage } from 'naive-ui'
import { 
  SearchOutline, 
  RefreshOutline, 
  AddOutline, 
  CreateOutline, 
  TrashOutline, 
  CheckmarkCircleOutline, 
  CloseCircleOutline 
} from '@vicons/ionicons5'
import { adminApi } from '../../api'
import { statusOptions } from '../../utils/options'

const message = useMessage()
const dialog = useDialog()
const rows = ref([])
const show = ref(false)
const editingId = ref(null)
const loading = ref(false)
const query = reactive({ page: 1, size: 10, keyword: '', status: null, itemCount: 0 })
const form = reactive({ name: '', description: '', sort: 0, status: 1 })

const load = async () => {
  loading.value = true
  try {
    const data = await adminApi.categories(query)
    rows.value = data.records
    query.itemCount = data.total
  } catch (error) {
    message.error(error.message || '加载数据失败')
  } finally {
    loading.value = false
  }
}
const open = (row) => {
  editingId.value = row?.id || null
  Object.assign(form, row || { name: '', description: '', sort: 0, status: 1 })
  show.value = true
}
const save = async () => {
  if (!form.name.trim()) {
    message.error('分类名称不能为空')
    return
  }
  if (form.sort === null || form.sort === undefined || isNaN(Number(form.sort))) {
    message.error('排序值必须是数字')
    return
  }
  try {
    editingId.value ? await adminApi.updateCategory(editingId.value, form) : await adminApi.createCategory(form)
    message.success('保存成功')
    show.value = false
    load()
  } catch (error) {
    message.error(error.message || '保存失败')
  }
}
const remove = (id) => {
  dialog.warning({
    title: '确认删除分类',
    content: '分类下若存在新闻时，后端将拒绝删除。',
    positiveText: '删除',
    negativeText: '取消',
    onPositiveClick: async () => {
      try {
        await adminApi.deleteCategory(id)
        message.success('删除成功')
        load()
      } catch (error) {
        message.error(error.message || '删除失败')
      }
    }
  })
}

const toggleStatus = (row) => {
  const action = row.status ? '禁用' : '启用'
  dialog.warning({
    title: `确认${action}分类`,
    content: `您确定要${action}分类“${row.name}”吗？`,
    positiveText: '确认',
    negativeText: '取消',
    onPositiveClick: async () => {
      try {
        await adminApi.categoryStatus(row.id, row.status ? 0 : 1)
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
  { title: '名称', key: 'name', width: 150, ellipsis: { tooltip: true } },
  { title: '描述', key: 'description', ellipsis: { tooltip: true } },
  { title: '排序值', key: 'sort', width: 90 },
  { 
    title: '状态', 
    key: 'status', 
    width: 100,
    render: (row) => h(
      NTag, 
      { type: row.status ? 'success' : 'error', bordered: false, style: { fontWeight: '600' } }, 
      { default: () => row.status ? '启用' : '禁用' }
    ) 
  },
  { title: '操作', key: 'actions', width: 240, render: (row) => h(NSpace, { size: 4 }, { default: () => [
    h(NButton, { size: 'small', type: 'primary', quaternary: true, onClick: () => open(row) }, { 
      default: () => '编辑',
      icon: () => h(NIcon, null, { default: () => h(CreateOutline) })
    }),
    h(NButton, { size: 'small', type: row.status ? 'warning' : 'success', secondary: true, onClick: () => toggleStatus(row) }, { 
      default: () => row.status ? '禁用' : '启用',
      icon: () => h(NIcon, null, { default: () => h(row.status ? CloseCircleOutline : CheckmarkCircleOutline) })
    }),
    h(NButton, { size: 'small', type: 'error', quaternary: true, onClick: () => remove(row.id) }, { 
      default: () => '删除',
      icon: () => h(NIcon, null, { default: () => h(TrashOutline) })
    })
  ]}) }
]

onMounted(load)
</script>

<template>
  <div class="toolbar">
    <n-input v-model:value="query.keyword" clearable placeholder="搜索分类名称..." style="max-width: 240px" @keyup.enter="query.page = 1; load()" />
    <n-select v-model:value="query.status" clearable :options="statusOptions" placeholder="选择状态" style="max-width: 150px" @update:value="query.page = 1; load()" />
    <n-button type="primary" round @click="query.page = 1; load()">
      <template #icon><n-icon><SearchOutline /></n-icon></template>
      查询
    </n-button>
    <n-button round @click="query.keyword = ''; query.status = null; query.page = 1; load()">
      <template #icon><n-icon><RefreshOutline /></n-icon></template>
      重置
    </n-button>
  </div>
  
  <n-card title="新闻分类列表" style="border-radius: var(--radius-md); box-shadow: var(--shadow-sm);">
    <template #header-extra>
      <n-button type="primary" round @click="open()">
        <template #icon><n-icon><AddOutline /></n-icon></template>
        新增分类
      </n-button>
    </template>
    
    <n-data-table :columns="columns" :data="rows" :loading="loading" :pagination="false" :bordered="false" size="small" :scroll-x="1000" />
    
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

  <n-modal v-model:show="show" preset="card" title="分类信息" style="width: 520px; border-radius: var(--radius-md);">
    <n-form :model="form" label-placement="left" label-width="80">
      <n-form-item label="名称">
        <n-input v-model:value="form.name" placeholder="请输入分类名称" style="border-radius: var(--radius-sm);" />
      </n-form-item>
      <n-form-item label="描述">
        <n-input v-model:value="form.description" placeholder="请输入分类描述" style="border-radius: var(--radius-sm);" />
      </n-form-item>
      <n-form-item label="排序值">
        <n-input-number v-model:value="form.sort" style="width: 100%; border-radius: var(--radius-sm);" />
      </n-form-item>
      <n-form-item label="状态">
        <n-select v-model:value="form.status" :options="statusOptions" style="border-radius: var(--radius-sm);" />
      </n-form-item>
    </n-form>
    <template #footer>
      <n-space justify="end">
        <n-button round @click="show = false">取消</n-button>
        <n-button type="primary" round @click="save">保存</n-button>
      </n-space>
    </template>
  </n-modal>
</template>

