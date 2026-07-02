<script setup>
import { onMounted, reactive, ref, computed, watch } from 'vue'
import { newsApi } from '../../api'
import { assetUrl } from '../../utils/url'
import { HomeOutline, ChevronDownOutline, ChevronUpOutline } from '@vicons/ionicons5'

const loading = ref(false)
const news = ref([])
const categories = ref([])
const pager = reactive({ page: 1, size: 8, itemCount: 0 })
const query = reactive({ keyword: '', categoryId: null })

const isCollapsed = ref(true)

const displayedCategories = computed(() => {
  if (!isCollapsed.value) {
    return categories.value
  }
  return categories.value.slice(0, 6)
})

const hasMoreCategories = computed(() => {
  return categories.value.length > 6
})

const loadCategories = async () => {
  const data = await newsApi.categories()
  categories.value = data.map((item) => ({ label: item.name, value: item.id }))
}

const loadNews = async () => {
  loading.value = true
  try {
    const data = await newsApi.list({ page: pager.page, size: pager.size, keyword: query.keyword, categoryId: query.categoryId })
    news.value = data.records
    pager.itemCount = data.total
  } finally {
    loading.value = false
  }
}

// 只有在第一页且无任何过滤搜索时才展示 Hero 头条
const showHero = computed(() => {
  return pager.page === 1 && !query.keyword && !query.categoryId && news.value.length > 0
})

const featuredNews = computed(() => {
  return showHero.value ? news.value[0] : null
})

const displayNews = computed(() => {
  return showHero.value ? news.value.slice(1) : news.value
})

let debounceTimer = null
watch(() => query.keyword, () => {
  if (debounceTimer) clearTimeout(debounceTimer)
  debounceTimer = setTimeout(() => {
    pager.page = 1
    loadNews()
  }, 300)
})

onMounted(() => {
  loadCategories()
  loadNews()
})
</script>

