export const statusOptions = [
  { label: '启用', value: 1 },
  { label: '禁用', value: 0 }
]

export const roleOptions = [
  { label: '管理员', value: 'ADMIN' },
  { label: '普通用户', value: 'USER' }
]

export const newsStatusOptions = [
  { label: '草稿', value: 0 },
  { label: '已发布', value: 1 },
  { label: '已下架', value: 2 }
]

export const commentStatusOptions = [
  { label: '隐藏', value: 0 },
  { label: '显示', value: 1 }
]

export const statusText = (value, options) => options.find((item) => item.value === value)?.label || '-'
