<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import BoaradComment from './BoaradComment.vue'
// import { useRoute } from 'vue-router'
import client from '@/api/client'
import Swal from 'sweetalert2'

import userImgData from '@/api/userImgData'

const router = useRouter()

const isLoading = ref(true)

const props = defineProps({
  postId: Number
})

const userId = ref('')
const memberDto = sessionStorage.getItem('memberDto')
if (memberDto !== null) {
  userId.value = JSON.parse(memberDto).userId
}

const board = ref({})
const objBoard = ref('')

const getBoard = async () => {
  try {
    const response = await client.get('/posting/' + props.postId)
    board.value = response.data
  } catch {
    alert('에러가 발생했습니다.')
  }
}

const goToModify = async () => {
  router.push({ name: 'boardModify', params: { postId: props.postId } })
}

const deleteBoard = async () => {
  try {
    const response = await client.delete('/posting/' + props.postId)
    console.log(response.data)
    Swal.fire({
      icon: 'success',
      title: '게시글이 삭제되었습니다.',
      showConfirmButton: true,
      // confirmButtonColor: '#4caf50',
      // confirmButtonText: '확인',
      timer: 2000
    })

    router.push({ name: 'board' })
  } catch {
    alert('에러가 발생했습니다.')
  }
}

const imgPath = ref('')

onMounted(async () => {
  await getBoard()
  isLoading.value = false

  objBoard.value = board.value

  imgPath.value = 'http://192.168.28.55/upload_img'
  // imgPath.value = 'http://localhost/upload_img'
  imgPath.value +=
    '/' + objBoard.value.fileInfo[0].saveFolder + '/' + objBoard.value.fileInfo[0].saveFile
})

const isImage = computed(() => {
  const extension = imgPath.value.split('.').pop().toLowerCase()
  return extension === 'jpg' || extension === 'jpeg' || extension === 'png' || extension === 'gif'
})
</script>

<template>
  <div v-if="!isLoading" class="grid gap-8 max-w-4xl mx-auto py-12 px-4 sm:px-6 lg:px-8 mt-[70px]">
    <div class="grid gap-2">
      <h1 class="text-3xl font-bold">{{ board.title }}</h1>
      <div class="flex justify-between items-center gap-4 text-sm text-gray-500">
        <div class="flex items-center gap-4">
          <span class="relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full">
            <img class="aspect-square h-full w-full" alt="@shadcn" :src="userImgData[board.userId] ? userImgData[board.userId] : '/src/assets/sample.png'
              " />
          </span>

          <div>
            <div class="font-medium">{{ board.userId }}</div>
            <div>{{ board.createdAt }}</div>

            {{ board.sidoName }} {{ board.gugunName }} 조회수 : {{ board.hit }}
          </div>
        </div>

        <div v-show="userId == board.userId">
          <button @click="goToModify"
            class="inline-flex items-center justify-center rounded-md bg-green-500 px-4 py-2 text-sm font-medium text-white shadow-sm transition-colors hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 mr-2">
            수정
          </button>

          <button @click="deleteBoard"
            class="inline-flex items-center justify-center rounded-md bg-red-500 px-4 py-2 text-sm font-medium text-white shadow-sm transition-colors hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 disabled:pointer-events-none disabled:opacity-50">
            삭제
          </button>
        </div>
      </div>
    </div>

    <img v-if="isImage" :src="imgPath" alt="Autumn Leaves" width="1200" height="800"
      class="rounded-lg object-cover w-full aspect-[3/2]" />

    <video v-if="!isImage" :src="imgPath" controls></video>

    <div class="prose prose-lg max-w-none">
      <p>
        {{ board.content }}
      </p>
    </div>

    <BoaradComment :boardId="board.postId" :loginUser="userId" />
  </div>
</template>

<style scoped></style>
