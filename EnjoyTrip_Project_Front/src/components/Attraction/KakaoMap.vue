<script setup>
import { KakaoMap, KakaoMapMarker } from 'vue3-kakao-maps'
import { defineProps, ref } from 'vue'
import regionData from '@/api/regionData'

const props = defineProps({
  lat: Number,
  lon: Number,
  sidoCode: Number,
  gugunCode: Number
})

const lat = ref(props.lat)
const lng = ref(props.lon)

//라이브러리 사용 방법을 반드시 참고하여 주시기 바랍니다.
const map = ref()
const markerList = ref([])
const colorMap = {
  전기차충전소: 'yellow',
  주유소: 'orange',
  주차장: 'red',
  맛집: 'purple',
  병원: 'green'
}
const markerColor = ref('')

const type = ref()

const show = (mapRef) => {
  markerColor.value = colorMap[mapRef]
  type.value = mapRef
  map.value = mapRef

  markerList.value = []

  // 장소 검색 객체를 생성합니다
  const ps = new kakao.maps.services.Places()
  // 키워드로 장소를 검색합니다
  ps.keywordSearch(
    regionData[props.sidoCode]['name'] +
    ' ' +
    regionData[props.sidoCode]['children'][props.gugunCode]['name'] +
    ' ' +
    mapRef,
    placesSearchCB
  )
}

// 키워드 검색 완료 시 호출되는 콜백함수 입니다
const placesSearchCB = (data, status) => {
  if (status === kakao.maps.services.Status.OK) {
    // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
    // LatLngBounds 객체에 좌표를 추가합니다

    for (let marker of data) {
      const markerItem = {
        lat: marker.y,
        lng: marker.x,
        infoWindow: {
          content: marker.place_name,
          visible: false
        }
      }
      markerList.value.push(markerItem)
    }
  }
}

//마커 클릭 시 인포윈도우의 visible 값을 반전시킵니다
const onClickMapMarker = (markerItem) => {
  if (markerItem.infoWindow?.visible !== null && markerItem.infoWindow?.visible !== undefined) {
    markerItem.infoWindow.visible = !markerItem.infoWindow.visible
  } else {
    markerItem.infoWindow.visible = true
  }
}
</script>

<template>
  <div class="flex-row mt-5">
    <label class="block mb-1" for="visit-type">
      <h1 class='text-2xl my-3'>주변 시설 검색</h1>
    </label>
    <div class="flex space-x-2">
      <button @click.prevent="show('전기차충전소')"
        :class="{ 'border-black bg-yellow-200 border-yellow-200': type === '전기차충전소' }"
        class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-yellow-200 h-10 px-4 py-2 border-2">
        전기차충전소
      </button>
      <button @click.prevent="show('주유소')" :class="{ 'border-black bg-orange-400 border-orange-400': type === '주유소' }"
        class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-orange-200 h-10 px-4 py-2 border-2">
        주유소
      </button>
      <button @click.prevent="show('주차장')" :class="{ 'border-black bg-red-500 border-red-500': type === '주차장' }"
        class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-red-200 h-10 px-4 py-2 border-2">
        주차장
      </button>
      <button @click.prevent="show('맛집')" :class="{ 'border-black bg-purple-400 border-purple-400': type === '맛집' }"
        class="inline-flex items-center justify-center type-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-purple-200 h-10 px-4 py-2 border-2">
        맛집
      </button>
      <button @click.prevent="show('병원')" :class="{ 'border-black bg-green-500 border-green-500': type === '병원' }"
        class="inline-flex items-center justify-center whitespace-nowrap rounded-3xl text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border-input bg-background hover:bg-accent hover:text-accent-foreground hover:bg-green-200 h-10 px-4 py-2 border-2">
        병원
      </button>
    </div>

    <KakaoMap :lat="lat" :lng="lng" :draggable="true" width="80rem" height="30rem" level="2" class="mt-5">
      <KakaoMapMarker v-for="(marker, index) in markerList" :key="marker.key === undefined ? index : marker.key" :image="{
        imageSrc: `/src/assets/marker/${markerColor}.svg`,
        imageWidth: 32,
        imageHeight: 32,
        imageOption: {}
      }" :lat="marker.lat" :lng="marker.lng" :infoWindow="marker.infoWindow" :clickable="true"
        @onClickKakaoMapMarker="onClickMapMarker(marker)" />
      <KakaoMapMarker :lat="lat" :lng="lng"></KakaoMapMarker>
    </KakaoMap>
  </div>
</template>

<style scoped></style>
