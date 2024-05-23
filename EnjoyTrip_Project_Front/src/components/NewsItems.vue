<script setup>
const props = defineProps({
  news: Object
})

console.log(props.news)

const openLink = () => {
  window.open(props.news.link)
}
</script>

<template>
  <div
    @click="openLink"
    class="dark:bg-gray-950 group relative overflow-hidden rounded-lg shadow-lg hover:shadow-xl transition-transform duration-300 ease-in-out hover:-translate-y-2"
  >
    <img
      :src="news.img"
      width="300"
      height="300"
      class="object-cover w-full h-60"
      style="aspect-ratio: 300 / 300; object-fit: cover"
    />

    <div class="bg-white p-4 dark:bg-gray-950">
      <h3 class="font-semibold text-lg md:text-xl group-hover:underline dark:text-white"></h3>
      <div class="flex justify-between">
        <p class="text-gray-500 dark:text-gray-400 mt-2">{{ news.title }}</p>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
