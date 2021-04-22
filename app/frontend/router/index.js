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
      components: {
        default: () => import('../components/pages/TermsPage'),
        header: () => import('../components/global/TheHeader'),
        footer: () => import('../components/global/TheFooter'),
      },
    },
    {
      path: '/about',
      name: 'ServiceDescription',
      components: {
        default: () => import('../components/pages/ServiceDescription'),
        header: () => import('../components/global/TheHeader'),
        footer: () => import('../components/global/TheFooter'),
      },
    },
    {
      path: '/contact',
      name: 'ContactPage',
      components: {
        default: () => import('../components/pages/ContactPage'),
        header: () => import('../components/global/TheHeader'),
        snackbar: () => import('../components/global/TheSnackbar.vue'),
        footer: () => import('../components/global/TheFooter'),
      },
    },
    {
      path: '/admin/login',
      name: 'AdminLogin',
      components: {
        default: () => import('../components/pages/admin/AdminLogin'),
        snackbar: () => import('../components/global/TheSnackbar.vue'),
      },
    },
    {
      path: '/admin/users',
      name: 'AdminUsers',
      components: {
        default: () => import('../components/pages/admin/AdminUsers'),
        header: () => import('../components/global/admin/AdminHeader'),
        snackbar: () => import('../components/global/TheSnackbar.vue'),
      },
      meta: { requireAdmin: true },
    },
    {
      path: '/admin/arrangements',
      name: 'AdminArrangements',
      components: {
        default: () => import('../components/pages/admin/AdminArrangements'),
        header: () => import('../components/global/admin/AdminHeader'),
        snackbar: () => import('../components/global/TheSnackbar.vue'),
      },
      meta: { requireAdmin: true },
    },
    {
      path: '*',
      name: '404Page',
      component: () => import('../components/pages/error/NotFound.vue'),
    },
  ],
  scrollBehavior() {
    return { x: 0, y: 0 };
  },
});

router.beforeEach((to, from, next) => {
  if (to.matched.some((record) => record.meta.requireAuth)) {
    const authUser = store.getters['users/authUser'];

    if (authUser) return next();

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

router.beforeEach((to, from, next) => {
  if (to.matched.some((record) => record.meta.requireAdmin)) {
    store.dispatch('adminUsers/fetchAdminUser').then((adminUser) => {
      if (adminUser && adminUser.role === 'admin') {
        next();
      } else {
        next({ name: 'AdminLogin' });
      }
    });
  } else {
    next();
  }
});

export default router;
