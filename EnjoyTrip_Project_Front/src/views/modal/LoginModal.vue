<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import SignupModal from '@/views/modal/SignupModal.vue'
import Swal from 'sweetalert2'
import client from '@/api/client'
import FindPwd from '@/views/modal/FindPwd.vue'

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

const userId = ref('')
const userPassword = ref('')

const login = async (e) => {
  e.preventDefault()
  try {
    const response = await client.post('/members/login', {
      userId: userId.value,
      userPassword: userPassword.value
    })



    sessionStorage.setItem('memberDto', JSON.stringify(response.data))

    Swal.fire({
      title: '로그인성공',
      icon: 'success',
      confirmButtonColor: '#3085d6',
      confirmButtonText: '확인'
    }).then(() => {
      router.go(0)
    })
  } catch (error) {
    Toast.fire({
      icon: 'error',
      title: "아이디 비밀번호를 확인하세요!"
    })
  }
}
</script>

<template>
  <button data-modal-target="login-modal" data-modal-toggle="login-modal" type="button"
    class="text-white focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
    <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
      viewBox="0 0 18 16">
      <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
        d="M1 8h11m0 0L8 4m4 4-4 4m4-11h3a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-3" />
    </svg>
  </button>
  <teleport to="body">
    <div id="login-modal" tabindex="-1" aria-hidden="true"
      class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
      <div class="relative p-4 w-full max-w-md max-h-full">
        <!-- Modal content -->
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <!-- Modal header -->
          <div class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600">
            <h3 class="text-xl font-semibold text-mycolor dark:text-white">Login</h3>
            <button type="button"
              class="end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
              data-modal-hide="login-modal">
              <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
                viewBox="0 0 14 14">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6" />
              </svg>
              <span class="sr-only">Close modal</span>
            </button>
          </div>
          <!-- Modal body -->
          <div class="p-4 md:p-5">
            <form class="space-y-4" action="#">
              <div>
                <input v-model="userId" type="userId" name="userId" id="userId"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  placeholder="ID" required />
              </div>
              <div>
                <input v-model="userPassword" type="password" name="userPassword" id="userPassword"
                  placeholder="Password"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white"
                  required />
              </div>
              <div class="flex justify-between">
                <FindPwd />
              </div>
              <button @click="login" type="submit"
                class="w-full text-white bg-mycolor hover:bg-mycolor-hover focus:ring-4 focus:outline-none focus:mycolor-hover font-medium rounded-lg text-sm px-5 py-2.5 text-center ">
                Login
              </button>
              <div class="text-sm font-medium  ">
                Not registered?
                <SignupModal />
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </teleport>
</template>

<style scoped></style>
