<script setup>
import AttractionListItem from './AttractionListItem.vue'
import { useAttractionStore, useAttractionSearchStore } from '@/store/attrationStore'
import client from '@/api/client'
import { storeToRefs } from 'pinia'
import Swal from 'sweetalert2'
import { onMounted, ref, onBeforeUnmount, watch } from 'vue'
import { useRouter } from 'vue-router'
import { initDropdowns, initFlowbite } from 'flowbite'
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

const searchStore = useAttractionSearchStore()

const { attractionSearchInfo } = storeToRefs(searchStore)

const addedItemIds = new Set()

const pageNo = ref(10)

const store = useAttractionStore()

const { attractionItems } = storeToRefs(store)

// 정렬 순서
const orderBy = ref('default')

console.log('attractionItems.value', attractionItems.value)

// 정렬 순서 변경
watch(orderBy, async (newVal) => {
  console.log(newVal)
  switch (newVal) {
    case 'nameUp':
      attractionItems.value.sort((a, b) => a.title.localeCompare(b.title))
      break
    case 'viewUp':
      attractionItems.value.sort((a, b) => b.readCount - a.readCount)
      break
    case 'nameDown':
      attractionItems.value.sort((a, b) => b.title.localeCompare(a.title))
      break
    case 'viewDown':
      attractionItems.value.sort((a, b) => a.readCount - b.readCount)
      break
    case 'scoreUp':
      attractionItems.value.sort((a, b) => b.reviewCount - a.reviewCount)
      break
    case 'likeUp':
      attractionItems.value.sort((a, b) => b.wishCount - a.wishCount)
      break
    case 'scoreDown':
      attractionItems.value.sort((a, b) => a.reviewCount - b.reviewCount)
      break
    case 'likeDown':
      attractionItems.value.sort((a, b) => a.wishCount - b.wishCount)
      break
  }
})

const router = useRouter()

// 스크롤 다운 검색
const scrollDownSearch = async () => {
  try {
    const res = await client.get('/attractions/search', {
      params: {
        sidoCode: attractionSearchInfo.value.sidoCode,
        typeCode: attractionSearchInfo.value.typeCode,
        title: attractionSearchInfo.value.title,
        page: pageNo.value,
        size: 10
      }
    })
    if (res.data.length < 10) {
      Toast.fire({
        icon: 'success',
        title: '검색 결과가 모두 로드되었습니다.'
      })
    } else {
      const newItems = res.data.filter((item) => !addedItemIds.has(item.contentId))
      newItems.forEach((item) => addedItemIds.add(item.contentId))
      attractionItems.value = attractionItems.value.concat(newItems)
      store.setItems(attractionItems.value)
      pageNo.value += 10
    }
  } catch (error) {
    console.error('에러' + error)
  }
}

const handleScroll = (e) => {
  e.preventDefault()
  if (window.innerHeight + window.scrollY >= document.body.offsetHeight) {
    scrollDownSearch()
  }
}

onBeforeUnmount(() => {
  window.removeEventListener('scroll', handleScroll)
})

onMounted(() => {
  initFlowbite()
  initDropdowns()
  if (!attractionItems.value.length) {
    router.push('/')
  }
  window.addEventListener('scroll', handleScroll)
})
</script>

<template>
  <div class="mt-[40px] col-span-3">
    <form class="max-w-sm ml-[14vw]">
      <!-- Dropdown button -->
      <button id="dropdownDefaultButton" data-dropdown-toggle="orderByDropdown"
        class="mt-5 text-white bg-mycolor hover:bg-mycolor-hover focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center inline-flex items-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
        type="button">
        정렬 순서
        <svg class="w-2.5 h-2.5 ms-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
          viewBox="0 0 10 6">
          <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="m1 1 4 4 4-4" />
        </svg>
      </button>

      <!-- Dropdown menu -->
      <div id="orderByDropdown"
        class="z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-44 dark:bg-gray-700">
        <ul class="py-2 text-sm text-gray-700 dark:text-gray-200" aria-labelledby="dropdownDefaultButton">
          <li>
            <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              @click="orderBy = 'default'">정렬 순서</a>
          </li>
          <li>
            <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              @click="orderBy = 'nameUp'">이름 ㄱ - ㅎ</a>
          </li>
          <li>
            <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              @click="orderBy = 'nameDown'">이름 ㅎ - ㄱ</a>
          </li>
          <li>
            <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              @click="orderBy = 'viewUp'">조회수 높은 순</a>
          </li>
          <li>
            <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              @click="orderBy = 'viewDown'">조회수 낮은 순</a>
          </li>
          <li>
            <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              @click="orderBy = 'scoreUp'">평점 높은 순</a>
          </li>
          <li>
            <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              @click="orderBy = 'scoreDown'">평점 낮은 순</a>
          </li>
          <li>
            <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              @click="orderBy = 'likeUp'">찜 많은 수</a>
          </li>
          <li>
            <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
              @click="orderBy = 'likeDown'">찜 적은 수</a>
          </li>
        </ul>
      </div>
    </form>
    <div class="space-y-8" v-for="attractionItem in attractionItems" :key="attractionItem.id">
      <AttractionListItem :attractionItem="attractionItem" />
    </div>
  </div>
</template>

<style scoped></style>
