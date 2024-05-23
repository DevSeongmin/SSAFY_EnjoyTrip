<script setup>
import { onMounted } from 'vue'
import MarkdownIt from 'markdown-it'
import { initFlowbite, initModals } from 'flowbite'

onMounted(() => {
  initFlowbite()
  initModals()
})

const props = defineProps({
  result: String,
  age: String,
  together: String
})

console.log(props.result)
console.log('타입', typeof props.result)

const markdown = new MarkdownIt()
</script>

<template>
  <button
    class="border-mycolor h-[45px] w-full flex mt-[140px] -ml-2 mr-3 px-6 py-3 rounded-md bg-gray-50 text-gray-900 font-medium hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
    data-modal-target="gpt-modal" data-modal-toggle="gpt-modal" type="button" style='width:140px'>
    여행 경로 설명
  </button>
  <teleport to="body">
    <div id="gpt-modal" tabindex="-1" aria-hidden="true"
      class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
      <div class="relative p-4 w-full max-w-md max-h-full min-w-[50vw]">
        <!-- Modal content -->
        <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
          <!-- Modal header -->
          <div class="flex items-center justify-between p-4 md:p-5 border-b rounded-t dark:border-gray-600">
            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">{{ age }} {{ together }} 여행 경로 설명
            </h3>
            <button type="button"
              class="end-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 ms-auto inline-flex justify-center items-center dark:hover:bg-gray-600 dark:hover:text-white"
              data-modal-hide="gpt-modal">
              <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
                viewBox="0 0 14 14">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6" />
              </svg>
              <span class="sr-only">Close modal</span>
            </button>
          </div>
          <!-- Modal body -->

          <div class="p-4 md:p-5 w-full">
            <p class="scrollBar overflow-y-scroll max-h-[50vh] w-full min-w-[45vw]" v-html="markdown.render(result)">
            </p>
          </div>
        </div>
      </div>
    </div>
  </teleport>
</template>

<style scoped>
p {
  color: black;
  word-wrap: break-word;
}

/* 아래의 모든 코드는 영역::코드로 사용 */
.scrollBar::-webkit-scrollbar {
  width: 10px;
  /* 스크롤바의 너비 */
}

.scrollBar::-webkit-scrollbar-thumb {
  height: 30%;
  /* 스크롤바의 길이 */
  background: #a0a0a0;
  /* 스크롤바의 색상 */

  border-radius: 10px;
}

.scrollBar::-webkit-scrollbar-track {
  background: rgba(110, 110, 110, 0.1);
  /*스크롤바 뒷 배경 색상*/
}
</style>
