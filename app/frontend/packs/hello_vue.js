import Vue from 'vue';
import App from '../app.vue';
import store from '../store/index';
import router from '../router/index';
import vuetify from '../plugins/vuetify';
import * as veeValidate from '../plugins/vee-validate';
import axiosInstance from '../plugins/axios';
import devour from '../plugins/devour';

Vue.prototype.$axios = axiosInstance;
Vue.prototype.$devour = devour;

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    store,
    router,
    vuetify,
    veeValidate,
    render: (h) => h(App),
  }).$mount();
  document.body.appendChild(app.$el);
});
