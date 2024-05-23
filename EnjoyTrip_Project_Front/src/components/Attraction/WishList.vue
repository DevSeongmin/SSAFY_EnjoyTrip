<script setup>
import client from '@/api/client'

import WishListItem from './WishListItem.vue'
import { ref, onMounted } from 'vue'

import Draggable from 'vue3-draggable'
import KakaoMobility from './KakaoMobility.vue'
import ChatGpt from './ChatGpt.vue'
import { useWishList } from '@/store/attrationStore'

const wishStore = useWishList()

const isInit = ref(false)

const wishList = ref([])

const getWishList = async () => {
  try {
    const res = await client.get('/attractions/wishList')
    wishStore.clearWishList()
    wishList.value = res.data

    wishStore.setWishList(wishList.value)
  } catch (error) {
    console.error('에러' + error)
  }
  isInit.value = true
}

const updateWishList = (newWishList) => {
  wishList.value = newWishList
}

const handleDelete = (wishToDelete) => {
  console.log('에밋')
  const index = wishList.value.findIndex((wish) => wish === wishToDelete)
  if (index !== -1) {
    wishList.value.splice(index, 1)
  }
}

onMounted(async () => {
  await getWishList()
})

const gptloading = ref(true)

const loading = () => {
  gptloading.value = false
}
</script>

<template>
  <div class="flex w-full">
    <div class="mt-[150px] col-span-3">
      <div class="flex justify-between h-10 mb-2">
        <h1 style="margin-left: 260px; margin-top: 400; font-size: 30px">찜 목록</h1>
        <div v-if="!gptloading">
          <ChatGpt :wishList="wishList" @update-wishlist="updateWishList" v-if="isInit" class="rounded-xl" />
        </div>
      </div>

      <draggable v-model="wishList" v-if="isInit" :key="JSON.stringify(wishList)">
        <template v-slot:item="{ item }">
          <div>
            <WishListItem :wish="item" @delete="handleDelete" />
          </div>
        </template>
      </draggable>
    </div>
    <div v-if="wishList.length < 2" class="mt-40 text-[18px]">
      찜 목록이 1개 이하입니다.
      <br />
      2개 이상 부터 경로 및 챗봇을 이용할 수 있습니다.
      <br />
      😓
    </div>
    <div v-else>
      <!-- 경로 및 chatgpt -->
      <div class="flex flex-col mt-[48px]">
        <KakaoMobility :wishList="wishList" @loading="loading" v-if="isInit" class="rounded-xl w-full h-full"
          :load="load" />
      </div>
    </div>
  </div>
</template>

<style scoped></style>
