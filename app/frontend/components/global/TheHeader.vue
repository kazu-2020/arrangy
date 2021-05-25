<template>
  <div>
    <v-app-bar id="page-header" fixed height="60" elevation="1" class="px-md-10" color="#FAFAFA">
      <v-toolbar-title class="logo">
        <router-link :to="{ name: 'TopPage' }">
          <v-img src="/images/header-logo.png" />
        </router-link>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <template v-if="authUser">
        <InitializedMenu :bottom="true" :offsetY="true">
          <template #btn-text>
            <v-avatar>
              <img id="header-avatar" :src="authUser.avatar_url" />
            </v-avatar>
          </template>
          <template #list>
            <v-list id="header-menu-list" dense flat>
              <v-list-item plain :to="{ name: 'ArrangementNew' }">新規投稿</v-list-item>
              <v-list-item plain :to="{ name: 'UserProfile' }">マイページ</v-list-item>
              <v-list-item plain :to="{ name: 'Favorites' }">お気に入り一覧</v-list-item>
              <v-list-item plain tag="button" @click="logoutFunction"> ログアウト </v-list-item>
            </v-list>
          </template>
        </InitializedMenu>
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
import InitializedMenu from '../parts/menus/InitializedMenu';

export default {
  components: {
    InitializedMenu,
  },
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
          if (
            this.$router.currentRoute.name !== 'ArrangementShow' &&
            this.$router.currentRoute.meta.requireAuth
          ) {
            this.$router.push({ name: 'UserLogin' });
          }
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

<style scoped>
.logo {
  cursor: pointer;
}
</style>
