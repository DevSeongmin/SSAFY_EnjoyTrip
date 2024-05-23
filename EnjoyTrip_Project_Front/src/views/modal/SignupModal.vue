<script setup>
import { ref, computed } from 'vue'
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

// 비밀번호 보이기
const showPassword = ref(false)

const passwordType = computed(() => {
  return showPassword.value ? 'text' : 'password'
})

// 유효성 검사
const userPattern = /^[A-Za-z0-9]{3,15}$/

// 이메일 유효성 검사
const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/

const isEmailValid = computed(() => emailPattern.test(email.value))

// 아이디 유효성 검사
const isUserIdValid = computed(() => userPattern.test(userId.value))

// 비밀번호 유효성 검사
const isUserPasswordValid = computed(() => userPattern.test(userPassword.value))

// 비밀번호 확인 유효성 검사
const isConfirmPasswordValid = computed(() => userPassword.value === confirmPassword.value)

// 이름 유효성 검사
const userNamePattern = /^[가-힣]+$/
const isUserNameValid = computed(() => userNamePattern.test(userName.value))

const userId = ref('')
const userPassword = ref('')
const userName = ref('')
const email = ref('')

const confirmPassword = ref('')

const signup = async (e) => {
  e.preventDefault()
  try {
    if (
      userId.value === '' ||
      userPassword.value === '' ||
      userName.value === '' ||
      email.value === ''
    ) {
      Swal.fire({
        icon: 'warning',
        title: '회원가입 실패',
        text: '모든 항목을 입력해주세요.',
        confirmButtonColor: '#3085d6',
        confirmButtonText: '확인'
      })
      return
    }

    if (userPassword.value !== confirmPassword.value) {
      Toast.fire({
        icon: 'error',
        title: '회원가입 실패',
        text: '비밀번호가 일치하지 않습니다.'
      })
      return
    }

    const response = await client.post('/members/join', {
      userId: userId.value,
      userPassword: userPassword.value,
      userName: userName.value,
      userEmail: email.value
    })


    if (response.status !== 200) {
      Swal.fire({
        title: '회원가입 실패',
        icon: 'error',
        confirmButtonColor: '#3085d6',
        confirmButtonText: '확인'
      })
      return
    }

    Swal.fire({
      title: '회원가입 성공',
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
      title: '회원가입 실패',
      text: error.response.data
    })
  }
}
</script>

