<template>
  <div>
    <v-app-bar
      v-if="isCreated"
      id="page-header"
      fixed
      height="60"
      elevation="1"
      class="px-10"
      color="#FAFAFA"
    >
      <v-toolbar-title>
        <router-link class="router-link text-h4" style="color: #ff5252" :to="{ name: 'TopPage' }">
          ARRANGY
        </router-link>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <template v-if="authUser">
        <InitializedMenu :bottom="true" :offsetY="true">
          <template #btn-text>
            <v-avatar>
              <img id="header-avatar" :src="authUser.avatar" />
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
  data() {
    return {
      isCreated: false,
    };
  },
  computed: {
    ...mapGetters('users', ['authUser']),
  },
  watch: {
    authUser() {
      this.isCreated = true;
    },
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
