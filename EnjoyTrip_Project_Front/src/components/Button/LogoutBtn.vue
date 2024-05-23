<script setup>
import Swal from 'sweetalert2'
import client from '@/api/client'
import { useRouter } from 'vue-router'

const router = useRouter()

const chkLogout = () => {
  !Swal.fire({
    icon: 'warning',
    title: '진짜로 로그아웃 하실껀가요?',
    showCancelButton: 'true',
    cancelButtonText: '취소',
    cancelButtonColor: '#d20',
    confirmButtonColor: '#3085d6',
    confirmButtonText: '확인'
  }).then((result) => {
    if (result.isConfirmed) {
      logout()
    }
  })
}

// 로그아웃
const logout = async () => {
  try {
    await client.post('/members/logout')
    sessionStorage.removeItem('memberDto')
    Swal.fire({
      title: '로그아웃 성공',
      icon: 'success',
      confirmButtonColor: '#3085d6',
      confirmButtonText: '확인'
    }).then(() => {
      router.go(0)
    })
  } catch (error) {
    console.error('로그아웃 에러: ', error)
  }
}
</script>

<template>
  <div class="py-2">
    <a
      @click="chkLogout"
      type="button"
      class="text-sm block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
    >
      <svg
        class="w-6 h-6 text-gray-800 dark:text-white"
        aria-hidden="true"
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 16 16"
      >
        <path
          stroke="currentColor"
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M4 8h11m0 0-4-4m4 4-4 4m-5 3H3a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h3"
        />
      </svg>
    </a>
  </div>
</template>

<style scoped></style>
