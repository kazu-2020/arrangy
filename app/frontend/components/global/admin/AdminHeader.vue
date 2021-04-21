<template>
  <div>
    <v-app-bar id="page-header" fixed height="60" elevation="1" class="px-md-10" color="#FAFAFA">
      <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title> 管理画面 </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn text outlined @click="handleLogout">ログアウト</v-btn>
    </v-app-bar>

    <v-navigation-drawer v-model="drawer" temporary absolute>
      <v-list nav dense>
        <v-list-item-group v-model="group">
          <v-list-item class="px-2">
            <v-list-item-avatar>
              <v-img :src="adminUser.avatar" />
            </v-list-item-avatar>
          </v-list-item>
          <v-list-item link>
            <v-list-item-content>
              <v-list-item-title class="title"> {{ adminUser.nickname }} </v-list-item-title>
              <v-list-item-subtitle>{{ adminUser.email }}</v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
          <v-divider class="mb-5" />

          <v-list-item :to="{ name: 'AdminUsers' }">
            <v-list-item-icon>
              <v-icon>mdi-account-multiple</v-icon>
            </v-list-item-icon>
            <v-list-item-title>ユーザー一覧</v-list-item-title>
          </v-list-item>
          <v-list-item :to="{ name: 'AdminArrangements' }">
            <v-list-item-icon>
              <v-icon>mdi-file-multiple</v-icon>
            </v-list-item-icon>
            <v-list-item-title>投稿一覧</v-list-item-title>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
export default {
  data() {
    return {
      drawer: false,
      group: null,
    };
  },
  computed: {
    ...mapGetters('adminUsers', ['adminUser']),
  },
  watch: {
    group() {
      return (this.drawer = false);
    },
  },
  methods: {
    ...mapActions('adminUsers', ['logoutAdmin']),
    ...mapActions('snackbars', ['fetchSnackbarData']),
    handleLogout() {
      this.logoutAdmin().then((res) => {
        if (res) {
          this.$router.push({ name: 'AdminLogin' });
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
