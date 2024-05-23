<script setup>
import { useRouter } from 'vue-router'
import { ref, computed } from 'vue'
import userImgData from '@/api/userImgData';

const router = useRouter()

const props = defineProps({
  board: Object
})

const imgPath = ref('')
if (props.board && props.board.fileInfo && props.board.fileInfo.length > 0) {
  imgPath.value = 'http://192.168.28.55/upload_img'
  // imgPath.value = 'http://localhost/upload_img'
  imgPath.value += '/' + props.board.fileInfo[0].saveFolder + '/' + props.board.fileInfo[0].saveFile
}
const boardDetail = () => {
  router.push({
    name: 'boardDetailView',
    params: { boardId: props.board.postId }
  })
}

const isImage = computed(() => {
  const extension = imgPath.value.split('.').pop().toLowerCase()
  return extension === 'jpg' || extension === 'jpeg' || extension === 'png' || extension === 'gif'
})


const userImg = computed(() => {
  return props.board.userId
})


</script>

<template>
  <div
    class="dark:bg-gray-950 group relative overflow-hidden rounded-lg shadow-lg hover:shadow-xl transition-transform duration-300 ease-in-out hover:-translate-y-2">
    <a @click="boardDetail" class="absolute inset-0 z-10">
      <span class="sr-only">View</span>
    </a>

    <img v-if="isImage" :src="imgPath" width="300" height="300" class="object-cover w-full h-60"
      style="aspect-ratio: 300 / 300; object-fit: cover" />

    <video v-if="!isImage" :src="imgPath" width="300" height="300" class="object-cover w-full h-60"
      style="aspect-ratio: 300 / 300; object-fit: cover"></video>

    <div class="bg-white p-4 dark:bg-gray-950">

      <div class='flex'>
        <span class="relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full mr-3">
          <img class="aspect-square h-full w-full" alt="@shadcn"
            :src="userImgData[userImg] ? userImgData[userImg] : '/src/assets/sample.png'" />
        </span>

        <h3 class="font-semibold text-lg md:text-xl group-hover:underline dark:text-white">
          {{ props.board.title }}
        </h3>
      </div>
      <div class="flex justify-between">
        <p class="text-gray-500 dark:text-gray-400 mt-2">
          {{ props.board.createdAt.split(' ')[0] }}
        </p>



        <p class="text-gray-500 dark:text-gray-400 mt-2">작성자: {{ props.board.userId }}</p>


      </div>
      <div class="flex items-center justify-between mt-4">
        <div class="flex items-center space-x-2">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
            class="w-4 h-4 text-gray-500 dark:text-gray-400">
            <path
              d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z">
            </path>
          </svg>
          <span class="text-gray-500 dark:text-gray-400 text-sm">{{ Math.floor(Math.random() * 96) + 5 }} likes</span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
