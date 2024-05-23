<script setup>

import BoardModify from '@/components/board/BoardModify.vue';
import { useRoute } from 'vue-router';

const route = useRoute();


</script>



<template>
  <div>
    <BoardModify :postId='route.params.boardId' />
  </div>
</template>

<style scoped></style>