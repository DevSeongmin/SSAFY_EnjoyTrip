import axios from 'axios'

const client = axios.create({
  baseURL: 'http://localhost/',
  // baseURL: 'http://192.168.28.55/',

  headers: {
    'Content-Type': 'application/json'
  },
  withCredentials: true
})

export default client
