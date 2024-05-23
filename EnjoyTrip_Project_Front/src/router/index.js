import { createRouter, createWebHistory } from 'vue-router'
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('@/views/MainView.vue')
    },
    {
      path: '/search',
      name: 'search',
      component: () => import('@/views/SearchView.vue'),
      props: true
    },
    {
      path: '/detail',
      name: 'detail',
      component: () => import('@/components/Attraction/AttractionDetail.vue'),
      props: true
    },
    {
      path: '/review',
      name: 'review',
      component: () => import('@/components/Review/ReviewWriteView.vue'),
      props: true
    },
    {
      path: '/board/:boardId',
      name: 'boardDetailView',
      component: () => import('@/views/board/BoardDetailView.vue')
    },
    {
      path: '/board',
      name: 'board',
      component: () => import('@/views/board/BoardListView.vue')
    },
    {
      path: '/board/wirte',
      name: 'boardWrite',
      component: () => import('@/views/board/BoardWriteView.vue')
    },

    {
      path: '/board/:boardId',
      name: 'boardModify',
      component: () => import('@/views/board/BoardModifyView.vue')
    },

    {
      path: '/wish',
      name: 'wishList',
      component: () => import('@/views/WishView.vue')
    }
  ]
})

export default router
