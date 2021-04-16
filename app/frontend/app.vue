<template>
  <v-app>
    <router-view v-if="responseState.state !== 'error'" name="header" />
    <v-main class="base-color">
      <NotFound v-if="responseState.status === 404" />
      <ServerError v-else-if="responseState.status === 500" />
      <template v-else>
        <router-view name="snackbar" />
        <router-view class="py-15" />
      </template>
    </v-main>
    <router-view v-if="responseState.state !== 'error'" name="footer" />
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

.or-avatar {
  border: solid;
}

.base-color {
  background-color: #eeeeee;
}
</style>
