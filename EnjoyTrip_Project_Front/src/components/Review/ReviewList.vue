<script setup>
import { ref, onMounted, watch } from 'vue'
import ReviewListItem from './ReviewListItem.vue'
import client from '@/api/client'

import { storeToRefs } from 'pinia'
import { useAttractionInfoStore } from '@/store/attrationStore'
const attractionInfoStore = useAttractionInfoStore()
const { attractionInfo } = storeToRefs(attractionInfoStore)

const datas = ref([])

const filtering = ref('최신순')

const getReviewList = async () => {
  await client
    .get('/review/' + attractionInfo.value.contentId)
    .then((response) => {
      datas.value = response.data
    })
    .catch(() => {
      alert('에러가 발생했습니다.')
    })
}

const ratings = ref([0, 0, 0, 0, 0])
onMounted(async () => {
  await getReviewList()
  for (let data of datas.value) {
    ratings.value[data.rating - 1] += 1
  }

  attractionInfo.value.rating = ratings
})

watch(
  () => filtering.value,
  async (newValue) => {
    if (newValue === '최신순') {
      datas.value.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
    } else if (newValue === '오래된순') {
      datas.value.sort((a, b) => new Date(a.createdAt) - new Date(b.createdAt))
    } else if (newValue === '리뷰 높은 순') {
      datas.value.sort((a, b) => b.rating - a.rating)
    } else if (newValue === '리뷰 낮은 순') {
      datas.value.sort((a, b) => a.rating - b.rating)
    }
  }
)
</script>

<template>
  <div class="flex flex-col md:flex-row items-center mb-4 gap-4">
    <div>
      <div class="flex space-x-2">
        <button @click.prevent="filtering = '최신순'" :class="{ 'border-black bg-mycolor': filtering === '최신순' }"
          class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-gray-200 h-10 px-4 py-2 border-2 border-mycolor">
          최신순
        </button>
        <button @click.prevent="filtering = '오래된순'" :class="{ 'border-black bg-mycolor': filtering === '오래된순' }"
          class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-gray-200 h-10 px-4 py-2 border-2 border-mycolor">
          오래된 순
        </button>
        <button @click.prevent="filtering = '리뷰 높은 순'" :class="{ 'border-black bg-mycolor': filtering === '리뷰 높은 순' }"
          class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-gray-200 h-10 px-4 py-2 border-2 border-mycolor">
          리뷰 높은 순
        </button>
        <button @click.prevent="filtering = '리뷰 낮은 순'" :class="{ 'border-black bg-mycolor': filtering === '리뷰 낮은 순' }"
          class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-gray-200 h-10 px-4 py-2 border-2 border-mycolor">
          리뷰 낮은 순
        </button>
      </div>
    </div>
  </div>

  <ReviewListItem v-for="(data, index) in datas" :key="index" :data="data" />
</template>

<style scoped></style>
