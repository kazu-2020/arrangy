<template>
  <v-app>
    <TheHeader />
    <v-main class="py-15 base-color">
      <TheSnackbar />
      <template v-if="responseStatus === 404">
        <NotFound />
      </template>
      <template v-else>
        <router-view />
      </template>
    </v-main>
    <TheFooter />
  </v-app>
</template>

<script>
import TheHeader from './components/global/TheHeader.vue';
import TheFooter from './components/global/TheFooter.vue';
import TheSnackbar from './components/global/TheSnackbar.vue';
import NotFound from './components/pages/error/NotFound';
import { mapGetters } from 'vuex';

export default {
  components: {
    TheHeader,
    TheFooter,
    TheSnackbar,
    NotFound,
  },
  head: {
    title() {
      return {
        inner: 'Arrangy(アレンジー)',
        separator: '|',
        complement: 'コンビニ商品や外食店の料理を使用したアレンジ飯の共有サービス',
      };
    },
    meta() {
      return [
        {
          name: 'viewport',
          content: 'width=device-width, initial-scale=1',
        },
        {
          name: 'twitter:card',
          content: 'summary',
        },
        {
          name: 'twitter:site',
          content: '@Arrangy1',
        },
      ];
    },
    link() {
      return [{ rel: 'shortcut icon', type: 'image/x-icon', href: '/images/favicon.ico' }];
    },
  },
  computed: {
    ...mapGetters('status', ['responseStatus']),
  },
};
</script>

<style>
@media screen and (min-width: 650px) {
  .br-pc {
    display: block;
  }
  .br-sp {
    display: none;
  }
}

@media screen and (max-width: 650px) {
  .br-pc {
    display: none;
  }
  .br-sp {
    display: block;
  }
}

.router-link {
  text-decoration: none;
}

.or-avatar {
  border: solid;
}

.base-color {
  background-color: #eeeeee;
}
</style>
