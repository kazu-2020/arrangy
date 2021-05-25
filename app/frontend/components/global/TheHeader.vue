<template>
  <div>
    <v-app-bar id="page-header" class="px-md-10" app flat clippedRight color="#FAFAFA">
      <v-app-bar-nav-icon
        id="navigation-icon"
        class="hidden-lg-and-up"
        @click="drawer = true"
      ></v-app-bar-nav-icon>
      <v-toolbar-title style="cursor: pointer">
        <router-link :to="{ name: 'TopPage' }">
          <v-img class="hidden-sm-and-down" src="/images/header-logo.png" />
          <v-img class="hidden-md-and-up" src="/images/mobile-header-logo.png" />
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

    <!-- drower -->
    <v-navigation-drawer v-model="drawer" app clipped right color="#FAFAFA">
      <v-list
        id="navigation-menu"
        class="d-flex flex-column justify-space-between"
        nav
        dense
        height="100%"
      >
        <v-list-item-group>
          <v-list-item :to="{ name: 'TopPage' }" exact>
            <v-list-item-icon>
              <v-icon>mdi-home</v-icon>
            </v-list-item-icon>
            <v-list-item-title>ホーム</v-list-item-title>
          </v-list-item>

          <v-list-item :to="{ name: 'ArrangementNew' }">
            <v-list-item-icon>
              <v-icon>mdi-clipboard-edit</v-icon>
            </v-list-item-icon>
            <v-list-item-title>新規投稿</v-list-item-title>
          </v-list-item>
        </v-list-item-group>

        <v-list-item-group>
          <v-divider />

          <v-list-item :to="{ name: 'TermsPage' }">
            <v-list-item-icon />
            <v-list-item-title>利用規約</v-list-item-title>
          </v-list-item>

          <v-list-item :to="{ name: 'PrivacyPolicy' }">
            <v-list-item-icon />
            <v-list-item-title>プライバシーポリシー</v-list-item-title>
          </v-list-item>

          <v-list-item :to="{ name: 'ContactPage' }">
            <v-list-item-icon />
            <v-list-item-title>お問い合せ</v-list-item-title>
          </v-list-item>

          <v-divider />

          <v-list-item :to="{ name: 'ServiceDescription' }">
            <v-list-item-icon>
              <v-img src="/images/sidebar-logo.png" />
            </v-list-item-icon>

            <v-list-item-title>Arrangyとは</v-list-item-title>
          </v-list-item>

          <v-list-item href="https://twitter.com/Arrangy1">
            <v-list-item-icon>
              <v-icon color="#1DA1F2">mdi-twitter</v-icon>
            </v-list-item-icon>
            <v-list-item-title>公式アカウント</v-list-item-title>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>
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
      drawer: null,
    };
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
