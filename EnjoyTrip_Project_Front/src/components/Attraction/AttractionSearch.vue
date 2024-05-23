<script setup>
import { ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAttractionStore, useAttractionSearchStore } from '@/store/attrationStore'
import client from '@/api/client'
import Swal from 'sweetalert2'

const Toast = Swal.mixin({
  toast: true,
  position: 'top-end',
  showConfirmButton: false,
  timer: 3000,
  timerProgressBar: true,
  didOpen: (toast) => {
    toast.addEventListener('mouseenter', Swal.stopTimer)
    toast.addEventListener('mouseleave', Swal.resumeTimer)
  }
})

// 관광지 검색
const router = useRouter()
const store = useAttractionStore()
const searchStore = useAttractionSearchStore()

const sido = ref({
  sidoCode: 0,
  sidoName: '시/도 선택'
})

watch(sido, () => {
  document.getElementById('sido-dropdown-button').click()
})

const content = ref({
  contentId: 0,
  contentName: '관광지 유형'
})

watch(content, () => {
  document.getElementById('content-dropdown-button').click()
})

const title = ref('')
const attractionItems = ref([])

const attractionSearch = async (e) => {
  e.preventDefault()
  try {
    const res = await client.get('/attractions/search', {
      params: {
        sidoCode: sido.value.sidoCode,
        typeCode: content.value.contentId,
        title: title.value,
        page: 0,
        size: 10
      }
    })
    if (res.data.length === 0) {
      Toast.fire({
        icon: 'error',
        title: '검색 결과가 없습니다.'
      })
    } else {
      store.resetItems()
      searchStore.setItem({
        sidoCode: sido.value.sidoCode,
        typeCode: content.value.contentId,
        title: title.value
      })
      attractionItems.value = res.data
      console.log('검색 결과 ', attractionItems.value)
      store.setItems(attractionItems.value)
      router.push({ name: 'search' })
    }
  } catch (error) {
    console.error('에러' + error)
  }
}
</script>