<template>
  <section class="page">
    <!-- 联合检索与分类导航一栏式面板 -->
    <div class="toolbar unified-search-bar" style="display: flex; justify-content: space-between; align-items: center; gap: 24px; margin-bottom: 36px; padding: 12px 24px; height: auto;">
        <!-- 左侧：分类选择胶囊（单行横向溢出滚动） -->
        <div class="category-scroll-wrapper" style="flex: 1; display: flex; align-items: center; overflow: hidden;">
          <div class="no-scrollbar-container" style="display: flex; gap: 8px; overflow-x: auto; white-space: nowrap; flex-wrap: nowrap; width: 100%; padding: 4px 0;">
            <n-tag
              :key="'all'"
              round
              :checked="query.categoryId === null"
              checkable
              @update:checked="() => { query.categoryId = null; pager.page = 1; loadNews(); }"
              class="category-pill"
              :style="{
                borderColor: query.categoryId === null ? 'var(--primary-border)' : 'var(--border-color)',
                backgroundColor: query.categoryId === null ? 'var(--primary-light)' : 'transparent',
                color: query.categoryId === null ? 'var(--primary-color)' : 'var(--text-main)',
                padding: '6px 14px',
                fontSize: '13px',
                fontWeight: '600',
                borderRadius: '20px'
              }"
            >
              <template #avatar>
                <n-icon :component="HomeOutline" style="margin-top: 1px;" />
              </template>
              全部
            </n-tag>
            <n-tag
              v-for="cat in displayedCategories"
              :key="cat.value"
              round
              :checked="query.categoryId === cat.value"
              checkable
              @update:checked="() => { query.categoryId = cat.value; pager.page = 1; loadNews(); }"
              class="category-pill"
              :style="{
                borderColor: query.categoryId === cat.value ? 'var(--primary-border)' : 'var(--border-color)',
                backgroundColor: query.categoryId === cat.value ? 'var(--primary-light)' : 'transparent',
                color: query.categoryId === cat.value ? 'var(--primary-color)' : 'var(--text-main)',
                padding: '6px 16px',
                fontSize: '13px',
                fontWeight: '600',
                borderRadius: '20px'
              }"
            >
              {{ cat.label }}
            </n-tag>

            <!-- 展开折叠切换按钮 -->
            <n-tag
              v-if="hasMoreCategories"
              round
              :checked="false"
              checkable
              @click="isCollapsed = !isCollapsed"
              class="category-pill"
              :style="{
                borderColor: 'var(--border-color)',
                backgroundColor: 'transparent',
                color: 'var(--text-muted)',
                padding: '6px 16px',
                fontSize: '13px',
                fontWeight: '700',
                borderRadius: '20px'
              }"
            >
              <template #avatar>
                <n-icon :component="isCollapsed ? ChevronDownOutline : ChevronUpOutline" style="margin-top: 1px;" />
              </template>
              {{ isCollapsed ? '更多分类' : '收起分类' }}
            </n-tag>
          </div>
        </div>

        <!-- 右侧：搜索操作区 -->
        <div class="search-action-group" style="display: flex; gap: 8px; align-items: center; flex-shrink: 0;">
          <n-input v-model:value="query.keyword" clearable placeholder="搜索新闻..." style="width: 200px;" @keyup.enter="pager.page = 1; loadNews()" />
          <n-button type="primary" round style="padding: 0 16px; font-weight: 700;" @click="pager.page = 1; loadNews()">搜索</n-button>
          <n-button round style="padding: 0 16px; font-weight: 600;" @click="query.keyword = ''; query.categoryId = null; pager.page = 1; loadNews()">重置</n-button>
      </div>
    </div>

    <!-- 精美头条焦点区 (Hero Section) -->
    <div v-if="showHero" class="slide-up-fade" style="margin-bottom: 40px;">
      <n-card
        :bordered="false"
        style="overflow: hidden; cursor: pointer;"
        class="news-card-hover"
        @click="$router.push(`/news/${featuredNews.id}`)"
      >
        <div class="hero-container">
          <div class="hero-cover-wrapper">
            <img v-if="featuredNews.coverImage" class="hero-cover-img" :src="assetUrl(featuredNews.coverImage)" alt="头条封面">
            <div v-else class="hero-cover-placeholder"><span>MoeNews</span></div>
            <div class="hero-badge">头条资讯</div>
          </div>
          <div class="hero-content">
            <n-space style="margin-bottom: 12px;">
              <n-tag :bordered="false" type="primary" size="small" style="border-radius: 6px; font-weight: 700;">
                {{ featuredNews.categoryName || '未分类' }}
              </n-tag>
              <span style="color: var(--text-muted); font-size: 13px; font-weight: 500;">发布于：{{ featuredNews.createTime }}</span>
            </n-space>
            <h2 class="hero-title">{{ featuredNews.title }}</h2>
            <p class="hero-summary">{{ featuredNews.summary }}</p>
            <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center; border-top: 1px dashed var(--border-color); padding-top: 16px;">
              <span style="color: var(--text-muted); font-size: 13px; font-weight: 500;">{{ featuredNews.viewCount || 0 }} 次浏览</span>
              <span style="color: var(--primary-color); font-weight: 800; font-size: 15px; display: inline-flex; align-items: center; gap: 4px;" class="arrow-trigger">
                阅读头条
                <span style="transition: transform 0.3s;" class="arrow">→</span>
              </span>
            </div>
          </div>
        </div>
      </n-card>
    </div>

    <!-- 列表栏目标题 -->
    <div v-if="!loading || news.length > 0" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
      <h2 style="font-size: 22px; font-weight: 800; margin: 0; color: var(--text-main); display: flex; align-items: center; gap: 8px;">
        <span style="width: 5px; height: 20px; background: linear-gradient(to bottom, var(--primary-color), var(--secondary-color)); border-radius: 3px; display: inline-block;"></span>
        最新资讯
      </h2>
      <span style="font-size: 13px; color: var(--text-muted); font-weight: 500;">共 {{ pager.itemCount }} 篇新闻</span>
    </div>

    <!-- 骨架屏加载状态 -->
    <div v-if="loading && news.length === 0" class="news-grid">
      <n-card v-for="i in 6" :key="i" style="border-radius: var(--radius-md)">
        <template #cover>
          <n-skeleton height="200px" width="100%" />
        </template>
        <n-space vertical :size="12" style="padding: 16px 0 0;">
          <n-skeleton height="24px" width="70%" />
          <n-skeleton :repeat="2" height="16px" />
          <n-space justify="space-between" align="center" style="margin-top: 8px;">
            <n-skeleton height="24px" width="80px" />
            <n-skeleton height="16px" width="60px" />
          </n-space>
        </n-space>
      </n-card>
    </div>

    <!-- 数据列表 -->
    <div v-else>
      <div v-if="news.length === 0" style="padding: 80px 0; text-align: center;">
        <n-empty description="这里空空如也，换个分类或搜索词试试吧" size="huge" />
      </div>
      
      <div v-else class="news-grid">
        <n-card
          v-for="(item, index) in displayNews"
          :key="item.id"
          :class="['news-card-hover', 'slide-up-fade', { 'news-card-bento-large': index === 0 && pager.page === 1 }]"
          style="cursor: pointer; overflow: hidden;"
          :style="{ animationDelay: `${index * 60}ms` }"
          hoverable
          @click="$router.push(`/news/${item.id}`)"
        >
          <!-- 如果是第一项且第一页，以横向 Bento 布局展示 -->
          <div v-if="index === 0 && pager.page === 1" class="bento-horizontal-container">
            <div class="bento-cover-wrapper">
              <img v-if="item.coverImage" class="bento-cover-img" :src="assetUrl(item.coverImage)" alt="新闻封面">
              <div v-else class="bento-cover-placeholder"><span>MoeNews</span></div>
              <div v-if="item.viewCount > 100" class="bento-badge">热门推荐</div>
              <div v-else class="bento-badge-new">精选</div>
            </div>
            <div class="bento-content">
              <n-space style="margin-bottom: 8px;">
                <n-tag :bordered="false" type="primary" size="small" style="border-radius: 6px; font-weight: 700;">
                  {{ item.categoryName || '未分类' }}
                </n-tag>
                <span style="color: var(--text-muted); font-size: 12px; font-weight: 500;">{{ item.viewCount || 0 }} 次浏览</span>
              </n-space>
              <h3 class="bento-title">{{ item.title }}</h3>
              <p class="bento-summary">{{ item.summary }}</p>
              <div style="margin-top: auto; display: flex; justify-content: space-between; align-items: center; border-top: 1px dashed var(--border-color); padding-top: 12px;">
                <span style="color: var(--text-muted); font-size: 11px; font-weight: 500;">{{ item.createTime }}</span>
                <span style="color: var(--primary-color); font-weight: 700; font-size: 13px; display: inline-flex; align-items: center; gap: 4px;" class="arrow-trigger">
                  阅读详情 <span class="arrow">→</span>
                </span>
              </div>
            </div>
          </div>
          
          <!-- 否则，以常规纵向布局展示 -->
          <div v-else style="display: flex; flex-direction: column; height: 100%;">
            <div style="overflow: hidden; width: 100%; border-radius: var(--radius-md) var(--radius-md) 0 0; position: relative;">
              <img v-if="item.coverImage" class="news-cover" :src="assetUrl(item.coverImage)" alt="新闻封面" style="display: block; border-radius: 0; aspect-ratio: 16/10;">
              <div v-else class="news-cover-placeholder"><span>MoeNews</span></div>
              <div v-if="item.viewCount > 100" class="card-badge-hot">热门</div>
              <div v-else-if="index < 3 && pager.page === 1" class="card-badge-new">最新</div>
            </div>
            
            <div style="padding: 16px 20px; display: flex; flex-direction: column; flex: 1;">
              <h3 style="margin: 0 0 10px; font-size: 16px; font-weight: 700; line-height: 1.4; color: var(--text-main); display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 44px;">
                {{ item.title }}
              </h3>
              <p style="margin: 0 0 16px; color: var(--text-muted); font-size: 13px; line-height: 1.6; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 40px;">
                {{ item.summary }}
              </p>

              <n-space justify="space-between" align="center" style="margin-top: auto; padding-top: 12px; border-top: 1px dashed var(--border-color)">
                <n-tag :bordered="false" type="primary" size="small" style="border-radius: 6px; font-weight: 600; padding: 2px 10px;">
                  {{ item.categoryName || '未分类' }}
                </n-tag>
                <span style="color: var(--text-muted); font-size: 12px; font-weight: 500;">{{ item.viewCount || 0 }} 浏览</span>
              </n-space>

              <div style="margin-top: 12px; display: flex; justify-content: space-between; align-items: center;" class="arrow-trigger">
                <span style="color: var(--text-muted); font-size: 11px; font-weight: 500;">{{ item.createTime }}</span>
                <span style="color: var(--primary-color); font-weight: 600; font-size: 13px; display: inline-flex; align-items: center; gap: 4px;">
                  详情 <span class="arrow">→</span>
                </span>
              </div>
            </div>
          </div>
        </n-card>
      </div>

      <!-- 分页栏 -->
      <n-space justify="center" style="margin-top: 48px">
        <n-pagination
          v-model:page="pager.page"
          :page-size="pager.size"
          :item-count="pager.itemCount"
          show-size-picker
          :page-sizes="[8, 16, 24]"
          @update:page="loadNews"
          @update:page-size="(val) => { pager.size = val; pager.page = 1; loadNews(); }"
        />
      </n-space>
    </div>
    <!-- 回到顶部 -->
    <n-back-top :right="40" :bottom="80" />
  </section>
