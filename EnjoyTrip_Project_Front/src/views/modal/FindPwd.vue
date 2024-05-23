<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import Swal from 'sweetalert2'
import client from '@/api/client'

const router = useRouter()

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

const idForFind = ref('')
const userEmail = ref('')


const findpwd = async (e) => {

  e.preventDefault()
  try {
    const response = await client.post('/members/find', {
      userId: idForFind.value,
      userEmail: userEmail.value
    })

    if (response.status !== 200) {
      Toast.fire({
        icon: 'error',
        title: '입력 양식을 확인하세요.'
      })
    }

    Swal.fire({
      title: '임시 비밀번호 발송 성공',
      icon: 'success',
      confirmButtonColor: '#3085d6',
      confirmButtonText: '확인'
    }).then(() => {
      router.go(0)
    })
  } catch (error) {
    console.error('에러' + error)
    Toast.fire({
      icon: 'error',
      title: error
    })
  }

}
// client.post('/findpwd', {
//   id: idForFind.value,
//   email: userEmail.value
// }).then((res) => {
//   if (res.data === 'success') {
//     Toast.fire({
//       icon: 'success',
//       title: 'Password has been sent to your email'
//     })
//     router.push('/')
//   } else {
//     Toast.fire({
//       icon: 'error',
//       title: 'Please check your ID and Email'
//     })
//   }
// }).catch((error) => {
//   console.error('에러' + error)
// })
// }


</script>

<template>
  <a data-modal-hide="login-modal" data-modal-target="findpwd-modal" data-modal-toggle="findpwd-modal" type="button"
    class="text-sm text-mycolor hover:underline">
    Find Password
  </a>
  <teleport to="body">
    <div id="findpwd-modal" tabindex="-1" aria-hidden="true"
      class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full min-h-full">
      <div class="relative p-4 w-full max-w-md max-h-full">
        <!-- Modal content -->
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <!-- Modal header -->
          <div class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600">
            <h3 class="text-xl font-semibold text-mycolor">Find Password</h3>
            <button type="button"
              class="end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
              data-modal-hide="findpwd-modal">
              <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
                viewBox="0 0 14 14">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6" />
              </svg>
              <span class="sr-only">Close modal</span>
            </button>
          </div>
          <div class="p-4 md:p-5">
            <form class="space-y-4" action="#">
              <div>
                <!-- 아이디 입력 -->
                <input v-model="idForFind" type="idForFind" name="idForFind" id="idForFind"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  placeholder="ID" required />
              </div>

              <div>
                <!-- 이메일 입력 -->
                <input v-model="userEmail" type="email" name="userEmail" id="userEmail" placeholder="Email"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  required />
              </div>
              <button @click="findpwd" type="submit"
                class="w-full text-white bg-mycolor hover:bg-mycolor-hover focus:ring-4 focus:outline-none focus:ring-mycolor-hover font-medium rounded-lg text-sm px-5 py-2.5 text-center">
                FindPassword
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </teleport>
</template>

<style scoped></style>
