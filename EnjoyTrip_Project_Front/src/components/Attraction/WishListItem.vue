<script setup>
import { defineProps, defineEmits } from 'vue'

import client from '@/api/client';
import Swal from 'sweetalert2'

import { useAttractionStore } from '@/store/attrationStore'
import { storeToRefs } from 'pinia'

const store = useAttractionStore()

const { attractionItems } = storeToRefs(store)


const props = defineProps({
  wish: Object
})

const emit = defineEmits(['delete'])


const noImg = '/src/assets/noImg.png'

const deleteWish = async (e) => {
  e.preventDefault()
  console.log('찜삭제')
  try {
    await client.delete('/attractions/wish', {
      data: { contentId: props.wish.content_id }
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

    emit('delete', props.wish)
  } catch {
    alert('에러가 발생했습니다.')
  }
}



</script>

<template>
  <div class="p-1 sm:ml-64">
    <div
      class="flex flex-col items-center bg-white border border-gray-200 rounded-lg shadow md:flex-row md:max-w-xl hover:bg-gray-100 dark:border-gray-700 dark:bg-gray-800 dark:hover:bg-gray-700"
      style="height: 200px">
      <!-- 이미지 -->
      <img :alt="wish.title"
        class="object-cover w-full rounded-t-lg h-full md:h-auto md:w-48 md:rounded-none md:rounded-s-lg"
        :src="wish.first_image || noImg" style="width: 40%; aspect-ratio: 140 / 140; object-fit: cover; height: 100%" />
      <div class="flex flex-col justify-between p-8 leading-normal w-120" style="width: 60%">

        <div class='inline-block' style="display: flex; justify-content: space-between;">
          <h1 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
            {{ wish.title }}
          </h1>

          <svg @click='deleteWish' class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="red" viewBox="0 0 24 24">
            <path fill-rule="evenodd"
              d="M2 12C2 6.477 6.477 2 12 2s10 4.477 10 10-4.477 10-10 10S2 17.523 2 12Zm7.707-3.707a1 1 0 0 0-1.414 1.414L10.586 12l-2.293 2.293a1 1 0 1 0 1.414 1.414L12 13.414l2.293 2.293a1 1 0 0 0 1.414-1.414L13.414 12l2.293-2.293a1 1 0 0 0-1.414-1.414L12 10.586 9.707 8.293Z"
              clip-rule="evenodd" />
          </svg>
        </div>

        <!-- 찜 수 -->
        <div class="flex items-center mt-2 mb-4"></div>

        <!-- 카테고리 -->
        <span>주소 : {{ wish.addr1 }} {{ wish.addr2 }}</span>
        <span v-if="wish.zip">우편 번호 : {{ wish.zip }}</span>
        <span v-if="wish.tel">전화 번호 : {{ wish.tel }}</span>
        <span v-if="wish.homepage">홈페이지 : {{ wish.homepage }}</span>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
