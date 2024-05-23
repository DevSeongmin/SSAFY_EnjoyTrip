<script setup>

import { computed } from 'vue';

const props = defineProps({
  score: Number
})


const validScore = computed(() => {
  return isNaN(props.score) ? 0 : props.score;
});

</script>


<template>
  <div class="flex space-x-1">
    <div v-for="i in 5" :key="i" class="w-5 h-5 rounded-full"
      :class="{ 'bg-mycolor': i <= validScore, 'bg-gray-300': i > validScore }"></div>
  </div>
</template>

<style scoped></style>