<template>
  <button
    data-modal-target="signup-modal"
    data-modal-toggle="signup-modal"
    type="button"
    class="text-mycolor hover:underline"
  >
    Create Account
  </button>
  <div
    id="signup-modal"
    tabindex="-1"
    aria-hidden="true"
    class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
  >
    <div class="relative p-4 w-full max-w-md max-h-full">
      <!-- Modal content -->
      <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
        <!-- Modal header -->
        <div
          class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600"
        >
          <h3 class="text-xl font-semibold text-gray-900 dark:text-white">Sign up</h3>
          <button
            type="button"
            class="end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
            data-modal-hide="signup-modal"
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
        <div class="p-4 md:p-5">
          <form class="space-y-4" action="#">
            <div>
              <!-- 아이디 입력 -->
              <input
                v-model="userId"
                type="userId"
                name="userId"
                id="new-userId"
                :class="[
                  'text-sm rounded-lg block w-full p-2.5',
                  isUserIdValid
                    ? 'bg-green-50 border border-green-500 text-green-900 dark:text-green-400 placeholder-green-700 dark:placeholder-green-500 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-green-500'
                    : 'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white'
                ]"
                placeholder="ID"
                required
              />

              <div v-if="isUserIdValid">
                <p class="mt-2 text-sm text-green-600 dark:text-green-500">
                  <span class="font-medium">사용가능합니다!</span>
                </p>
              </div>
              <div v-else>
                <p class="mt-2 text-sm text-gray-400 dark:text-gray-500">
                  <span class="font-medium">(3-15자리 둘다 포함) 영어와 숫자로 입력해주세요</span>
                </p>
              </div>

              <!-- 이메일 입력 -->
              <input
                v-model="email"
                type="email"
                name="email"
                id="email"
                :class="[
                  'text-sm rounded-lg block w-full p-2.5 mt-2',
                  isEmailValid
                    ? 'bg-green-50 border border-green-500 text-green-900 dark:text-green-400 placeholder-green-700 dark:placeholder-green-500 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-green-500'
                    : 'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white'
                ]"
                placeholder="E-mail"
                required
              />
              <div v-if="isEmailValid">
                <p class="mt-2 text-sm text-green-600 dark:text-green-500">
                  <span class="font-medium">사용가능합니다!</span>
                </p>
              </div>
              <div v-else>
                <p class="mt-2 text-sm text-gray-400 dark:text-gray-500">
                  <span class="font-medium"
                    >이메일 형식으로 입력해주세요! (example123@naver.com)</span
                  >
                </p>
              </div>
            </div>

            <div>
              <!-- 비밀번호 입력 -->
              <input
                v-model="userPassword"
                :type="passwordType"
                name="userPassword"
                id="new-userPassword"
                placeholder="Password"
                :class="[
                  'text-sm rounded-lg block w-full p-2.5',
                  isUserPasswordValid
                    ? 'bg-green-50 border border-green-500 text-green-900 dark:text-green-400 placeholder-green-700 dark:placeholder-green-500 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-green-500'
                    : 'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white'
                ]"
                required
              />
              <div v-if="isUserPasswordValid">
                <p class="mt-2 text-sm text-green-600 dark:text-green-500">
                  <span class="font-medium">사용가능합니다!</span>
                </p>
              </div>
              <div v-else>
                <p class="mt-2 text-sm text-gray-400 dark:text-gray-500">
                  <span class="font-medium">(3-15자리 둘다 포함) 영어와 숫자로 입력해주세요</span>
                </p>
              </div>
            </div>
            <div>
              <!-- 비밀번호 확인  -->
              <input
                v-model="confirmPassword"
                :type="passwordType"
                name="confirmPassword"
                id="confirmPassword"
                placeholder="Comfirm Password"
                :class="[
                  'text-sm rounded-lg block w-full p-2.5',
                  isConfirmPasswordValid && confirmPassword !== ''
                    ? 'bg-green-50 border border-green-500 text-green-900 dark:text-green-400 placeholder-green-700 dark:placeholder-green-500 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-green-500'
                    : 'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white'
                ]"
                required
              />
              <!-- 비밀번호 확인 검증 -->
              <div v-if="isConfirmPasswordValid && confirmPassword !== ''">
                <p class="mt-2 text-sm text-green-600 dark:text-green-500">
                  <span class="font-medium">일치합니다!</span>
                </p>
              </div>
              <div v-else>
                <p class="mt-2 text-sm text-gray-400 dark:text-gray-500">
                  <span class="font-medium">일치하지 않습니다</span>
                </p>
              </div>
            </div>
            <!-- 이름 -->
            <div>
              <input
                v-model="userName"
                type="text"
                name="userName"
                id="userName"
                placeholder="Name"
                :class="[
                  'text-sm rounded-lg block w-full p-2.5',
                  isUserNameValid
                    ? 'bg-green-50 border border-green-500 text-green-900 dark:text-green-400 placeholder-green-700 dark:placeholder-green-500 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-green-500'
                    : 'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white'
                ]"
                required
              />
              <!-- 이름 검증 -->
              <div v-if="isUserNameValid">
                <p class="mt-2 text-sm text-green-600 dark:text-green-500">
                  <span class="font-medium">사용가능합니다!</span>
                </p>
              </div>
              <div v-else>
                <p class="mt-2 text-sm text-gray-400 dark:text-gray-500">
                  <span class="font-medium">(제발
                    )한글만 입력해주세요</span>
                </p>
              </div>
            </div>
            <div class="flex items-center mb-4">
              <input
                id="default-checkbox"
                type="checkbox"
                @click="showPassword = !showPassword"
                class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
              />
              <label
                for="default-checkbox"
                class="ms-2 text-sm font-medium text-gray-900 dark:text-gray-300"
                >Password Check</label
              >
            </div>
            <button
              @click="signup"
              type="submit"
              class="w-full text-white bg-mycolor hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
            >
              Sign up
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
