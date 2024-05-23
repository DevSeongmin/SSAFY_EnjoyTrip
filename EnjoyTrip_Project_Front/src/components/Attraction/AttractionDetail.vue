<script setup>
import Wish from '@/components/common/Wish.vue'
import Wished from '../common/Wished.vue'
import { onMounted, computed } from 'vue'
import { useAttractionInfoStore } from '@/store/attrationStore'
import { storeToRefs } from 'pinia'
import getWeagtherInfo from '@/components/getWeatherInfo.vue'
import { useRouter } from 'vue-router'
import KakaoMap from '@/components/Attraction/KakaoMap.vue'
import Review from '@/components/Review/Review.vue'

// import Score from '@/components/common/Score.vue'
// import contentTypeName from '@/api/contentTypeName'
import client from '@/api/client'

const userInfo = computed(() => {
  const memberDto = sessionStorage.getItem('memberDto')
  return memberDto ? JSON.parse(memberDto) : null
})

const router = useRouter()
const attractionInfoStore = useAttractionInfoStore()
const { attractionInfo } = storeToRefs(attractionInfoStore)

// const instagram = 'https://www.instagram.com/explore/tags/' + attractionInfo.value.title

const lat = attractionInfo.value.latitude
const lon = attractionInfo.value.longitude

onMounted(() => {
  attractionInfo.value.readCount++
  client
    .post(`/attractions/addViewCount/${attractionInfo.value.contentId}`)
    .then((response) => {
      console.log(response)
    })
    .catch((error) => {
      console.error(error)
    })

  if (!attractionInfo.value.title) {
    router.push('/')
  }
})
</script>

<template>
  <div class="max-w-7xl mx-auto py-10 flex flex-col mt-9">


    <div class='flex justify-between mt-2'>
      <getWeagtherInfo :lat="lat" :lon="lon" />

      <div class="flex justify-end">
        <RouterLink type="button" :to="{ name: 'search' }"
          class="flex max-w-[80px] whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-gray-300 hover:text-accent-foreground h-10 px-4 py-2">
          뒤로가기</RouterLink>
      </div>

    </div>
    <!-- 관광지 정보 -->

    <div
      class="flex flex-col items-center bg-white border border-gray-200 rounded-lg shadow md:flex-row md:max-w-xxl dark:border-gray-700 dark:bg-gray-800 max-w-screen">
      <!-- 관광지 이미지 -->
      <img
        class="object-cover w-full rounded-t-lg h-full max-w-full max-h-full md:h-auto md:w-auto md:rounded-none md:rounded-s-lg"
        style="width: 50%; object-fit: cover; height: 500px" :src="attractionInfo.firstImage" alt="" />

      <!-- 관광지 제목 및 설명 -->
      <div class="flex flex-col justify-between p-4 leading-normal h-[30rem]" style="width: 50%">
        <div class="flex justify-between">

          <div class='flex-row'>
            <p class="flex items-center">조회수: {{ attractionInfo.readCount }}</p>
            <h5 class="mb-4 mt-5 text-4xl font-bold tracking-tight text-gray-900 dark:text-white">
              {{ attractionInfo.title }}
            </h5>
          </div>
          <div class="flex gap-3">
            <!-- 인스타 태그 검색 -->
            <a :href="'https://www.instagram.com/explore/tags/' +
              attractionInfo.title.replace(/[^\wㄱ-ㅎ가-힣ㅏ-ㅣ]|_/g, '').replace(/\s+/g, '')
              " target="_blank" class="flex max-w-[31px] mr-2 mt-2">
              <img alt="인스타그램 태그 검색" src="../../assets/pngwing.com.png" style="width: 26px; height: 26px" />
            </a>

            <a :href="'https://www.youtube.com/results?search_query=' + attractionInfo.title" target="_blank"
              class="mt-1">
              <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="35" height="35" viewBox="0 0 48 48">
                <path fill="#FF3D00"
                  d="M43.2,33.9c-0.4,2.1-2.1,3.7-4.2,4c-3.3,0.5-8.8,1.1-15,1.1c-6.1,0-11.6-0.6-15-1.1c-2.1-0.3-3.8-1.9-4.2-4C4.4,31.6,4,28.2,4,24c0-4.2,0.4-7.6,0.8-9.9c0.4-2.1,2.1-3.7,4.2-4C12.3,9.6,17.8,9,24,9c6.2,0,11.6,0.6,15,1.1c2.1,0.3,3.8,1.9,4.2,4c0.4,2.3,0.9,5.7,0.9,9.9C44,28.2,43.6,31.6,43.2,33.9z">
                </path>
                <path fill="#FFF" d="M20 31L20 17 32 24z"></path>
              </svg>
            </a>

            <Wish :contentId="attractionInfo.contentId" v-if="!attractionInfo.wishlistId && userInfo" />
            <Wished :contentId="attractionInfo.contentId" v-if="attractionInfo.wishlistId && userInfo" />
          </div>
        </div>


        <p class="scrollBar overflow-auto mb-3 font-normal text-gray-700 dark:text-gray-400">
          {{ attractionInfo.overview }}
        </p>
      </div>
    </div>

    <div class="flex">
      <KakaoMap :lat="attractionInfo.latitude" :lon="attractionInfo.longitude" :sidoCode='attractionInfo.sidoCode'
        :gugunCode='attractionInfo.gugunCode' />
    </div>
    <Review />
  </div>
</template>

<style scoped>
.container {
  max-height: 90vh;
  /* 뷰포트 높이의 90%를 최대 높이로 설정 */
  overflow: auto;
}
</style>
