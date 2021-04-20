<template>
  <v-app>
    <v-main class="base-color">
      <template v-if="responseState.state === 'error'">
        <NotFound v-if="responseState.status === 404" />
        <ServerError v-else-if="responseState.status === 500" />
      </template>
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
  computed: {
    ...mapGetters('responseState', ['responseState']),
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

.base-color {
  background-color: #eeeeee;
}
</style>
