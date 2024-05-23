<script setup>
import LogoutBtn from '@/components/Button/LogoutBtn.vue'
import MyInfoModal from '@/views/modal/MyInfoModal.vue'
import MemberModal from '@/views/modal/MemberModal.vue'
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import userImgData from '@/api/userImgData'

const router = useRouter()

const goToBoard = () => {
  router.push({ name: 'board' })
}

const goTowishList = () => {
  router.push({ name: 'wishList' })
}

// 세션에서 회원 정보 가져오기
const userInfo = computed(() => {
  const memberDto = sessionStorage.getItem('memberDto')
  return memberDto ? JSON.parse(memberDto) : null
})
</script>

<template>
  <div class="flex">
    <p class="flex items-center mr-5">{{ userInfo.userName }}님 안녕하세요 😀</p>
    <span class="relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full mr-3">
      <img class="aspect-square h-full w-full" alt="@shadcn" :src="userImgData[userInfo.userId] ? userImgData[userInfo.userId] : '/src/assets/sample.png'
        " />
    </span>

    <button id="dropdownInformationButton" data-dropdown-toggle="dropdownInformation"
      class="text-white focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
      type="button">
      <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
        fill="currentColor" viewBox="0 0 17 14">
        <path
          d="M16 2H1a1 1 0 0 1 0-2h15a1 1 0 1 1 0 2Zm0 6H1a1 1 0 0 1 0-2h15a1 1 0 1 1 0 2Zm0 6H1a1 1 0 0 1 0-2h15a1 1 0 0 1 0 2Z" />
      </svg>
    </button>
  </div>
  <!-- Dropdown menu -->
  <div id="dropdownInformation"
    class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44 dark:bg-gray-700 dark:divide-gray-600">
    <ul class="py-2 text-sm text-gray-700 dark:text-gray-200" aria-labelledby="dropdownInformationButton">
      <li>
        <a @click="goToBoard" href="#"
          class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white">게시판</a>
      </li>
      <li>
        <a @click="goTowishList" href="#"
          class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white">찜 목록</a>
      </li>
      <li v-if="userInfo !== null && userInfo.grade === 'admin'">
        <MemberModal />
      </li>
      <li>
        <MyInfoModal />
      </li>
    </ul>
    <LogoutBtn />
  </div>
</template>

<style scoped></style>
