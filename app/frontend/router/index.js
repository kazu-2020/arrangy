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
      components: {
        default: () => import('../components/pages/TopPage'),
        header: () => import('../components/global/TheHeader'),
        snackbar: () => import('../components/global/TheSnackbar.vue'),
        footer: () => import('../components/global/TheFooter'),
      },
    },
    {
      path: '/register',
      name: 'UserRegister',
      components: {
        default: () => import('../components/pages/RegisterPage'),
        header: () => import('../components/global/TheHeader'),
        snackbar: () => import('../components/global/TheSnackbar.vue'),
        footer: () => import('../components/global/TheFooter'),
      },
    },
    {
      path: '/login',
      name: 'UserLogin',
      components: {
        default: () => import('../components/pages/LoginPage'),
        header: () => import('../components/global/TheHeader'),
        snackbar: () => import('../components/global/TheSnackbar.vue'),
        footer: () => import('../components/global/TheFooter'),
      },
    },
    {
      path: '/profile',
      components: {
        default: () => import('../components/pages/Profile/RootPage'),
        header: () => import('../components/global/TheHeader'),
        snackbar: () => import('../components/global/TheSnackbar.vue'),
        footer: () => import('../components/global/TheFooter'),
      },
      children: [
        {
          path: '/',
          name: 'UserProfile',
          component: () => import('../components/pages/Profile/Mine'),
          meta: { requireAuth: true },
        },
        {
          path: 'favorites',
          name: 'Favorites',
          component: () => import('../components/pages/Profile/Favorites'),
          meta: { requireAuth: true },
        },
      ],
    },
    {
      path: '/arrangements',
      components: {
        default: () => import('../components/pages/Arrangements/RootPage'),
        header: () => import('../components/global/TheHeader'),
        snackbar: () => import('../components/global/TheSnackbar.vue'),
        footer: () => import('../components/global/TheFooter'),
      },
      children: [
        {
          path: 'new',
          name: 'ArrangementNew',
          meta: { requireAuth: true },
          component: () => import('../components/pages/Arrangements/New'),
        },
        {
          path: ':id',
          name: 'ArrangementShow',
          component: () => import('../components/pages/Arrangements/Show'),
        },
      ],
    },
    {
      path: '/terms',
      name: 'TermsPage',
      components: {
        default: () => import('../components/pages/TermsPage'),
        header: () => import('../components/global/TheHeader'),
        footer: () => import('../components/global/TheFooter'),
      },
    },
    {
      path: '*',
      name: '404Page',
      component: () => import('../components/pages/error/NotFound.vue'),
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
