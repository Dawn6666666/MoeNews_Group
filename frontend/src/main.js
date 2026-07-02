import { createApp } from 'vue'
import { createPinia } from 'pinia'
import naive from 'naive-ui'
import 'md-editor-v3/lib/style.css'
import App from './App.vue'
import router from './router'
import './style.css'

createApp(App).use(createPinia()).use(router).use(naive).mount('#app')
