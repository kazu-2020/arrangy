<template>
  <div>
    <v-app-bar fixed height="60" elevation="1" color="grey lighten-5">
      <v-toolbar-title>
        <router-link class="router-link text-h4" style="color: #d32f2f" :to="{ name: 'TopPage' }">
          ARRANGY
        </router-link>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <template v-if="!!authUser">
        <v-btn text>マイページ</v-btn>
        <v-btn text :to="{ name: 'ArrangementNew' }">新規投稿</v-btn>
        <v-btn text>お気に入り一覧</v-btn>
        <v-btn text rounded plain :ripple="{ center: true }" x-large @click="logoutFunction">
          ログアウト
        </v-btn>
      </template>
      <template v-else>
        <v-btn :to="{ name: 'UserRegister' }" text rounded plain :ripple="{ center: true }" x-large>
          新規登録
        </v-btn>
        <v-btn
          class="hidden-sm-and-down"
          :to="{ name: 'UserLogin' }"
          text
          rounded
          plain
          :ripple="{ center: true }"
          x-large
        >
          ログイン
        </v-btn>
      </template>
    </v-app-bar>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
export default {
  computed: {
    ...mapGetters('users', ['authUser']),
  },
  methods: {
    ...mapActions('users', ['logoutUser']),
    ...mapActions('snackbars', ['fetchSnackbarData']),
    logoutFunction() {
      this.logoutUser().then((res) => {
        if (res) {
          this.$router.go({ path: this.$router.currentRoute.path });
          this.fetchSnackbarData({
            msg: 'ログアウトしました',
            color: 'success',
            isShow: true,
          });
        } else {
          this.fetchSnackbarData({
            msg: 'ログアウトに失敗しました',
            color: 'error',
            isShow: true,
          });
        }
      });
    },
  },
};
</script>
