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
      component: () => import('../components/pages/Top/Index'),
    },
    {
      path: '/register',
      name: 'UserRegister',
      component: () => import('../components/pages/Register/Index'),
    },
    {
      path: '/login',
      name: 'UserLogin',
      component: () => import('../components/pages/Login/Index'),
    },
    {
      path: '/profile',
      component: () => import('../components/pages/Profile/Index'),
      meta: { requireAuth: true },
      children: [
        {
          path: '/',
          name: 'UserProfile',
          component: () => import('../components/pages/Profile/Mine'),
        },
        {
          path: 'favorites',
          name: 'Favorites',
          component: () => import('../components/pages/Profile/Favorites'),
        },
      ],
    },
    {
      path: '/arrangements',
      component: () => import('../components/pages/Arrangements/Index'),
      children: [
        {
          path: 'new',
          name: 'ArrangementNew',
          component: () => import('../components/pages/Arrangements/New'),
          meta: { requireAuth: true },
        },
        {
          path: ':id',
          name: 'ArrangementShow',
          component: () => import('../components/pages/Arrangements/Show'),
          meta: { requireAuth: true },
        },
      ],
    },
    {
      path: '/terms',
      name: 'TermsPage',
      component: () => import('../components/pages/TermsPage'),
    },
    {
      path: '*',
      component: () => import('../components/pages/error/404Page.vue'),
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
