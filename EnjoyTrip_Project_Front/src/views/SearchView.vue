<script setup>
import SideMenu from '../components/SideMenu.vue'
import AttractionList from '../components/Attraction/AttractionList.vue'
import { useAttractionStore } from '@/store/attrationStore'
import { storeToRefs } from 'pinia'
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const store = useAttractionStore()

onMounted(() => {
  if (!storeToRefs(store).attractionItems.value.length) {
    router.push('/')
  }
})
</script>

<template>
  <div class="max-w-7xl mx-auto py-10">
    <SideMenu />
    <AttractionList />
  </div>
</template>

<style scoped></style>
