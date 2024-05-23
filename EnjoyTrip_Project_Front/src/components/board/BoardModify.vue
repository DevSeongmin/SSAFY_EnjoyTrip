<script setup>
import client from '@/api/client'
import { useRouter } from 'vue-router'
import { ref, onMounted } from 'vue'
import Swal from 'sweetalert2'

const router = useRouter()

const props = defineProps({
  postId: Number
})

const isLoading = ref(true)
console.log(props.postId)

const board = ref({})

const getBoard = async () => {
  try {
    const response = await client.get('/posting/' + props.postId)
    board.value = response.data
  } catch {
    alert('에러가 발생했습니다.')
  }
}

const modifyBoard = async () => {
  try {
    const response = await client.put('/posting/' + props.postId, {
      title: board.value.title,
      content: board.value.content,
      sidoCode: board.value.sidoCode,
      gugunCode: board.value.gugunCode
    })
    console.log(response.data)
    Swal.fire({
      icon: 'success',
      title: '게시글이 수정되었습니다.',
      showConfirmButton: true,
      timer: 2000
    })
    router.push({ name: 'board' })
  } catch {
    alert('에러가 발생했습니다.')
  }
}

onMounted(async () => {
  await getBoard()
  isLoading.value = false
  console.log(board.value)
})
</script>

<template>
  <div class="flex flex-col items-center justify-center h-screen bg-gray-100 dark:bg-gray-900">
    <div class="w-full max-w-7xl px-10 py-15 bg-white rounded-lg shadow-lg dark:bg-gray-800">
      <form
        class="space-y-10 h-[42rem] mx-auto"
        enctype="multipart/form-data"
        @submit.prevent="onSubmit"
      >
        <div class="flex"></div>

        <div class="mb-6">
          <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
            ><strong>제목</strong>
            <input
              type="text"
              id="title"
              name="title"
              v-model="board.title"
              placeholder="제목을 입력하세요."
              class="block w-full p-4 text-gray-900 border border-gray-300 rounded-lg bg-gray-50 text-base focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
            />
          </label>
        </div>

        <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
          ><strong>내용</strong>
          <textarea
            id="content"
            name="content"
            placeholder="Enter content"
            rows="15"
            v-model="board.content"
            class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
          ></textarea>
        </label>

        <div class="flex justify-end gap-4 pt-14">
          <button
            @click="modifyBoard"
            class="text-white bg-gradient-to-r from-blue-500 via-blue-600 to-blue-700 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-blue-300 dark:focus:ring-blue-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
          >
            수정하기
          </button>

          <button
            type="button"
            @click="router.push({ name: 'board' })"
            class="text-white bg-gradient-to-r from-gray-500 via-gray-600 to-gray-700 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-gray-300 dark:focus:ring-gray-800 shadow-lg shadow-gray-500/50 dark:shadow-lg dark:shadow-gray-800/80 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
          >
            뒤로 가기
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped></style>
