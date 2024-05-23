<script setup>

import BoardDetail from '@/components/board/BoardDetail.vue';
import { useRoute } from 'vue-router';

const route = useRoute();

console.log("route.params.postId")
console.log(route.params.boardId);
</script>




<template>
    <div>
        <BoardDetail :postId='route.params.boardId' />
    </div>
</template>

<style scoped></style>