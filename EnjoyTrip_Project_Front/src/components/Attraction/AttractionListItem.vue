<script setup>
import { defineProps, computed } from 'vue'
import { useAttractionInfoStore } from '@/store/attrationStore'
import Score from '../common/Score.vue'
import Wish from '../common/Wish.vue'
import Wished from '../common/Wished.vue'

// import userImgData from '@/api/userImgData'

// import { useRouter } from 'vue-router'
// const router = useRouter()

const userInfo = computed(() => {
  const memberDto = sessionStorage.getItem('memberDto')
  return memberDto ? JSON.parse(memberDto) : null
})

const infoStore = useAttractionInfoStore()

const props = defineProps({
  attractionItem: {
    type: Object, // 객체(Object) 유형으로 지정
    required: true // 필수 prop으로 지정 (선택적인 경우 필요에 따라 변경)
  }
})

// eslint-disable-next-line vue/no-mutating-props
props.attractionItem.firstImage = props.attractionItem.firstImage || 'src/assets/noImg.png'

infoStore.setItem(props.attractionItem.value)
</script>

<template>
  <div class="p-4 sm:ml-64">
    <RouterLink @click="infoStore.setItem(attractionItem)" :to="{ name: 'detail' }"
      class="flex flex-col items-center bg-white border border-gray-200 rounded-lg shadow md:flex-row md:max-w-xxl hover:bg-gray-100 dark:border-gray-700 dark:bg-gray-800 dark:hover:bg-gray-700"
      style="height: 300px">
      <!-- 이미지 -->
      <img :alt="attractionItem.title"
        class="object-cover w-full rounded-t-lg h-full md:h-auto md:w-48 md:rounded-none md:rounded-s-lg"
        :src="attractionItem.firstImage" style="width: 40%; aspect-ratio: 140 / 140; object-fit: cover; height: 100%" />

      <div class="flex flex-col justify-between p-8 leading-normal w-120" style="width: 60%">
        <div class="flex flex-row justify-end mb-5">
          <!-- 인스타 태그 검색 -->
          <a :href="'https://www.instagram.com/explore/tags/' +
            attractionItem.title.replace(/[^\wㄱ-ㅎ가-힣ㅏ-ㅣ]|_/g, '').replace(/\s+/g, '')
            " target="_blank" class="pt-1.5 max-w-[31px] mr-3" @click.stop>
            <img alt="인스타그램 태그 검색" src="../../assets/pngwing.com.png" style="width: 28px" />
          </a>

          <a :href="'https://www.youtube.com/results?search_query=' + attractionItem.title" target="_blank" @click.stop
            class="mr-1">
            <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="40" height="40" viewBox="0 0 48 48">
              <path fill="#FF3D00"
                d="M43.2,33.9c-0.4,2.1-2.1,3.7-4.2,4c-3.3,0.5-8.8,1.1-15,1.1c-6.1,0-11.6-0.6-15-1.1c-2.1-0.3-3.8-1.9-4.2-4C4.4,31.6,4,28.2,4,24c0-4.2,0.4-7.6,0.8-9.9c0.4-2.1,2.1-3.7,4.2-4C12.3,9.6,17.8,9,24,9c6.2,0,11.6,0.6,15,1.1c2.1,0.3,3.8,1.9,4.2,4c0.4,2.3,0.9,5.7,0.9,9.9C44,28.2,43.6,31.6,43.2,33.9z">
              </path>
              <path fill="#FFF" d="M20 31L20 17 32 24z"></path>
            </svg>
          </a>

          <Wish :contentId="attractionItem.contentId" v-if="!attractionItem.wishlistId && userInfo" />
          <Wished :contentId="attractionItem.contentId" v-if="attractionItem.wishlistId && userInfo" />
        </div>

        <h1 class="mb-2 text-3xl font-bold tracking-tight text-gray-900 dark:text-white">
          {{ attractionItem.title }}
        </h1>

        <!-- https://www.instagram.com/explore/tags/%EC%A0%9C%EC%A3%BC%EB%8F%84/ -->
        <!-- 찜 수 -->
        <div class="flex items-center mt-2 mb-4">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
            class="text-yellow-400">
            <polygon
              points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2">
            </polygon>
          </svg>
          <p class="ml-2">{{ attractionItem.wishCount }} (찜수)</p>
          <p class="ml-2">조회수: {{ attractionItem.readCount }}</p>
        </div>

        <div class="flex items-center mt-2 mb-4">
          <Score :score="attractionItem.reviewCount" />

          <p style="margin-left: 10px">({{ attractionItem.reviewCount }})평점</p>
        </div>

        <!-- 카테고리 -->
        <span>{{ attractionItem.addr1 }} {{ attractionItem.addr2 }}</span>

        <p class="mb-3 font-normal text-gray-700 dark:text-gray-400"></p>
      </div>
    </RouterLink>
  </div>
</template>

<style scoped></style>
