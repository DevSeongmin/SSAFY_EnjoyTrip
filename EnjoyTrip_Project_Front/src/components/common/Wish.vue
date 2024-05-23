<script setup>
import client from '@/api/client'
import Swal from 'sweetalert2'

import { useAttractionStore } from '@/store/attrationStore'
import { storeToRefs } from 'pinia'

const store = useAttractionStore()

const Toast = Swal.mixin({
  toast: true,
  position: 'top-end',
  showConfirmButton: false,
  timer: 3000,
  timerProgressBar: true,
  didOpen: (toast) => {
    toast.addEventListener('mouseenter', Swal.stopTimer)
    toast.addEventListener('mouseleave', Swal.resumeTimer)
  }
})

const { attractionItems } = storeToRefs(store)

const props = defineProps({
  contentId: Number
})

const addWish = async (e) => {
  e.preventDefault()
  console.log('찜하기')
  try {
    await client.post('/attractions/wish', {
      contentId: props.contentId
    })

    for (let i = 0; i < attractionItems.value.length; i++) {
      if (attractionItems.value[i].contentId === props.contentId) {
        attractionItems.value[i].wishlistId = true
      }
    }

    Swal.fire({
      icon: 'success',
      title: '찜 목록에 추가되었습니다.',
      showConfirmButton: true,
      timer: 2000
    })
  } catch (error) {
    Toast.fire({
      icon: 'error',
      title: error.response.data
    })
  }
}
</script>

<template>
  <button class="flex p-2 rounded-full transition-colors z-30">
    <svg
      @click="addWish"
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      color="red"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      class="w-7 h-7"
    >
      <path
        d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"
      ></path>
    </svg>
  </button>
</template>

<style scoped></style>
