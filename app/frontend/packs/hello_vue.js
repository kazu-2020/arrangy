import Vue from 'vue';
import App from '../app.vue';
import vuetify from '../plugins/vuetify'
import router from '../router/index'
import * as VeeValidate from '../plugins/vee-validate'
import axiosInstance from '../plugins/axios'

Vue.prototype.$axios = axiosInstance;

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    vuetify,
    router,
    VeeValidate,
    render: (h) => h(App),
  }).$mount();
  document.body.appendChild(app.$el);
});
