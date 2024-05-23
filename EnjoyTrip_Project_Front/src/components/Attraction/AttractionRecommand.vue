<script setup>
import { ref, onMounted, nextTick, watch } from 'vue'
import { useAttractionStore, useAttractionInfoStore } from '@/store/attrationStore'
import client from '@/api/client'
import { initFlowbite, initCarousels } from 'flowbite'

const attractions = ref([])
const loading = ref(true)
const infoStore = useAttractionInfoStore()
const carouselRef = ref(null)

const store = useAttractionStore()

const loadImage = (src) => {
  return new Promise((resolve, reject) => {
    const img = new Image()
    img.src = src
    img.onload = resolve
    img.onerror = (err) => {
      console.error(`이미지 로드 실패: ${img.src}`, err)
      reject(err)
    }
  })
}

const getCarousel = async () => {
  try {
    loading.value = true
    const res = await client.get('/attractions/recommand')
    const images = res.data.map((attraction) => {
      loadImage(attraction.firstImage)
    })

    await Promise.all(images)
    await nextTick()
    attractions.value = res.data
    store.setItems(res.data)
    loading.value = false
  } catch (err) {
    console.error('Carousel 데이터 로드 실패:', err)
  }
}

watch(carouselRef, (newVal) => {
  if (newVal) {
    initCarousels()
  }
})

onMounted(() => {
  getCarousel()
  initFlowbite()
})
</script>

<template>
  <KeepAlive>
    <div v-if="!loading && attractions.length > 0">
      <div id="animation-carousel" ref="carouselRef" class="relative max-w-screen" data-carousel="slide">
        <div class="relative overflow-hidden rounded-lg h-[65vh] aspect-auto w-[120vh]">
          <div v-for="attraction in attractions" :key="attraction.contentId" class="hidden duration-700 ease-in-out"
            data-carousel-item>
            <RouterLink @click="infoStore.setItem(attraction)" :to="{ name: 'detail' }">
              <img v-if="attraction.firstImage" :src="attraction.firstImage"
                class="absolute block w-full -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2"
                :alt="attraction.title" />
            </RouterLink>
          </div>
        </div>
        <div class="absolute z-30 flex -translate-x-1/2 bottom-5 left-1/2 space-x-3 rtl:space-x-reverse">
          <button v-for="(attraction, index) in attractions" :key="index" type="button" class="w-3 h-3 rounded-full"
            aria-current="index === 0 ? 'true' : 'false'" :aria-label="'Slide ' + (index + 1)"
            :data-carousel-slide-to="index"></button>
        </div>
        <button type="button"
          class="absolute top-0 start-0 z-30 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none"
          data-carousel-prev>
          <span
            class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-white/30 dark:bg-gray-800/30 group-hover:bg-white/50 dark:group-hover:bg-gray-800/60 group-focus:ring-4 group-focus:ring-white dark:group-focus:ring-gray-800/70 group-focus:outline-none">
            <svg class="w-4 h-4 text-white dark:text-gray-800 rtl:rotate-180" aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
              <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M5 1 1 5l4 4" />
            </svg>
            <span class="sr-only">Previous</span>
          </span>
        </button>
        <button type="button"
          class="absolute top-0 end-0 z-30 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none"
          data-carousel-next>
          <span
            class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-white/30 dark:bg-gray-800/30 group-hover:bg-white/50 dark:group-hover:bg-gray-800/60 group-focus:ring-4 group-focus:ring-white dark:group-focus:ring-gray-800/70 group-focus:outline-none">
            <svg class="w-4 h-4 text-white dark:text-gray-800 rtl:rotate-180" aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10">
              <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="m1 9 4-4-4-4" />
            </svg>
            <span class="sr-only">Next</span>
          </span>
        </button>
      </div>
    </div>
    <div v-else>
      <!-- 로딩 중일 때 표시할 내용 -->
      <div role="status">
        <svg aria-hidden="true" class="w-8 h-8 text-gray-200 animate-spin dark:text-gray-600 fill-blue-600"
          viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path
            d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
            fill="currentColor" />
          <path
            d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
            fill="currentFill" />
        </svg>
        <span class="sr-only">Loading...</span>
      </div>
    </div>
  </KeepAlive>
</template>

<style scoped></style>
