<template>
  <v-app>
    <TheHeader />
    <v-main class="py-15">
      <TheSnackbar />
      <router-view />
    </v-main>
    <TheFooter />
  </v-app>
</template>

<script>
import TheHeader from './components/global/TheHeader.vue';
import TheFooter from './components/global/TheFooter.vue';
import TheSnackbar from './components/global/TheSnackbar.vue';
export default {
  components: {
    TheHeader,
    TheFooter,
    TheSnackbar,
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
</style>
