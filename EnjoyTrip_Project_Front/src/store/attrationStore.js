import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useAttractionStore = defineStore(
  'attraction',
  () => {
    const attractionItems = ref([])

    const setItems = (items) => {
      attractionItems.value = items
    }

    const resetItems = () => {
      attractionItems.value = []
    }

    return { attractionItems, setItems, resetItems }
  },
  { persist: true }
)

export const useAttractionInfoStore = defineStore(
  'attractionInfo',
  () => {
    const attractionInfo = ref({})

    const setItem = (item) => {
      attractionInfo.value = item
    }
    return { attractionInfo, setItem }
  },
  { persist: true }
)

export const useAttractionSearchStore = defineStore(
  'attractionSearchInfo',
  () => {
    // title, content_id, sido_code
    const attractionSearchInfo = ref({})

    const setItem = (item) => {
      attractionSearchInfo.value = item
    }

    return { attractionSearchInfo, setItem }
  },
  { persist: true }
)

export const useWishList = defineStore(
  'wishListItems',
  () => {
    const wishListItems = ref([])
    const addToWishList = (item) => {
      wishListItems.value.push(item)
    }

    const setWishList = (items) => {
      wishListItems.value = items
    }

    const removeFromWishList = (item) => {
      const index = wishListItems.value.findIndex((i) => i.id === item.id)
      if (index !== -1) {
        wishListItems.value.splice(index, 1)
      }
    }
    const clearWishList = () => {
      wishListItems.value = []
    }
    return { wishListItems, setWishList, addToWishList, removeFromWishList, clearWishList }
  },
  { persist: true }
)
