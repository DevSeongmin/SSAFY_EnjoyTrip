<script setup>
import client from '@/api/client'
import BoardListItem from '@/components/board/BoardListItem.vue'
import { useRouter } from 'vue-router'
import { ref, onMounted, watchEffect, computed, watch } from 'vue'
import regionData from '@/api/regionData'

const sidoCode = ref(0)
const gugunCode = ref(0)
const gugunData = ref([])

watchEffect(() => {
  const selectedSido = regionData[sidoCode.value]
  if (selectedSido && selectedSido.children) {
    gugunData.value = selectedSido.children
  } else {
    gugunData.value = []
  }
})

watch(sidoCode, () => {
  gugunCode.value = 0
})



const props = defineProps({
  latest: Boolean
})

const boardList = ref([])

const getBoardList = () => {
  client
    .get('/posting/')
    .then((response) => {
      boardList.value = response.data
    })
    .catch(() => {
      alert('에러가 발생했습니다.')
    })
}





const router = useRouter()

const nowRoute = router.currentRoute.value.name

// 로그인 정보 계속 확인용
client.get('/members/ping').then((res) => {
  if (res.status === 200) {
    if (res.data === '') {
      return
    }
    sessionStorage.setItem('memberDto', JSON.stringify(res.data))
  } else {
    router.go(0)
  }
})

onMounted(() => {
  getBoardList()
})


const showList = computed(() => {
  if (sidoCode.value === 0 && gugunCode.value === 0) {
    return boardList.value;
  } else {
    return boardList.value.filter((board) => {
      return (
        (sidoCode.value === 0 || board.sidoCode === sidoCode.value) &&
        (gugunCode.value === 0 || board.gugunCode === gugunCode.value)
      );
    });
  }
});

</script>



<template>


  <div class="flex ml-[120px] mt-[120px]" v-show="!props.latest">
    <div>
      <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><strong>시도</strong>
        <select id="sidoCode" name="sidoCode" v-model="sidoCode"
          class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
          <option v-for="item in regionData" :key="item.id" :value="item.id">
            {{ item.name }}
          </option>
        </select>
      </label>
    </div>

    <div>
      <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><strong>구군</strong>
        <select id="gugunCode" name="gugunCode" v-model="gugunCode"
          class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
          <option value="0" v-if="gugunData.length < 1">전체 </option>
          <option v-for="item in gugunData" :key="item.id" :value="item.id">
            {{ item.name }}
          </option>
        </select>
      </label>
    </div>
  </div>


  <section class="mt-[20px] grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6 p-4 md:p-6 mx-2 md:mx-6"
    v-show="props.latest">
    <BoardListItem v-for="board in boardList.slice(0, 4)" :key="board.postId" :board="board" />
  </section>

  <section class="mt-[25px] grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6 p-4 md:p-6 mx-2 md:mx-6"
    v-show="!props.latest">
    <BoardListItem v-for="board in showList" :key="board.postId" :board="board" />
  </section>

  <div v-if="nowRoute !== 'home'" class="fixed bottom-6 right-10 group">
    <button @click="$router.push({ name: 'boardWrite' })" aria-controls="speed-dial-menu-dropdown-alternative"
      aria-expanded="false"
      class="flex items-center justify-center ml-auto text-white bg-mycolor rounded-full w-14 h-14 hover:bg-mycolor-hover">
      <svg class="w-6 h-6" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor"
        viewBox="0 0 20 20">
        <path
          d="m13.835 7.578-.005.007-7.137 7.137 2.139 2.138 7.143-7.142-2.14-2.14Zm-10.696 3.59 2.139 2.14 7.138-7.137.007-.005-2.141-2.141-7.143 7.143Zm1.433 4.261L2 12.852.051 18.684a1 1 0 0 0 1.265 1.264L7.147 18l-2.575-2.571Zm14.249-14.25a4.03 4.03 0 0 0-5.693 0L11.7 2.611 17.389 8.3l1.432-1.432a4.029 4.029 0 0 0 0-5.689Z" />
      </svg>
    </button>
  </div>
</template>

<style scoped></style>
