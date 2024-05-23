<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { initFlowbite } from 'flowbite'
import client from '@/api/client'
import LoginModal from '@/views/modal/LoginModal.vue'
import AttractionSearch from '@/components/Attraction/AttractionSearch.vue'
import UserDropdown from '@/views/dropdown/UserDropdown.vue'

const router = useRouter()

// 세션에서 로그인 정보 가져오기
const loadingState = ref({ isLoading: true })

onMounted(async () => {
  try {
    const res = await client.get('/members/ping')
    if (res.status === 200) {
      if (res.data !== '') {
        sessionStorage.setItem('memberDto', JSON.stringify(res.data))
      }
    } else {
      router.replace({ name: 'home' })
    }
  } catch (error) {
    console.error(error)
    sessionStorage.removeItem('memberDto')
    router.replace({ name: 'home' })
  }
  loadingState.value.isLoading = false // 로딩이 완료되었음을 표시
  initFlowbite()
})
// 로그인 정보 계속 확인용
client.get('/members/ping').then((res) => {
  if (res.status === 200) {
    if (res.data === '' || res.data === null) {
      sessionStorage.removeItem('memberDto')
      client.post('/members/logout')
      router.replace({ name: 'home' })
      return
    }
    sessionStorage.setItem('memberDto', JSON.stringify(res.data))
  } else {
    router.replace({ name: 'home' })
  }
})

// 세션에서 로그인 정보 가져오기
const isLoggedIn = computed(() => {
  return sessionStorage.getItem('memberDto') !== null
})
</script>

<template>
  <div v-if="loadingState.isLoading">
    <!-- 로딩 창 컴포넌트 또는 로딩 창에 대한 HTML을 여기에 추가하세요 -->
  </div>
  <div v-else>
    <nav
      class="bg-white dark:bg-gray-900 fixed w-full z-50 top-0 start-0 border-b border-gray-200 dark:border-gray-600"
    >
      <div class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4">
        <RouterLink :to="{ name: 'home' }" class="flex items-center space-x-3 rtl:space-x-reverse">
          <img src="/src/assets/logotest2.png" class="h-8" alt="Flowbite Logo" />
          <span class="self-center text-2xl font-semibold whitespace-nowrap dark:text-white"
            >여행 지기</span
          >
        </RouterLink>
        <!-- 검색 바 start -->
        <AttractionSearch />
        <!-- 검색 바 end -->
        <div class="flex md:order-2 space-x-3 md:space-x-0 rtl:space-x-reverse">
          <!-- 로그인 모달 start -->
          <div v-if="isLoggedIn">
            <UserDropdown />
          </div>
          <div v-else>
            <LoginModal />
          </div>
          <!-- 로그인 모달 end -->
        </div>
      </div>
    </nav>
  </div>
</template>

<style scoped></style>
