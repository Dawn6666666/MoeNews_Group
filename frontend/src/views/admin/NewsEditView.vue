<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useMessage } from 'naive-ui'
import { useRoute, useRouter } from 'vue-router'
import { MdEditor } from 'md-editor-v3'
import { SaveOutline, ArrowBackOutline, CloudUploadOutline, CreateOutline } from '@vicons/ionicons5'
import { adminApi } from '../../api'
import { useAuthStore } from '../../stores/auth'
import { newsStatusOptions } from '../../utils/options'
import { assetUrl } from '../../utils/url'

const route = useRoute()
const router = useRouter()
const message = useMessage()
const auth = useAuthStore()
const id = computed(() => route.params.id)
const categories = ref([])
const form = reactive({
  title: '',
  summary: '',
  content: '',
  coverImage: '',
  categoryId: null,
  status: 0
})

const loadCategories = async () => {
  const data = await adminApi.categories({ page: 1, size: 100, status: 1 })
  categories.value = data.records.map((item) => ({ label: item.name, value: item.id }))
}
const loadDetail = async () => {
  if (!id.value) return
  Object.assign(form, await adminApi.adminNewsDetail(id.value))
}
const save = async () => {
  if (!form.title.trim()) {
    message.error('新闻标题不能为空')
    return
  }
  if (!form.categoryId) {
    message.error('请选择新闻分类')
    return
  }
  if (!form.summary || !form.summary.trim()) {
    message.error('新闻摘要不能为空')
    return
  }
  if (!form.content || !form.content.trim()) {
    message.error('新闻正文内容不能为空')
    return
  }
  try {
    id.value ? await adminApi.updateNews(id.value, form) : await adminApi.createNews(form)
    message.success('保存成功')
    router.push('/admin/news')
  } catch (error) {
    message.error(error.message || '操作失败')
  }
}

// 上传组件需要自定义请求，以便携带 JWT 并读取后端统一返回结构。
const upload = ({ file, onFinish, onError }) => {
  const data = new FormData()
  data.append('file', file.file)
  const baseUrl = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/api'
  fetch(`${baseUrl}/admin/upload/image`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${auth.token}` },
    body: data
  }).then((res) => res.json()).then((res) => {
    if (res.code !== 200) throw new Error(res.message)
    form.coverImage = res.data.url
    onFinish()
  }).catch((error) => {
    message.error(error.message || '图片上传失败')
    onError()
  })
}

onMounted(() => { loadCategories(); loadDetail() })
</script>

<template>
  <n-card :title="id ? '编辑新闻' : '发布新闻'" style="border-radius: var(--radius-md); box-shadow: var(--shadow-sm);">
    <n-form :model="form" label-placement="top">
      <n-grid :cols="2" :x-gap="20" responsive="screen">
        <n-form-item-gi label="新闻标题">
          <n-input v-model:value="form.title" placeholder="请输入引人入胜的标题..." style="border-radius: var(--radius-sm);" />
        </n-form-item-gi>
        <n-form-item-gi label="新闻分类">
          <n-select v-model:value="form.categoryId" :options="categories" placeholder="请选择新闻分类" style="border-radius: var(--radius-sm);" />
        </n-form-item-gi>
        <n-form-item-gi label="发布状态">
          <n-select v-model:value="form.status" :options="newsStatusOptions" placeholder="请选择发布状态" style="border-radius: var(--radius-sm);" />
        </n-form-item-gi>
        <n-form-item-gi label="新闻封面图">
          <n-upload :custom-request="upload" :max="1" accept=".jpg,.jpeg,.png" :show-file-list="false">
            <div class="upload-trigger-card">
              <div v-if="!form.coverImage" class="upload-empty-box">
                <n-icon size="28" style="color: var(--text-muted); margin-bottom: 6px;"><CloudUploadOutline /></n-icon>
                <span style="font-size: 13px; color: var(--text-muted); font-weight: 500;">点击上传封面图片</span>
              </div>
              <div v-else class="upload-preview-box">
                <img :src="assetUrl(form.coverImage)" alt="封面预览">
                <div class="upload-preview-overlay">
                  <n-icon size="20" style="color: #ffffff; margin-bottom: 4px;"><CreateOutline /></n-icon>
                  <span>更换封面</span>
                </div>
              </div>
            </div>
          </n-upload>
        </n-form-item-gi>
      </n-grid>
      
      <n-form-item label="新闻摘要">
        <n-input v-model:value="form.summary" type="textarea" :rows="3" placeholder="请输入简短的内容摘要，用于列表页展示..." style="border-radius: var(--radius-sm);" />
      </n-form-item>
      
      <n-form-item label="新闻正文内容">
        <MdEditor v-model="form.content" style="height: 520px; border-radius: var(--radius-sm); overflow: hidden; border: 1px solid var(--border-color);" />
      </n-form-item>
      
      <n-space justify="end" :size="16" style="margin-top: 16px;">
        <n-button round @click="router.push('/admin/news')">
          <template #icon>
            <n-icon><ArrowBackOutline /></n-icon>
          </template>
          返回列表
        </n-button>
        <n-button type="primary" round @click="save">
          <template #icon>
            <n-icon><SaveOutline /></n-icon>
          </template>
          保存发布
        </n-button>
      </n-space>
    </n-form>
  </n-card>
</template>

<style scoped>
.upload-trigger-card {
  width: 200px;
  height: 120px;
  border: 1px dashed rgba(0, 0, 0, 0.12);
  border-radius: var(--radius-sm);
  background: #fbfbfd;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  cursor: pointer;
  transition: var(--transition);
  position: relative;
}

.upload-trigger-card:hover {
  border-color: var(--primary-color);
  background: var(--primary-light);
}

.upload-empty-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.upload-preview-box {
  width: 100%;
  height: 100%;
  position: relative;
}

.upload-preview-box img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.upload-preview-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.4);
  color: #ffffff;
  font-size: 12px;
  font-weight: 500;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity var(--transition);
}

.upload-trigger-card:hover .upload-preview-overlay {
  opacity: 1;
}
</style>

