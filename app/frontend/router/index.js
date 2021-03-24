import Vue from 'vue';
import VueRouter from 'vue-router';
import store from '../store/index';

import TopPage from '../components/pages/TopPage.vue';
import Arrangements from '../components/pages/Arrangements.vue';
import ArrangementNew from '../components/pages/ArrangementNew.vue';
import ArrangementShow from '../components/pages/ArrangementShow.vue';
import UserProfile from '../components/pages/UserProfile.vue';
import UserRegister from '../components/pages/UserRegister.vue';
import UserLogin from '../components/pages/UserLogin.vue';

Vue.use(VueRouter);

const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'TopPage',
      component: TopPage,
    },
    {
      path: '/register',
      name: 'UserRegister',
      component: UserRegister,
    },
    {
      path: '/login',
      name: 'UserLogin',
      component: UserLogin,
    },
    {
      path: '/profile',
      name: 'UserProfile',
      component: UserProfile,
      meta: { requireAuth: true },
    },
    {
      path: '/arrangements',
      component: Arrangements,
      children: [
        {
          path: 'new',
          name: 'ArrangementNew',
          component: ArrangementNew,
          meta: { requireAuth: true },
        },
        {
          path: ':id',
          name: 'ArrangementShow',
          component: ArrangementShow,
          meta: { requireAuth: true },
        },
      ],
    },
  ],
});

router.beforeEach((to, from, next) => {
  if (to.matched.some((record) => record.meta.requireAuth)) {
    store.dispatch('users/fetchAuthUser').then((authUser) => {
      if (to.name === 'ArrangementShow' || authUser) {
        next();
      } else {
        next({ name: 'UserLogin' });
      }
    });
  } else {
    next();
  }
});

export default router;
