<script setup>
import NewsItems from './NewsItems.vue'
import { ref } from 'vue'

const newsList = ref([
  {
    title: '한국관광공사-제주올레‘바당길, 깨끗하길’시즌3 캠페인 시동',
    link: 'http://www.ktnbm.co.kr/news_view.html?news_seq=2752',
    img: '/src/assets/뉴스1.jpg'
  },
  {
    title: '영월의 보물: 신비의 문화유산, 영월장릉',
    link: 'http://hankuknews.com/news/view.php?no=4521',
    img: '/src/assets/뉴스2.jpg'
  },
  {
    title: '서귀포 한남 사려니오름숲에서 함께 숲탐방 하실래요?',
    link: 'http://hankuknews.com/news/view.php?no=4519',
    img: '/src/assets/뉴스3.jpg'
  },
  {
    title: '2024 여수거북선축제, 임진년 5월 4일을 기억하는 호국문화제',
    link: 'http://hankuknews.com/news/view.php?no=4496',
    img: '/src/assets/뉴스4.jpg'
  }
])
</script>

<template>
  <section class="mt-[25px] grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6 p-4 md:p-6 mx-2 md:mx-6">
    <NewsItems v-for="(news, index) in newsList" :key="index" :news="news" />
  </section>
</template>

<style scoped></style>
