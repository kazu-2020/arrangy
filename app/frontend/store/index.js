import Vue from 'vue';
import Vuex from 'vuex';
import users from './modules/users';
import snackbars from './modules/snackbars';
import status from './modules/status';

Vue.use(Vuex);

export default new Vuex.Store({
  // eslint-disable-next-line no-undef
  strict: process.env.NODE_ENV !== 'production',
  modules: {
    users,
    snackbars,
    status,
  },
});
