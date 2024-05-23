<script setup>
import { ref, computed } from 'vue'
import client from '@/api/client'
import Swal from 'sweetalert2'
import { useRouter } from 'vue-router'

const router = useRouter()

import { storeToRefs } from 'pinia'
import { useAttractionInfoStore } from '@/store/attrationStore'
const attractionInfoStore = useAttractionInfoStore()

const { attractionInfo } = storeToRefs(attractionInfoStore)

const hoverScore = ref(3)
const scoreText = computed(() => {
  if (hoverScore.value === 1) {
    return '최악'
  } else if (hoverScore.value === 2) {
    return '별로'
  } else if (hoverScore.value === 3) {
    return '보통'
  } else if (hoverScore.value === 4) {
    return '좋음'
  } else if (hoverScore.value === 5) {
    return '아주 좋음'
  }
  return ''
})

const together = ref('단독')
const score = ref(3)
const content = ref('')
const title = ref('')

const onSubmit = (e) => {
  e.preventDefault()

  const formData = new FormData()

  const title = e.target.elements.title.value
  const content = e.target.elements.content.value
  const image = e.target.elements.upfile.files[0]

  formData.append('title', title)
  formData.append('content', content)
  formData.append('rating', score.value)
  formData.append('contentId', attractionInfo.value.contentId)
  formData.append('together', together.value)
  formData.append('upfile', image)

  console.log(title)
  console.log(content)
  console.log(score.value)
  console.log(attractionInfo.value.contentId)
  console.log(together.value)
  console.log(image)

  client
    .post('/review', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
    .then((response) => {
      console.log(response.data)
      Swal.fire({
        icon: 'success',
        title: '리뷰가 작성되었습니다.',
        showConfirmButton: false,
        // confirmButtonColor: '#4caf50',
        // confirmButtonText: '확인',
        timer: 6000
      })
      router.go(-1)
    })
    .catch(() => {
      Swal.fire({
        icon: 'error',
        title: '리뷰 작성에 실패했습니다.',
        showConfirmButton: true,
        confirmButtonColor: '#4caf50',
        confirmButtonText: '확인'
      })
    })
}
</script>
<template>
  <aside class="w-2/5">
    <div class="border p-8 rounded-md shadow-md mx-[-4rem] sm:mx-0">
      <h2 class="text-2xl font-bold mb-4">귀하의 경험에 대해 평가해주세요.</h2>
      <form class="space-y-4" enctype="multipart/form-data" @submit.prevent="onSubmit">
        <div>
          <div class="flex mt-4 space-x-2">
            <div v-for="i in 5" :key="i" class="w-8 h-8 rounded-full"
              :class="{ 'bg-mycolor': i <= hoverScore, 'bg-gray-300': i > hoverScore }" @mouseover="hoverScore = i"
              @mouseout="hoverScore = score" @click="score = i"></div>
            <div class="mt-1 ml-4">
              <strong> {{ scoreText }}</strong>
            </div>
          </div>
        </div>
        <div>
          <label class="block mb-1 text-sm font-medium" for="visit-type">
            <strong>누구와 함께 가셨나요?</strong>
          </label>
          <div class="flex space-x-2">
            <button @click.prevent="together = '비지니스'" :class="{ 'border-black border-mycolor': together === '비지니스' }"
              class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-gray-200 h-10 px-4 py-2 border-2">
              비지니스
            </button>
            <button @click.prevent="together = '커플'" :class="{ 'border-black border-mycolor': together === '커플' }"
              class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-gray-200 h-10 px-4 py-2 border-2">
              커플
            </button>
            <button @click.prevent="together = '가족'" :class="{ 'border-black border-mycolor': together === '가족' }"
              class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-gray-200 h-10 px-4 py-2 border-2">
              가족
            </button>
            <button @click.prevent="together = '친구'" :class="{ 'border-black border-mycolor': together === '친구' }"
              class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-gray-200 h-10 px-4 py-2 border-2">
              친구
            </button>
            <button @click.prevent="together = '단독'" :class="{ 'border-black border-mycolor': together === '단독' }"
              class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-gray-200 h-10 px-4 py-2 border-2">
              단독
            </button>
          </div>
        </div>
        <!-- 리뷰 작성 -->
        <div>
          <label class="block mb-1 text-sm font-medium" for="review-content">
            <strong>리뷰 쓰기</strong>
          </label>
          <textarea v-model="content"
            class="flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-mycolor focus-visible:ring-2  focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 min-h-[100px]"
            id="content" name="content" placeholder="Enter review content" required> </textarea>
        </div>
        <!-- 리뷰 제목 작성 -->
        <div>
          <label class="block mb-1 text-sm font-medium" for="review-title">
            <strong>제목</strong>
          </label>
          <input v-model="title"
            class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 mb-2"
            id="title" name="title" placeholder="Enter review title" required />
        </div>
        <!-- 사진 추가 -->
        <div>
          <strong>사진 추가하기</strong>
          <br />선택사항

          <input
            class="flex w-full rounded-md border pl-1 border-input bg-background px-3 text-sm ring-offset-background file:border-0 file:bg-white file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
            id="upfile" name="upfile" type="file" />
        </div>


        <div class="inline-flex items-center justify-center w-full">
          <input type="submit" value="리뷰 제출"
            class="inline-flex items-center justify-center whitespace-nowrap text-sm font-medium ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-mycolor focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 rounded-full px-24 py-2 bg-mycolor text-white hover:bg-mycolor-hover focus:outline-none focus:ring-2 focus:ring-black focus:ring-offset-2 transition-colors" />
        </div>
      </form>
    </div>
  </aside>
</template>

<style scoped></style>
