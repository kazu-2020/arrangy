<template>
  <v-app-bar fixed height="64" elevation="1" color="grey lighten-5">
    <v-toolbar-title>
      <router-link class="router-link text-h4" style="color: #d32f2f" :to="{ name: 'TopPage' }">
        ARRANGY
      </router-link>
    </v-toolbar-title>
    <v-spacer></v-spacer>
    <template v-if="!!authUser">
      <v-btn text>マイページ</v-btn>
      <v-btn text>新規投稿</v-btn>
      <v-btn text>お気に入り一覧</v-btn>
      <v-btn text rounded plain :ripple="{ center: true }" x-large @click="logoutUser">
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
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
export default {
  computed: {
    ...mapGetters('users', ['authUser']),
  },
  methods: {
    ...mapActions('users', ['logoutUser']),
  },
};
</script>
