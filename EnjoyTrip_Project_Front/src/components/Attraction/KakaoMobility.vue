<script setup>
import axios from 'axios'
import { ref, onMounted, watch, defineEmits } from 'vue'

import { KakaoMap, KakaoMapPolyline, KakaoMapMarker, KakaoMapCustomOverlay } from 'vue3-kakao-maps'
// import { useWishList } from '@/store/attrationStore'

const props = defineProps({
  wishList: Object
})

const emit = defineEmits(['loading'])

const REST_API_KEY = import.meta.env.VITE_KAKAO_REST_API_KEY
const URL = 'https://apis-navi.kakaomobility.com/v1/waypoints/directions'

// 커스텀 오버레이
const content = (info) => `<div
        style="
          padding: 10px;
          background-color: white;
          border: 1px solid #ccc;
          border-radius: 5px;
          display: flex;
          flex-direction: column;
          align-items: flex-start;
        "
      >
        <div style="font-weight: bold; margin-bottom: 5px">${info}</div>
      </div>`

const onClickKakaoMapMarker = (item) => {
  item.visible = !item.visible
}

const loading = ref(true)

const roadIdx = ref(0)

const roadIdxChg = (idx) => {
  roadIdx.value = idx
}

const latLngList = ref([])

const mapMarkers = ref([])
const markerList = ref([])

const lat = ref(0)
const lng = ref(0)
const distance = ref(0)

const getKakaoMap = async () => {
  mapMarkers.value.forEach((marker) => marker.setMap(null))
  mapMarkers.value = []

  if (props.wishList.length < 2) {
    console.error('최소 두 개의 경유지가 필요합니다.')
    return
  }

  const wayBody = {
    origin: {
      x: props.wishList[0].longitude,
      y: props.wishList[0].latitude
    },
    destination: {
      x: props.wishList[props.wishList.length - 1].longitude,
      y: props.wishList[props.wishList.length - 1].latitude
    },
    waypoints: props.wishList.slice(1, -1).map((item, index) => ({
      name: 'name' + index,
      x: item.longitude,
      y: item.latitude
    })),
    priority: 'RECOMMEND',
    car_fuel: 'GASOLINE',
    car_hipass: false,
    alternatives: false,
    road_details: false
  }

  try {
    const res = await axios.post(URL, wayBody, {
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'KakaoAK ' + REST_API_KEY
      }
    })

    distance.value = 0
    latLngList.value = []
    markerList.value = []

    res.data.routes[0].sections.forEach((e) => {
      distance.value += e.distance
      e.guides.forEach((e) => {
        if (e.name === '') return
        if (e.name === '출발지' || e.name === '경유지' || e.name === '목적지') {
          markerList.value.push({
            lat: e.y,
            lng: e.x,
            name: e.name,
            visible: false
          })
        }
      })
    })

    lat.value = res.data.routes[0].sections[0].guides[0].y
    lng.value = res.data.routes[0].sections[0].guides[0].x

    setBounds()
    loading.value = false
    emit('loading', false)

    latLngList.value = res.data.routes[0].sections.map((section) => {
      return section.guides.map((guide) => {
        return {
          lat: guide.y,
          lng: guide.x
        }
      })
    })

    return latLngList.value
  } catch (error) {
    console.error('에러' + error)
  }
}

const map = ref()
let bounds

const onLoadKakaoMap = (mapRef) => {
  map.value = mapRef
  setBounds()
}

const setBounds = () => {
  if (map.value !== undefined) {
    // eslint-disable-next-line no-undef
    bounds = new kakao.maps.LatLngBounds()
    markerList.value.forEach((markerInfo) => {
      // eslint-disable-next-line no-undef
      const point = new kakao.maps.LatLng(markerInfo.lat, markerInfo.lng)
      // eslint-disable-next-line no-undef
      // const marker = new kakao.maps.Marker({ position: point })
      // marker.setMap(map.value)
      bounds.extend(point)
      // mapMarkers.value.push(marker)
    })
    map.value.setBounds(bounds)
  }
}

watch([latLngList, markerList], () => {
  if (map.value !== undefined) {
    setBounds()
  }
})

watch(
  () => [...props.wishList],
  async () => {
    console.log('wishList 변경')
    await getKakaoMap()
  },
  { deep: true }
)

onMounted(async () => {
  await getKakaoMap()
})
</script>

<template>
  <div class="mt-[56px]">
    <div v-if="distance > 1000" class="flex justify-between mb-1">
      <div v-for="(item, index) in latLngList" :key="index" class="flex justify-center items-center">
        <div
          class="text-white bg-mycolor hover:bg-mycolor-hover focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800"
          @click="roadIdxChg(index)">
          {{ index + 1 }}번째 경로
        </div>
      </div>
      <div class="text-[30px]">거리: {{ distance / 1000 }}km</div>
    </div>
    <div v-else class="flex justify-between mb-1">
      <div class="text-[30px]">거리: {{ distance }}m</div>
    </div>
    <div v-if="!loading">
      <KakaoMap :lat="lat" :lng="lng" @onLoadKakaoMap="onLoadKakaoMap" class="rounded-xl" width="1080" height="1031">
        <KakaoMapMarker v-for="item in markerList" :image="{
          imageSrc: `/src/assets/marker/mycolor.svg`,
          imageWidth: 40,
          imageHeight: 40,
          imageOption: {}
        }" :key="item.name" :lat="item.lat" :lng="item.lng" :clickable="true" :zIndex="5"
          @onClickKakaoMapMarker="onClickKakaoMapMarker(item)" />
        <KakaoMapCustomOverlay v-for="item in markerList" :key="item.name" :lat="item.lat" :lng="item.lng"
          :content="content(item.name)" :visible="item.visible" :yAnchor="1.4" />
        <div v-for="(item, index) in latLngList" :key="index">
          <KakaoMapPolyline v-if="index === roadIdx" :latLngList="item" strokeWeight="6" strokeColor="#63adf2"
            strokeOpacity="0.9" strokeStyle="solid" />
          <KakaoMapPolyline v-else :latLngList="item" strokeWeight="6" strokeColor="#63adf2" strokeOpacity="0.9"
            strokeStyle="shortdot">
          </KakaoMapPolyline>
        </div>
      </KakaoMap>
    </div>
    <div v-else>
      <!-- 로딩 중일 때 표시할 내용 -->
      <div role="status">
        <svg aria-hidden="true" class="w-8 h-8 text-gray-200 animate-spin dark:text-gray-600 fill-blue-600"
          viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path
            d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
            fill="currentColor" />
          <path
            d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
            fill="currentFill" />
        </svg>
        <span class="sr-only">Loading...</span>
      </div>
    </div>
  </div>
</template>
