import Vue from 'vue';
import VueHead from 'vue-head';
import VueCropper from 'vue-cropperjs';
import VueAwesomeSwiper from 'vue-awesome-swiper';
import 'swiper/css/swiper.css';
import vuetify from '../plugins/vuetify';
import App from '../app.vue';
import store from '../store/index';
import router from '../router/index';
import * as veeValidate from '../plugins/vee-validate';
import devour from '../plugins/devour';
import InfiniteLoading from 'vue-infinite-loading';
import { VueLoading } from 'vue-loading-template';

import 'cropperjs/dist/cropper.css';

Vue.prototype.$devour = devour;
Vue.use(InfiniteLoading);
Vue.use(VueHead);
Vue.use(VueAwesomeSwiper);
Vue.component('VueCropper', VueCropper);
Vue.component('VueLoading', VueLoading);

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
