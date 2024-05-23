<script setup>
import client from '@/api/client'
import regionData from '@/api/regionData'
import { useRouter } from 'vue-router'
import { ref, watchEffect } from 'vue'
import Swal from 'sweetalert2'

const router = useRouter()

let sidoCode = ref(0)

let gugunData = ref([])

watchEffect(() => {
  const selectedSido = regionData[sidoCode.value]
  if (selectedSido && selectedSido.children) {
    gugunData.value = selectedSido.children
  } else {
    gugunData.value = []
  }
})

const onSubmit = (e) => {
  e.preventDefault()

  const formData = new FormData()

  const title = e.target.elements.title.value
  const content = e.target.elements.content.value
  const image = e.target.elements.upfile.files[0]
  const sidoCode = e.target.elements.sidoCode.value
  const gugunCode = e.target.elements.gugunCode.value

  formData.append('title', title)
  formData.append('content', content)
  formData.append('upfile', image)
  formData.append('sidoCode', sidoCode)
  formData.append('gugunCode', gugunCode)

  client
    .post('/posting/write', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
    .then((response) => {
      console.log(response.data)
      Swal.fire({
        icon: 'success',
        title: '게시글이 작성되었습니다.',
        showConfirmButton: false,
        // confirmButtonColor: '#4caf50',
        // confirmButtonText: '확인',
        timer: 6000
      })
      router.push({ name: 'board' })
    })
    .catch(() => {
      Swal.fire({
        icon: 'error',
        title: '게시글 작성에 실패했습니다.',
        showConfirmButton: true,
        confirmButtonColor: '#4caf50',
        confirmButtonText: '확인'
      })
    })
}
</script>

<template>
  <div class="flex flex-col items-center justify-center h-screen bg-gray-100 dark:bg-gray-900">
    <div class="w-full max-w-7xl px-10 py-15 bg-white rounded-lg shadow-lg dark:bg-gray-800">
      <form class="space-y-10 h-[42rem] mx-auto" enctype="multipart/form-data" @submit.prevent="onSubmit">
        <div class="flex mt-10">
          <div>
            <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><strong>시도</strong>
              <select id="sidoCode" name="sidoCode" v-model="sidoCode"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
                <option v-for="item in regionData" :key="item.id" :value="item.id">
                  {{ item.name }}
                </option>
              </select>
            </label>
          </div>

          <div>
            <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><strong>구군</strong>
              <Select id="gugunCode" name="gugunCode"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
                <option value="0">전체</option>
                <option v-for="item in gugunData" :key="item.id" :value="item.id">
                  {{ item.name }}
                </option>
              </Select>
            </label>
          </div>
        </div>

        <div class="mb-6">
          <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">제목
            <input type="text" id="title" name="title" placeholder="제목을 입력하세요." required
              class="block w-full p-4 text-gray-900 border border-gray-300 rounded-lg bg-gray-50 text-base focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" />
          </label>
        </div>

        <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">내용
          <textarea id="content" name="content" rows="8"
            class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
            placeholder="내용을 입력하세요." required></textarea>
        </label>

        <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white" for="large_size"><strong>사진
            업로드</strong>
          <input
            class="block w-full text-lg text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 dark:text-gray-400 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400"
            id="upfile" name="upfile" type="file" required />
        </label>

        <div class="flex justify-end gap-4">
          <!-- 작성 버튼 -->
          <button type="submit"
            class="text-white bg-gradient-to-r from-blue-500 via-blue-600 to-blue-700 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-blue-300 dark:focus:ring-blue-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2">
            작성하기
          </button>
          <!-- 뒤로가기 버튼 -->
          <button type="button" @click="router.push({ name: 'board' })"
            class="text-white bg-gradient-to-r from-gray-500 via-gray-600 to-gray-700 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-gray-300 dark:focus:ring-gray-800 shadow-lg shadow-gray-500/50 dark:shadow-lg dark:shadow-gray-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2">
            뒤로 가기
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped></style>
