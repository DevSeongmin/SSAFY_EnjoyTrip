<script setup>
import AttractionRecommand from '@/components/Attraction/AttractionRecommand.vue'
import BoardListView from '@/views/board/BoardListView.vue'
import NewsList from '@/components/NewsList.vue'
</script>

<template>
  <h1 class="ml-12 mt-44 -mb-40 text-center text-4xl font-bold text-mycolor ml-5">인기 관광지</h1>
  <div class="flex -mb-[200px] justify-center items-center h-screen w-full">
    <AttractionRecommand class="mt-8" />
  </div>

  <div class="flex-row m-10">
    <h1 class="mt-[150px] ml-12 text-center text-4xl font-bold text-mycolor ml-5">최신 게시물</h1>
    <BoardListView :latest="true" />
  </div>

  <div class="flex-row m-10">
    <h1 class="mt-[150px] ml-12 text-center text-4xl font-bold text-mycolor ml-5">최신 뉴스</h1>
    <NewsList />
  </div>
</template>

<style scoped>
.mainpageboard {
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
