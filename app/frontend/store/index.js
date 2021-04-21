import Vue from 'vue';
import Vuex from 'vuex';
import adminUsers from './modules/adminUsers';
import users from './modules/users';
import snackbars from './modules/snackbars';
import responseState from './modules/responseState';

Vue.use(Vuex);

export default new Vuex.Store({
  // eslint-disable-next-line no-undef
  strict: process.env.NODE_ENV !== 'production',
  modules: {
    adminUsers,
    users,
    responseState,
    snackbars,
  },
});
