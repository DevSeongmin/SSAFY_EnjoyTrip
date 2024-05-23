<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import Swal from 'sweetalert2'
import client from '@/api/client'

const router = useRouter()

const userName = ref('')
const userId = ref('')
const grade = ref('')

// 로그인 유저 정보 가져오기
onMounted(() => {
  const memberDto = JSON.parse(sessionStorage.getItem('memberDto'))
  if (memberDto !== null) {
    userName.value = memberDto.userName
    userId.value = memberDto.userId
    grade.value = memberDto.grade
  }
})

const chgPwd = ref(false)

// 비밀번호 보이기
const showPassword = ref(false)

const passwordType = computed(() => {
  return showPassword.value ? 'text' : 'password'
})

// 유효성 검사
const userPattern = /^[A-Za-z0-9]{3,15}$/

// 비밀번호 유효성 검사
const userPassword = ref('')
const confirmPassword = ref('')

const isUserPasswordValid = computed(() => userPattern.test(userPassword.value))

// 비밀번호 확인 유효성 검사
const isConfirmPasswordValid = computed(() => userPassword.value === confirmPassword.value)

// 비밀번호 변경
const modifyPassword = async (e) => {
  e.preventDefault()
  try {
    if (!isUserPasswordValid.value || userPassword.value === '') {
      Swal.fire({
        title: '비밀번호는 영어와 숫자를 함께 사용하여 3-15자리여야 합니다.',
        icon: 'warning',
        confirmButtonColor: '#3085d6',
        confirmButtonText: '확인'
      })
      return
    }

    if (!isConfirmPasswordValid.value || confirmPassword.value === '') {
      Swal.fire({
        title: '비밀번호가 일치하지 않습니다.',
        icon: 'warning',
        confirmButtonColor: '#3085d6',
        confirmButtonText: '확인'
      })
      return
    }

    const response = await client.post('/members/modify', {
      userPassword: userPassword.value
    })

    if (response.status !== 200) {
      throw new Error('비밀번호 변경 실패')
    }

    Swal.fire({
      title: '비밀번호 변경 성공',
      icon: 'success',
      confirmButtonColor: '#3085d6',
      confirmButtonText: '확인'
    }).then(() => {
      router.go(0)
    })
  } catch (error) {
    console.error('에러' + error)
    Swal.fire({
      icon: 'error',
      title: '비밀번호 변경 실패',
      confirmButtonColor: '#3085d6',
      confirmButtonText: '확인'
    })
  }
}

const chkWithdraw = () => {
  !Swal.fire({
    icon: 'warning',
    title: '진짜로 회원 탈퇴 하실껀가요?',
    showCancelButton: 'true',
    cancelButtonText: '취소',
    cancelButtonColor: '#d20',
    confirmButtonColor: '#3085d6',
    confirmButtonText: '확인'
  }).then((result) => {
    if (result.isConfirmed) {
      withdraw()
    }
  })
}

// 회원 탈퇴
const withdraw = async () => {
  try {
    const response = await client.post('/members/withdraw')

    if (response.status !== 200) {
      Swal.fire({
        icon: 'error',
        title: '회원 탈퇴 실패',
        confirmButtonColor: '#3085d6',
        confirmButtonText: '확인'
      })
      return
    }

    await client.post('/members/logout')
    sessionStorage.removeItem('memberDto')

    Swal.fire({
      title: '회원 탈퇴 성공',
      icon: 'success',
      confirmButtonColor: '#3085d6',
      confirmButtonText: '확인'
    }).then(() => {
      router.go(0)
    })
  } catch (error) {
    console.error('에러' + error)
    Swal.fire({
      icon: 'error',
      title: '회원 탈퇴 실패',
      confirmButtonColor: '#3085d6',
      confirmButtonText: '확인'
    })
  }
}
</script>

<template>
  <a data-modal-target="myinfo-modal" data-modal-toggle="myinfo-modal" type="button"
    class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white">
    마이 페이지
  </a>
  <teleport to="body">
    <div id="myinfo-modal" tabindex="-1" aria-hidden="true"
      class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
      <div class="relative p-4 w-full max-w-md max-h-full">
        <!-- Modal content -->
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <!-- Modal header -->
          <div class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600">
            <h3 class="text-xl font-semibold text-mycolor dark:text-white">My info</h3>
            <button type="button"
              class="end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
              data-modal-hide="myinfo-modal">
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
              <div>이름 : {{ userName }}</div>
              <div>아이디 : {{ userId }}</div>
              <div v-if="chgPwd">
                <div>
                  <!-- 비밀번호 입력 -->
                  <input v-model="userPassword" :type="passwordType" name="userPassword" id="chg-userPassword"
                    placeholder="Password" :class="[
                      'text-sm rounded-lg block w-full p-2.5',
                      isUserPasswordValid
                        ? 'bg-green-50 border border-green-500 text-green-900 dark:text-green-400 placeholder-green-700 dark:placeholder-green-500 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-green-500'
                        : 'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white'
                    ]" />
                  <div v-if="isUserPasswordValid">
                    <p class="mt-2 text-sm text-green-600 dark:text-green-500">
                      <span class="font-medium">사용가능합니다!</span>
                    </p>
                  </div>
                  <div v-else>
                    <p class="mt-2 text-sm text-gray-400 dark:text-gray-500">
                      <span class="font-medium">(3-15자리) 영어와 숫자로 입력해주세요</span>
                    </p>
                  </div>
                </div>

                <div>
                  <!-- 비밀번호 확인  -->
                  <input v-model="confirmPassword" :type="passwordType" name="confirmPassword" id="chg-confirmPassword"
                    placeholder="Comfirm Password" :class="[
                      'text-sm rounded-lg block w-full p-2.5',
                      isConfirmPasswordValid && confirmPassword !== ''
                        ? 'bg-green-50 border border-green-500 text-green-900 dark:text-green-400 placeholder-green-700 dark:placeholder-green-500 focus:ring-green-500 focus:border-green-500 dark:bg-gray-700 dark:border-green-500'
                        : 'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-600 dark:border-gray-500 dark:placeholder-gray-400 dark:text-white'
                    ]" />
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
              </div>
              <div class="flex items-center mb-4">
                <input id="info-checkbox" type="checkbox" @click="chgPwd = !chgPwd"
                  class="checkbox w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-mycolor dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2" />
                <label for="info-checkbox" class="ms-2 text-sm font-medium text-gray-900 dark:text-gray-300">Password
                  Change</label>
                <div class="flex justify-end w-7/12">
                  <button type="button" class="text-sm justify-end text-red-500 hover:underline dark:text-red-500"
                    @click="chkWithdraw">
                    회원 탈퇴
                  </button>
                </div>
              </div>
              <button @click="modifyPassword" type="submit"
                class="w-full text-white bg-mycolor hover:bg-mycolor-hover focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
                비밀번호 변경
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </teleport>
</template>

<style scoped></style>
