<script setup>
import { ref } from 'vue'
import Score from '../common/Score.vue'

import { storeToRefs } from 'pinia'

import { useAttractionInfoStore } from '@/store/attrationStore'

defineProps({
  reviewScore: Number
})

const attractionInfoStore = useAttractionInfoStore()

const { attractionInfo } = storeToRefs(attractionInfoStore)
</script>

<template>
  <section class="w-2/5 pr-8 space-y-4 ml-40">
    <h1 class="text-3xl font-bold mb-4">방문하신 시설은 만족스러우셨나요?</h1>

    <div class="flex items-center space-x-6">
      <img
        alt="Place"
        class="border rounded-lg"
        height="300"
        :src="attractionInfo.firstImage"
        width="300"
        style="aspect-ratio: 300 / 300; object-fit: cover"
      />
      <div>
        <!-- 장소이름  -->
        <h2 class="text-2xl font-bold">{{ attractionInfo.title }}</h2>
        <!-- 장소 주소  -->
        <p v-if="attractionInfo.addr1" class="text-sm text-gray-500">{{ attractionInfo.addr1 }}</p>
        <p v-if="attractionInfo.addr2" class="text-sm text-gray-500">{{ attractionInfo.addr2 }}</p>
        <p v-if="attractionInfo.zipcode" class="text-sm text-gray-500">
          우편 번호: {{ attractionInfo.zipcode }}
        </p>
        <p v-if="attractionInfo.tel" class="text-sm text-gray-500">
          전화 번호: {{ attractionInfo.tel }}
        </p>
        <div class="mt-4 flex items-center space-x-1">
          <Score :score="reviewScore" />
          <span class="text-sm text-gray-500">({{ reviewScore }})</span>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped></style>
