import Vue from 'vue';
import VueRouter from 'vue-router';
import ArrangementsIndex from '../components/pages/ArrangementsIndex.vue';
import UserRegister from '../components/pages/UserRegister.vue';
import UserLogin from '../components/pages/UserLogin.vue';

Vue.use(VueRouter);

const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: ArrangementsIndex,
      name: 'TopPage',
    },
    {
      path: '/register',
      component: UserRegister,
      name: 'UserRegister',
    },
    {
      path: '/login',
      component: UserLogin,
      name: 'UserLogin',
    },
  ],
});

export default router;
