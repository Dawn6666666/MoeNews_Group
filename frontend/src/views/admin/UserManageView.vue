<script setup>
import { h, onMounted, reactive, ref } from 'vue'
import { NButton, NSpace, NTag, NIcon, useDialog, useMessage } from 'naive-ui'
import { 
  SearchOutline, 
  RefreshOutline, 
  AddOutline, 
  CreateOutline, 
  KeyOutline, 
  TrashOutline, 
  CheckmarkCircleOutline, 
  CloseCircleOutline 
} from '@vicons/ionicons5'
import { adminApi } from '../../api'
import { roleOptions, statusOptions } from '../../utils/options'

const message = useMessage()
const dialog = useDialog()
const rows = ref([])
const show = ref(false)
const resetShow = ref(false)
const editingId = ref(null)
const resetId = ref(null)
const newPassword = ref('123456')
const loading = ref(false)
const query = reactive({ page: 1, size: 10, keyword: '', role: null, status: null, itemCount: 0 })
const form = reactive({ username: '', password: '123456', nickname: '', email: '', phone: '', role: 'USER', status: 1 })

const load = async () => {
  loading.value = true
  try {
    const data = await adminApi.users(query)
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
  Object.assign(form, row || { username: '', password: '123456', nickname: '', email: '', phone: '', role: 'USER', status: 1 })
  show.value = true
}
const save = async () => {
  if (!form.username.trim()) {
    message.error('用户名不能为空')
    return
  }
  if (!editingId.value && !form.password.trim()) {
    message.error('密码不能为空')
    return
  }
  if (!form.nickname.trim()) {
    message.error('昵称不能为空')
    return
  }
  if (form.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
    message.error('邮箱格式不正确')
    return
  }
  if (form.phone && !/^1[3-9]\d{9}$/.test(form.phone)) {
    message.error('手机号格式不正确')
    return
  }

  try {
    editingId.value ? await adminApi.updateUser(editingId.value, form) : await adminApi.createUser(form)
    message.success('保存成功')
    show.value = false
    load()
  } catch (error) {
    message.error(error.message || '保存失败')
  }
}
const remove = (id) => dialog.warning({
  title: '确认删除用户',
  content: '删除采用逻辑删除，用户密码不会返回前端。',
  positiveText: '删除',
  negativeText: '取消',
  onPositiveClick: async () => {
    try {
      await adminApi.deleteUser(id)
      message.success('删除成功')
      load()
    } catch (error) {
      message.error(error.message || '删除失败')
    }
  }
})
const reset = async () => {
  if (!newPassword.value.trim()) {
    message.error('密码不能为空')
    return
  }
  try {
    await adminApi.resetPassword(resetId.value, newPassword.value)
    message.success('密码已重置')
    resetShow.value = false
  } catch (error) {
    message.error(error.message || '重置密码失败')
  }
}

const toggleStatus = (row) => {
  const action = row.status ? '禁用' : '启用'
  dialog.warning({
    title: `确认${action}用户`,
    content: `您确定要${action}用户“${row.username}”吗？`,
    positiveText: '确认',
    negativeText: '取消',
    onPositiveClick: async () => {
      try {
        await adminApi.userStatus(row.id, row.status ? 0 : 1)
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
  { title: '用户名', key: 'username', width: 120 },
  { title: '昵称', key: 'nickname', width: 120 },
  { 
    title: '角色', 
    key: 'role', 
    width: 100,
    render: (row) => h(
      NTag, 
      { type: row.role === 'ADMIN' ? 'error' : 'info', bordered: false, style: { fontWeight: '600' } }, 
      { default: () => row.role === 'ADMIN' ? '管理员' : '普通用户' }
    ) 
  },
  { 
    title: '状态', 
    key: 'status', 
    width: 90,
    render: (row) => h(
      NTag, 
      { type: row.status ? 'success' : 'error', bordered: false, style: { fontWeight: '600' } }, 
      { default: () => row.status ? '启用' : '禁用' }
    ) 
  },
  { title: '操作', key: 'actions', width: 290, render: (row) => h(NSpace, { size: 4 }, { default: () => [
    h(NButton, { size: 'small', type: 'primary', quaternary: true, onClick: () => open(row) }, { 
      default: () => '编辑',
      icon: () => h(NIcon, null, { default: () => h(CreateOutline) })
    }),
    h(NButton, { size: 'small', type: 'info', quaternary: true, onClick: () => { resetId.value = row.id; resetShow.value = true } }, { 
      default: () => '重置',
      icon: () => h(NIcon, null, { default: () => h(KeyOutline) })
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
    <n-input v-model:value="query.keyword" clearable placeholder="搜索用户名/昵称..." style="max-width: 240px" @keyup.enter="query.page = 1; load()" />
    <n-select v-model:value="query.role" clearable :options="roleOptions" placeholder="选择角色" style="max-width: 150px" @update:value="query.page = 1; load()" />
    <n-select v-model:value="query.status" clearable :options="statusOptions" placeholder="选择状态" style="max-width: 150px" @update:value="query.page = 1; load()" />
    <n-button type="primary" round @click="query.page = 1; load()">
      <template #icon><n-icon><SearchOutline /></n-icon></template>
      查询
    </n-button>
    <n-button round @click="query.keyword = ''; query.role = null; query.status = null; query.page = 1; load()">
      <template #icon><n-icon><RefreshOutline /></n-icon></template>
      重置
    </n-button>
  </div>
  
  <n-card title="用户列表" style="border-radius: var(--radius-md); box-shadow: var(--shadow-sm);">
    <template #header-extra>
      <n-button type="primary" round @click="open()">
        <template #icon><n-icon><AddOutline /></n-icon></template>
        新增用户
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

  <n-modal v-model:show="show" preset="card" title="用户信息" style="width: 560px; border-radius: var(--radius-md);">
    <n-form :model="form" label-placement="left" label-width="90">
      <n-form-item label="用户名">
        <n-input v-model:value="form.username" :disabled="!!editingId" placeholder="请输入用户名" style="border-radius: var(--radius-sm);" />
      </n-form-item>
      <n-form-item v-if="!editingId" label="密码">
        <n-input v-model:value="form.password" type="password" placeholder="请输入初始密码" style="border-radius: var(--radius-sm);" />
      </n-form-item>
      <n-form-item label="昵称">
        <n-input v-model:value="form.nickname" placeholder="请输入昵称" style="border-radius: var(--radius-sm);" />
      </n-form-item>
      <n-form-item label="邮箱">
        <n-input v-model:value="form.email" placeholder="请输入邮箱" style="border-radius: var(--radius-sm);" />
      </n-form-item>
      <n-form-item label="手机号">
        <n-input v-model:value="form.phone" placeholder="请输入手机号" style="border-radius: var(--radius-sm);" />
      </n-form-item>
      <n-form-item label="角色">
        <n-select v-model:value="form.role" :options="roleOptions" style="border-radius: var(--radius-sm);" />
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

  <n-modal v-model:show="resetShow" preset="dialog" title="重置密码" positive-text="确认" negative-text="取消" @positive-click="reset">
    <div style="padding: 8px 0 16px;">
      <p style="margin: 0 0 8px; color: var(--text-muted);">请输入该用户的新密码：</p>
      <n-input v-model:value="newPassword" type="password" placeholder="请输入新密码" style="border-radius: var(--radius-sm);" />
    </div>
  </n-modal>
</template>

