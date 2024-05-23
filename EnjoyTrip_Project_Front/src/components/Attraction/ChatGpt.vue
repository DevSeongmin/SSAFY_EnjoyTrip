<script setup>
import { ref, defineEmits } from 'vue'
import OpenAI from 'openai'
// import MarkdownIt from 'markdown-it'
import ChatGptmodal from '@/views/modal/ChatGptmodal.vue'

import Swal from 'sweetalert2';

const props = defineProps({
  wishList: Object
})

const emit = defineEmits(['update-wishlist'])

const wishList = ref(props.wishList)

const isLoading = ref(false)

const explain = ref(false)

// const markdown = new MarkdownIt()

let text = ref('')

const openai = new OpenAI({
  apiKey: import.meta.env.VITE_OPENAI_API_KEY,
  dangerouslyAllowBrowser: true
})

const result = ref({
  content: ''
})

const getTripRoute = async () => {

  if (age.value === "" || together.value === "") {
    Swal.fire({
      icon: 'error',
      title: '나이와 동반 정보를 입력하세요.',
      showConfirmButton: false,
      timer: 6000
    })
    return;
  }

  isLoading.value = true
  text.value = wishList.value
  const response = await openai.chat.completions.create({
    messages: [
      {
        role: 'system',
        content: `나의 정보 ${age.value} ${together.value} ` + import.meta.env.VITE_PROMPT
      },
      {
        role: 'user',
        content: JSON.stringify(text.value)
      }
    ],
    model: 'gpt-4o',
    max_tokens: 2000
  })

  result.value = response.choices[0].message.content
  wishList.value = eval(
    response.choices[0].message.content.replace(/`/g, '').replace('javascript', '')
  )

  await getExplanation()
  emit('update-wishlist', wishList.value)
  isLoading.value = false
  explain.value = true
}

const getExplanation = async () => {
  const response = await openai.chat.completions.create({
    messages: [
      {
        role: 'user',
        content: JSON.stringify(text.value)
      },
      {
        role: 'assistant',
        content: result.value
      },
      {
        role: 'user',
        content:
          `${together.value} ${age.value}에게 해당 여행 경로에 대한 설명, 여행 경로 순서를 정한 이유, 예상 소요시간, 경비등의 이유를 문단 사이에 띄어쓰기를 하여 마크다운 형식으로 분류별로 사용자 친화적으로 제공하시오  그리고 그 외의 답변은 허용하지 않습니다`
      }
    ],
    model: 'gpt-4o',
    max_tokens: 2000
  })

  result.value = response.choices[0].message
}


const together = ref("")
const age = ref("")

const togethers = [
  "비지니스",
  "커플",
  "가족",
  "친구",
  "단독"
]

const ages = [
  "10대",
  "20대",
  "30대",
  "40대",
  "50대",
  "60대",
]



</script>

<template>
  <div class="flex flex-col w-full h-12 -mt-[140px]">
    <div v-if="!explain" class='flex-col'>

      <div class="flex ml-[80px] mt-[120px]">
        <div>
          <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><strong>나이</strong>
            <select id="age" name="age" v-model="age"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
              <option v-for="item in ages" :key="item" :value="item">
                {{ item }}
              </option>
            </select>
          </label>
        </div>

        <div>
          <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><strong>동반</strong>
            <select id="together" name="together" v-model="together"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
              <option v-for="item in togethers" :key="item" :value="item">
                {{ item }}
              </option>
            </select>
          </label>
        </div>

        <div @click="getTripRoute" :style="{
          width: '200px',
          backgroundColor: isLoading ? '#D3D3D3' : 'white',
          pointerEvents: isLoading ? 'none' : 'auto'
        }"
          class="border h-[45px] w-full flex mt-5 ml-3 px-6 py-3 rounded-md bg-gray-50 text-gray-900 font-medium hover:bg-gray-500 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2">


          <img src="@/assets/GPT.png" width="30px" />
          <div class="flex items-center justify-center ml-5">
            <div v-if="!isLoading">AI 추천 계획</div>
            <div role="status" class="ml-5" v-show="isLoading">
              <svg aria-hidden="true" class="w-8 h-8 text-gray-200 animate-spin dark:text-gray-600 fill-mycolor"
                viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path
                  d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
                  fill="currentColor" />
                <path
                  d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
                  fill="currentFill" />
              </svg>
              <span class="sr-only">Loading...</span>
            </div>
          </div>
        </div>



      </div>






    </div>
    <div v-else>
      <ChatGptmodal :result="result.content" :age='age' :together='together' />
    </div>
    <!-- <div role="status" class="max-w-2xl animate-pulse mx-10 mt-20 mr-16" v-show="isLoading">
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-340 mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 max-w-[360px] mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-340 mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 max-w-[360px] mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-340 mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-340 mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 max-w-[360px] mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-340 mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-340 mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-340 mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-340 mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-340 mb-4"></div>
      <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-340 mb-4"></div>
      <span class="sr-only">Loading...</span>
    </div> -->
    <!-- <p
      v-html="markdown.render(result.content)"
      style="color: black"
      class="mx-14 mt-14 overflow-y-scroll"
      v-show="!isLoading"
    ></p> -->
  </div>
</template>

<style scoped></style>