</template>

<style scoped>
.news-card-hover:hover .arrow {
  transform: translateX(4px);
}

.news-card-hover {
  height: 100%;
}

.hero-container {
  display: flex;
  gap: 32px;
  align-items: stretch;
}

.hero-cover-wrapper {
  flex: 1.4;
  position: relative;
  overflow: hidden;
  border-radius: var(--radius-md);
  aspect-ratio: 16 / 10;
  min-height: 320px;
}

.hero-cover-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: var(--transition);
}

.hero-cover-wrapper:hover .hero-cover-img {
  transform: scale(1.02);
}

.hero-badge {
  position: absolute;
  top: 16px;
  left: 16px;
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%);
  color: #ffffff;
  padding: 4px 14px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 800;
  box-shadow: 0 4px 12px rgba(255, 107, 139, 0.3);
}

.hero-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 8px 0;
  justify-content: space-between;
}

.hero-title {
  font-family: var(--font-title);
  font-size: clamp(22px, 2.2vw, 30px);
  font-weight: 800;
  color: var(--text-main);
  line-height: 1.3;
  margin: 0 0 10px;
}

.hero-summary {
  color: var(--text-muted);
  font-size: clamp(13px, 1.1vw, 15px);
  line-height: 1.7;
  margin: 0 0 16px;
  display: -webkit-box;
  -webkit-line-clamp: 4;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.bento-horizontal-container {
  display: flex;
  gap: 24px;
  height: 100%;
  padding: 20px;
  align-items: stretch;
  min-height: 280px;
}

.bento-cover-wrapper {
  flex: 1.2;
  position: relative;
  overflow: hidden;
  border-radius: var(--radius-md);
  aspect-ratio: 16 / 10;
}

.bento-cover-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: var(--transition);
}