<template>
  <form class="max-w-lg pr-20" @submit="attractionSearch">
    <div class="flex">
      <button id="sido-dropdown-button" data-dropdown-toggle="sido-dropdown"
        class="flex-shrink-0 z-10 inline-flex items-center py-2.5 px-4 text-sm font-medium text-center text-gray-900 bg-gray-100 border border-gray-300 rounded-s-lg hover:bg-gray-200 focus:ring-4 focus:outline-none focus:ring-gray-100 dark:bg-gray-700 dark:hover:bg-gray-600 dark:focus:ring-gray-700 dark:text-white dark:border-gray-600"
        type="button">
        {{ sido.sidoName }}
        <svg class="w-2.5 h-2.5 ms-2.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
          viewBox="0 0 10 6">
          <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="m1 1 4 4 4-4" />
        </svg>
      </button>
      <div id="sido-dropdown"
        class="z-40 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44 dark:bg-gray-700">
        <ul class="py-2 text-sm text-gray-700 dark:text-gray-200" aria-labelledby="dropdown-button">
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              @click="
                sido = {
                  sidoCode: 1,
                  sidoName: '서울'
                }
                ">
              서울
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="2" @click="sido = { sidoCode: 2, sidoName: '인천' }">
              인천
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="3" @click="sido = { sidoCode: 3, sidoName: '대전' }">
              대전
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="4" @click="sido = { sidoCode: 4, sidoName: '대구' }">
              대구
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="5" @click="sido = { sidoCode: 5, sidoName: '광주' }">
              광주
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="6" @click="sido = { sidoCode: 6, sidoName: '부산' }">
              부산
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="7" @click="sido = { sidoCode: 7, sidoName: '울산' }">
              울산
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="8" @click="sido = { sidoCode: 8, sidoName: '세종특별자치시' }">
              세종특별자치시
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="31" @click="sido = { sidoCode: 31, sidoName: '경기도' }">
              경기도
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="32" @click="sido = { sidoCode: 32, sidoName: '강원도' }">
              강원도
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="33" @click="sido = { sidoCode: 33, sidoName: '충청북도' }">
              충청북도
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="34" @click="sido = { sidoCode: 34, sidoName: '충청남도' }">
              충청남도
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="35" @click="sido = { sidoCode: 35, sidoName: '경상북도' }">
              경상북도
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="36" @click="sido = { sidoCode: 36, sidoName: '경상남도' }">
              경상남도
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="37" @click="sido = { sidoCode: 37, sidoName: '전라북도' }">
              전라북도
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="38" @click="sido = { sidoCode: 38, sidoName: '전라남도' }">
              전라남도
            </button>
          </li>
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="39" @click="sido = { sidoCode: 39, sidoName: '제주도' }">
              제주도
            </button>
          </li>
        </ul>
      </div>
      <button id="content-dropdown-button" data-dropdown-toggle="contentid-dropdown"
        class="flex-shrink-0 z-10 inline-flex items-center py-2.5 px-4 text-sm font-medium text-center text-gray-900 bg-gray-100 border border-gray-300 hover:bg-gray-200 focus:ring-4 focus:outline-none focus:ring-gray-100 dark:bg-gray-700 dark:hover:bg-gray-600 dark:focus:ring-gray-700 dark:text-white dark:border-gray-600"
        type="button">
        {{ content.contentName }}
        <svg class="w-2.5 h-2.5 ms-2.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
          viewBox="0 0 10 6">
          <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="m1 1 4 4 4-4" />
        </svg>
      </button>
      <div id="contentid-dropdown"
        class="z-40 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44 dark:bg-gray-700">
        <ul class="py-2 text-sm text-gray-700 dark:text-gray-200" aria-labelledby="dropdown-button">
          <!-- 관광지 -->
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="12" @click="content = { contentId: 12, contentName: '관광지' }">
              관광지
            </button>
          </li>

          <!-- 문화시설 -->
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="14" @click="content = { contentId: 14, contentName: '문화시설' }">
              문화시설
            </button>
          </li>

          <!-- 축제공연행사 -->
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="15" @click="content = { contentId: 15, contentName: '축제공연행사' }">
              축제공연행사
            </button>
          </li>

          <!-- 여행코스 -->
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="25" @click="content = { contentId: 25, contentName: '여행코스' }">
              여행코스
            </button>
          </li>

          <!-- 레포츠 -->
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="28" @click="content = { contentId: 28, contentName: '레포츠' }">
              레포츠
            </button>
          </li>

          <!-- 숙박 -->
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="32" @click="content = { contentId: 32, contentName: '숙박' }">
              숙박
            </button>
          </li>

          <!-- 쇼핑 -->
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="38" @click="content = { contentId: 38, contentName: '쇼핑' }">
              쇼핑
            </button>
          </li>

          <!-- 음식점 -->
          <li>
            <button type="button"
              class="inline-flex w-full px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              data-value="39" @click="content = { contentId: 39, contentName: '음식점' }">
              음식점
            </button>
          </li>
        </ul>
      </div>
      <div class="relative w-full">
        <input v-model="title" type="search" id="search-dropdown"
          class="block p-2.5 w-full z-20 text-sm text-gray-900 bg-gray-50 rounded-e-lg border-s-gray-50 border-s-2 border border-gray-300 focus:ring-mycolor focus:border-mycolor dark:bg-gray-700 dark:border-s-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:border-blue-500"
          placeholder="검색어" required />
        <button type="submit"
          class="absolute top-0 end-0 p-2.5 text-sm font-medium h-full text-white bg-mycolor rounded-e-lg border border-mycolor hover:bg-mycolor-hover focus:ring-4 focus:outline-none focus:ring-mycolor">
          <svg class="w-4 h-4" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z" />
          </svg>
          <span class="sr-only">Search</span>
        </button>
      </div>
    </div>
  </form>
</template>

<style scoped></style>
