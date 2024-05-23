<script setup>
import { ref } from 'vue'
import client from '@/api/client'
import Swal from 'sweetalert2'

// 알림창
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

const deleteMember = async (userId) => {
  const response = await client.post('/members/delete', {
    userId: userId
  })
  if (response.status === 200) {
    Toast.fire({
      icon: 'success',
      title: '회원 삭제 성공'
    })
    document.getElementById('memberModal-btn').click()
    document.getElementById('memberModal-btn').click()
  }
}

const memberList = ref([])

// // 멤버 리스트 얻기
const getMember = async () => {
  await client.get('/members/info').then((res) => {
    memberList.value = res.data
  })
}
</script>

<template>
  <a
    id="memberModal-btn"
    @click="getMember"
    data-modal-target="member-modal"
    data-modal-toggle="member-modal"
    class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
  >
    회원 관리
  </a>
  <!-- 모달 -->
  <teleport to="body">
    <div
      id="member-modal"
      tabindex="-1"
      aria-hidden="true"
      class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
    >
      <div class="relative p-4 w-full max-w-xl max-h-full">
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <div
            class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600"
          >
            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">Members</h3>
            <button
              type="button"
              class="end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
              data-modal-hide="member-modal"
            >
              <svg
                class="w-3 h-3"
                aria-hidden="true"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 14 14"
              >
                <path
                  stroke="currentColor"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"
                />
              </svg>
              <span class="sr-only">Close modal</span>
            </button>
          </div>
          <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
            <table class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
              <thead
                class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
              >
                <tr>
                  <th scope="col" class="px-6 py-3">Name</th>
                  <th scope="col" class="px-6 py-3">ID</th>
                  <th scope="col" class="px-6 py-3">Grade</th>
                  <th scope="col" class="px-6 py-3">Date</th>
                  <th scope="col" class="px-6 py-3 text-red-500">Delete</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="member in memberList"
                  :key="member.userId"
                  class="bg-white border-b dark:bg-gray-800 dark:border-gray-700"
                >
                  <th
                    scope="row"
                    class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                  >
                    {{ member.userName }}
                  </th>
                  <td class="px-6 py-4">
                    {{ member.userId }}
                  </td>
                  <td class="px-6 py-4">
                    {{ member.grade }}
                  </td>
                  <td class="px-6 py-4">
                    {{ member.registrationDate }}
                  </td>
                  <td class="px-6 py-4">
                    <button
                      @click="deleteMember(member.userId)"
                      class="font-medium text-red-600 dark:text-red-500 hover:underline"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </teleport>
</template>

<style scoped></style>