.bento-horizontal-container:hover .bento-cover-img {
  transform: scale(1.02);
}

.bento-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  background: var(--primary-color);
  color: #ffffff;
  padding: 2px 10px;
  border-radius: 12px;
  font-size: 10px;
  font-weight: 800;
  box-shadow: 0 2px 6px rgba(255, 107, 139, 0.2);
}

.bento-badge-new {
  position: absolute;
  top: 10px;
  left: 10px;
  background: var(--secondary-color);
  color: #ffffff;
  padding: 2px 10px;
  border-radius: 12px;
  font-size: 10px;
  font-weight: 800;
  box-shadow: 0 2px 6px rgba(78, 168, 222, 0.2);
}

.bento-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 4px 0;
  justify-content: space-between;
}

.bento-title {
  font-family: var(--font-title);
  font-size: clamp(15px, 1.3vw, 19px);
  font-weight: 800;
  color: var(--text-main);
  line-height: 1.4;
  margin: 0 0 8px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.bento-summary {
  color: var(--text-muted);
  font-size: clamp(12px, 1vw, 13px);
  line-height: 1.6;
  margin: 0 0 12px;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-badge-hot {
  position: absolute;
  top: 12px;
  right: 12px;
  background: var(--primary-color);
  color: #ffffff;
  font-size: 10px;
  font-weight: 800;
  padding: 3px 10px;
  border-radius: 20px;
  box-shadow: 0 2px 6px rgba(255, 107, 139, 0.2);
}

.card-badge-new {
  position: absolute;
  top: 12px;
  right: 12px;
  background: var(--secondary-color);
  color: #ffffff;
  font-size: 10px;
  font-weight: 800;
  padding: 3px 10px;
  border-radius: 20px;
  box-shadow: 0 2px 6px rgba(78, 168, 222, 0.2);
}

.arrow-trigger:hover .arrow {
  transform: translateX(4px);
}

@media (max-width: 768px) {
  .hero-container {
    flex-direction: column;
    gap: 16px;
  }
  
  .hero-cover-wrapper {
    width: 100%;
  }

  .bento-horizontal-container {
    flex-direction: column;
    padding: 0;
  }

  .bento-cover-wrapper {
    width: 100%;
    aspect-ratio: 16 / 9;
    border-radius: var(--radius-md) var(--radius-md) 0 0;
  }

  .bento-content {
    padding: 16px 20px;
  }
}

.no-scrollbar-container::-webkit-scrollbar {
  display: none;
}

.no-scrollbar-container {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

@media (max-width: 900px) {
  .unified-search-bar {
    flex-direction: column !important;
    align-items: stretch !important;
    gap: 16px !important;
    padding: 16px 20px !important;
  }
  .search-action-group {
    width: 100%;
    justify-content: center;
  }
  .search-action-group .n-input {
    width: 100% !important;
    max-width: 100% !important;
  }
}

.hero-cover-placeholder {
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #f5f5f7 0%, #faeef1 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #d1d1d6;
  font-family: var(--font-title);
  font-size: 26px;
  font-weight: 800;
  letter-spacing: 1px;
}

.bento-cover-placeholder {
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #f5f5f7 0%, #faeef1 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #d1d1d6;
  font-family: var(--font-title);
  font-size: 20px;
  font-weight: 800;
  letter-spacing: 1px;
}

.news-cover-placeholder {
  width: 100%;
  aspect-ratio: 16 / 10;
  background: linear-gradient(135deg, #f5f5f7 0%, #faeef1 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #d1d1d6;
  font-family: var(--font-title);
  font-size: 18px;
  font-weight: 800;
  letter-spacing: 1px;
}
</style>
