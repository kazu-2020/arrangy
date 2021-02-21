import Vue from 'vue'
import VueRouter from 'vue-router'
import UserRegister from '../components/pages/UserRegister.vue'

Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/register',
      component: UserRegister,
      name: 'UserRegister'
    }
  ]
})

export default router