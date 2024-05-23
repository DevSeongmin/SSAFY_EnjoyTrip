<script setup>
import { ref } from 'vue'
import client from '@/api/client'
import Swal from 'sweetalert2'
import userImgData from '@/api/userImgData';


const props = defineProps({
  comment: Object,
  loginUser: String
})

const emit = defineEmits(['deleteComment'])

const userId = ref('')
const memberDto = sessionStorage.getItem('memberDto')
if (memberDto !== null) {
  userId.value = JSON.parse(memberDto).userId
}

const deleteComment = async () => {
  try {
    await client.delete('posting/comment/' + props.comment.id)

    Swal.fire({
      icon: 'success',
      title: '댓글이 삭제되었습니다.',
      showConfirmButton: true,
      timer: 2000
    })

    emit('delete-comment')
  } catch {
    alert('에러가 발생했습니다.')
  }
}
</script>

<template>
  <div class="text-sm flex items-start gap-4">
    <span class="relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full">
      <img class="aspect-square h-full w-full" alt="@shadcn"
        :src="userImgData[comment.userId] ? userImgData[comment.userId] : '/src/assets/sample.png'" />
    </span>
    <div class="grid gap-1.5">
      <div class="flex items-center gap-2">
        <div class="font-semibold">{{ comment.userId }}</div>
        <div class="text-gray-500 text-xs dark:text-gray-400">{{ comment.createdAt }}</div>
        <button v-show="userId == comment.userId"
          class="inline-flex items-center justify-center rounded-full bg-red-500 p-2 text-white hover:bg-red-600 focus:outline-none focus-visible:ring-2 focus-visible:ring-red-500 focus-visible:ring-offset-2">
          <svg @click="deleteComment" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
            fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
            class="h-5 w-5">
            <path d="M3 6h18"></path>
            <path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"></path>
            <path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"></path>
          </svg>
        </button>
      </div>
      <div>{{ comment.comment }}</div>
    </div>
  </div>
</template>

<style scoped></style>
