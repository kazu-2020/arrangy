<template>
  <v-app>
    <v-main class="base-color">
      <NotFound v-if="responseStatus === 404" key="not-found" />
      <ServerError v-else-if="responseStatus === 500" key="server-error" />
      <template v-else>
        <router-view name="header" />
        <router-view name="snackbar" />
        <router-view class="py-15" />
        <router-view name="footer" />
      </template>
    </v-main>
  </v-app>
</template>

<script>
import NotFound from './components/pages/error/NotFound';
import ServerError from './components/pages/error/ServerError';
import { mapGetters } from 'vuex';

export default {
  components: {
    NotFound,
    ServerError,
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
