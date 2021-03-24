<template>
  <div>
    <v-app-bar id="page-header" fixed height="60" elevation="1" class="px-10" color="#FAFAFA">
      <v-toolbar-title>
        <router-link class="router-link text-h4" style="color: #ff5252" :to="{ name: 'TopPage' }">
          ARRANGY
        </router-link>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <template v-if="authUser">
        <v-btn plain text xLarge :to="{ name: 'ArrangementNew' }">新規投稿</v-btn>
        <v-menu bottom rounded offsetY>
          <template #activator="{ on }">
            <v-btn icon xLarge v-on="on">
              <v-avatar>
                <img id="header-avatar" :src="authUser.avatar" />
              </v-avatar>
            </v-btn>
          </template>
          <v-list id="header-menu-list" dense flat>
            <v-list-item text plain :to="{ name: 'UserProfile' }">マイページ</v-list-item>
            <v-list-item text>お気に入り一覧</v-list-item>
            <v-list-item id="header-logout-button" text @click="logoutFunction">
              ログアウト
            </v-list-item>
          </v-list>
        </v-menu>
      </template>
      <template v-else>
        <v-btn class="hidden-sm-and-down" plain text xLarge :to="{ name: 'UserRegister' }">
          新規登録
        </v-btn>
        <v-btn plain text xLarge :to="{ name: 'UserLogin' }"> ログイン </v-btn>
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
          this.fetchSnackbarData({
            msg: 'ログアウトしました',
            color: 'success',
            isShow: true,
          });
          this.$router.go();
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
