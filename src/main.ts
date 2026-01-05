import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import { registerSW } from 'virtual:pwa-register'

registerSW({
  onNeedRefresh() {},
  onOfflineReady() {}
})

const app = createApp(App)

app.use(createPinia())

app.mount('#app')
