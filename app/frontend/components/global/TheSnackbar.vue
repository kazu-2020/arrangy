<template>
  <v-snackbar
    id="global-snackbar"
    v-model="isVisiable"
    timeout="3000"
    left
    :color="snackbarData.color"
    transition="scale-transition"
  >
    <v-icon>{{ snackbarIcon }}</v-icon>
    {{ snackbarData.msg }}
  </v-snackbar>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
export default {
  computed: {
    ...mapGetters('snackbars', ['snackbarData']),
    isVisiable: {
      get() {
        return this.snackbarData.isShow;
      },
      set() {
        return this.fetchSnackbarData({ msg: '', color: '', isShow: false });
      },
    },
    snackbarIcon: function () {
      switch (this.snackbarData.color) {
        case 'success':
          return 'mdi-check-circle-outline';
        case 'error':
          return 'mdi-information-outline';
        default:
          return '';
      }
    },
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
  },
};
</script>
