import Vue from 'vue';
import App from '../app.vue';
import store from '../store/index';
import router from '../router/index';
import VueHead from 'vue-head';
import vuetify from '../plugins/vuetify';
import * as veeValidate from '../plugins/vee-validate';
import devour from '../plugins/devour';
import InfiniteLoading from 'vue-infinite-loading';

Vue.prototype.$devour = devour;
Vue.use(InfiniteLoading);
Vue.use(VueHead);

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
