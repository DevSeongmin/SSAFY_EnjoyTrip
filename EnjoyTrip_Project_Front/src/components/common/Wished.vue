<script setup>
import client from '@/api/client'
import Swal from 'sweetalert2'

import { useAttractionStore } from '@/store/attrationStore'
import { storeToRefs } from 'pinia'

const store = useAttractionStore()

const { attractionItems } = storeToRefs(store)

const props = defineProps({

  contentId: Number
})

const deleteWish = async (e) => {
  e.preventDefault()
  console.log('찜삭제')
  try {
    await client.delete('/attractions/wish', {
      data: { contentId: props.contentId }
    })

    for (let i = 0; i < attractionItems.value.length; i++) {
      if (attractionItems.value[i].contentId === props.contentId) {
        attractionItems.value[i].wishlistId = null
      }
    }

    Swal.fire({
      icon: 'success',
      title: '찜 목록에서 삭제되었습니다.',
      showConfirmButton: true,
      timer: 2000
    })
  } catch {
    alert('에러가 발생했습니다.')
  }
}
</script>

<template>
  <button class="flex p-2 rounded-full transition-colors z-30">
    <svg @click="deleteWish" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="red"
      color="red" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-7 h-7">
      <path
        d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z">
      </path>
    </svg>
  </button>
</template>

<style scoped></style>
