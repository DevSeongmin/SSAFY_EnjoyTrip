<script setup>
import { ref, onMounted, defineProps } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'

const route = useRoute()

const API_KEY = import.meta.env.VITE_WEATHER_API_KEY

let latt = ref(null)
let lonn = ref(null)

const props = defineProps({
  lat: {
    type: Number,
    required: true
  },
  lon: {
    type: Number,
    required: true
  }
})
latt.value = props.lat
lonn.value = props.lon

const weather = ref('')
const temp = ref('')

const iconURL = ref('')

const getWeather = async () => {
  console.log('날씨')
  console.log(latt, lonn)
  await axios
    .get(
      `https://api.openweathermap.org/data/2.5/weather?lat=${latt.value}&lon=${lonn.value}&appid=${API_KEY}&units=metric&lang=kr`
    )
    .then((response) => {
      weather.value = response.data.weather[0].description
      temp.value = response.data.main.temp

      const icon = response.data.weather[0].icon
      iconURL.value = `http://openweathermap.org/img/wn/${icon}@2x.png`
    })
    .catch((error) => {
      console.log(error)
    })
}

onMounted(async () => {
  if (route.path !== '/') {
    await getWeather()
  }
})
</script>

<template>
  <div class="flex z-50 justify-end items-center">
    {{ weather }}
    {{ temp }}
    <img :src="iconURL" width="50px" />
  </div>
</template>

<style scoped></style>
