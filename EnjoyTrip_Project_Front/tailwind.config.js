/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}', './node_modules/flowbite/**/*.js'],
  theme: {
    colors: {
      mycolor: '#83b5d1',
      'mycolor-hover': '#7698b3'
    },
    extend: {}
  },
  plugins: [require('flowbite/plugin')]
}
