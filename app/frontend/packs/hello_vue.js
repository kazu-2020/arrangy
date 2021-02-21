import Vue from 'vue';
import App from '../app.vue';
import router from '../router/index'
import { axiosInstance } from '../plugins/axios'

Vue.prototype.$axios = axiosInstance;

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    router,
    render: (h) => h(App),
  }).$mount();
  document.body.appendChild(app.$el);
});
