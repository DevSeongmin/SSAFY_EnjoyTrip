<script setup>
// import { ref } from 'vue';
import Score from '@/components/common/Score.vue'
import userImgData from '@/api/userImgData';


const props = defineProps({
  data: Object
})

let imgPath = ''
if (props.data.fileInfo.length > 0) {
  imgPath =
    'http://192.168.28.55/upload_img/' +
    props.data.fileInfo[0].saveFolder +
    '/' +
    props.data.fileInfo[0].saveFile
}
</script>

<template>
  <div class="space-y-6 p-2 border rounded-xl">
    <div class="flex items-center">
      <!-- 유저 샘플 이미지 -->
      <img class="relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full mr-4"
        :src="userImgData[data.userId] ? userImgData[data.userId] : '/src/sampleImg.jpg'" />
      <div class="flex-grow">
        <p class="font-semibold">{{ data.userId }}</p>
        <div>
          <Score :score="data.rating" />
        </div>
      </div>
      <div class="flex-none">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
          stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
          class="w-6 h-6 text-gray-500">
          <circle cx="12.1" cy="12.1" r="1"></circle>
        </svg>
      </div>
    </div>
    <div class="flex items-center">


      <img v-if="imgPath !== ''" alt="Review Image" class="mr-4 rounded-md" height="100" :src="imgPath"
        style="aspect-ratio: 100/100; object-fit: cover" width="100" />

      <div class="flex-grow">
        <div class="flex justify-between">
          <p class="text-lg">
            {{ data.title }}
          </p>
          <p class="text-sm mt-1">
            {{ data.createdAt }}
          </p>
        </div>
        <p class="text-sm- mt-2">
          {{ data.content }}
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
