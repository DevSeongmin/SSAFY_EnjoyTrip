<script setup>
import ReviewWriteAside from '@/components/Review/ReviewWriteForm.vue'
import ReviewWriteAttraction from '@/components/Review/ReviewWriteAttraction.vue'

const reviewScore = history.state.reviewScore
</script>

<template>
  <div class="container mx-auto px-4 mt-[180px]">
    <main class="flex mt-8">
      <ReviewWriteAttraction :reviewScore="reviewScore" />
      <ReviewWriteAside />
    </main>
  </div>
</template>

<style scoped></style>
