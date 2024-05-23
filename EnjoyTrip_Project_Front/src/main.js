import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { useKakao } from 'vue3-kakao-maps/@utils'
import '@/stylesheet/index.css'
import App from './App.vue'
import router from './router'
import { createPersistedState } from 'pinia-plugin-persistedstate'

useKakao('c9c4977a5d4ddc19f25aa9b22c1e264a', ['services'])

const app = createApp(App)
const pinia = createPinia()
pinia.use(createPersistedState())

app.use(pinia)
app.use(router)
app.mount('#app')
