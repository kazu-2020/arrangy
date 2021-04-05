import Vue from 'vue';
import VueRouter from 'vue-router';
import store from '../store/index';

Vue.use(VueRouter);

const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'TopPage',
      component: () => import('../components/pages/TopPage'),
    },
    {
      path: '/register',
      name: 'UserRegister',
      component: () => import('../components/pages/UserRegister'),
    },
    {
      path: '/login',
      name: 'UserLogin',
      component: () => import('../components/pages/UserLogin'),
    },
    {
      path: '/profile',
      name: 'UserProfile',
      component: () => import('../components/pages/UserProfile'),
      meta: { requireAuth: true },
    },
    {
      path: '/arrangements',
      component: () => import('../components/pages/Arrangements'),
      children: [
        {
          path: 'new',
          name: 'ArrangementNew',
          component: () => import('../components/pages/ArrangementNew'),
          meta: { requireAuth: true },
        },
        {
          path: ':id',
          name: 'ArrangementShow',
          component: () => import('../components/pages/ArrangementShow.vue'),
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
