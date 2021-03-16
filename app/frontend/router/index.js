import Vue from 'vue';
import VueRouter from 'vue-router';
import store from '../store/index';

import TopPage from '../components/pages/TopPage.vue';
import ArrangementNew from '../components/pages/ArrangementNew.vue';
import UserProfile from '../components/pages/UserProfile.vue';
import UserRegister from '../components/pages/UserRegister.vue';
import UserLogin from '../components/pages/UserLogin.vue';

Vue.use(VueRouter);

const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: TopPage,
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
    {
      path: '/profile',
      component: UserProfile,
      name: 'UserProfile',
      meta: { requireAuth: true },
    },
    {
      path: '/arrangements/new',
      component: ArrangementNew,
      name: 'ArrangementNew',
      meta: { requireAuth: true },
    },
  ],
});

router.beforeEach((to, from, next) => {
  if (to.matched.some((record) => record.meta.requireAuth)) {
    store.dispatch('users/fetchAuthUser').then((authUser) => {
      if (!authUser) {
        next({ name: 'UserLogin' });
      } else {
        next();
      }
    });
  } else {
    next();
  }
});

export default router;
