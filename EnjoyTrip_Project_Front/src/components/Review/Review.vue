<script setup>
import Score from '../common/Score.vue'
import ReviewPercentage from './ReviewPercentage.vue'
import ReviewList from './ReviewList.vue'
import { ref, watchEffect, computed } from 'vue'
import { storeToRefs } from 'pinia'
import { useAttractionInfoStore } from '@/store/attrationStore'
const attractionInfoStore = useAttractionInfoStore()
const { attractionInfo } = storeToRefs(attractionInfoStore)

const userInfo = computed(() => {
  const memberDto = sessionStorage.getItem('memberDto')
  return memberDto ? JSON.parse(memberDto) : null
})

const reviewScore = ref(0)
watchEffect(() => {
  const ratings = attractionInfo.value.rating
  if (ratings && ratings.length > 0) {
    const totalScore = ratings.reduce((total, count, index) => total + (index + 1) * count, 0)
    const totalCount = ratings.reduce((total, count) => total + count, 0)
    reviewScore.value = totalScore / totalCount
  }
  reviewScore.value = isNaN(reviewScore.value) ? 0 : reviewScore.value
})
</script>

<template>
  <div class="bg-gray-100 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-5xl mx-auto">
      <div class="flex flex-wrap items-center justify-between mb-8 gap-4">
        <h2 class="text-3xl font-semibold flex items-center">Review</h2>
        <RouterLink
          :to="{ name: 'review', state: { reviewScore: reviewScore } }"
          v-show="userInfo"
          v-slot="reviewScore"
          class="inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2"
        >
          리뷰 작성하기
        </RouterLink>
      </div>
      <div class="bg-white p-8 rounded-lg shadow-md">
        <div class="flex flex-col md:flex-row mb-8">
          <div class="md:w-1/3 pr-8">
            <div class="flex items-center mb-4">
              <h3 v-if="reviewScore.toFixed(1) !== 'NaN'" class="text-2xl font-medium mr-2">
                {{ reviewScore.toFixed(1) }}
              </h3>
              <h3 v-else class="text-2xl font-medium mr-2">0</h3>
              <div class="flex">
                <Score :score="reviewScore.toFixed(1)" />
                &nbsp;
                {{ attractionInfo.rating ? attractionInfo.rating.reduce((a, b) => a + b, 0) : 0 }}
                건의 리뷰
              </div>
            </div>
            <div class="space-y-2">
              <ReviewPercentage
                v-if="attractionInfo.rating"
                :reviewScoreCount="attractionInfo.rating"
              />
            </div>
          </div>
          <div class="md:w-2/3">
            <ReviewList />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
