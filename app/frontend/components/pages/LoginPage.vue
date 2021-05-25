<template>
  <RegistrationAndLoginBase>
    <template slot="main1-title"> ログイン </template>
    <template slot="main1-context">
      新規登録が済んでいない方は
      <router-link class="router-link" style="color: #cc3918" :to="{ name: 'UserRegister' }">
        こちら
      </router-link>
      から。
    </template>

    <template slot="main2-title"> Arrangyアカウントで<br class="br-sp" />ログイン </template>
    <template slot="main2-context">
      <UserLoginForm v-bind.sync="user" @loginUser="loginFunction" />
    </template>

    <template slot="main3-title"> 他サービスのアカウントで<br class="br-sp" />ログイン</template>
    <template slot="main3-context">
      <v-btn
        class="mb-12 font-weight-bold text-capitalize"
        href="/api/oauths/google"
        xLarge
        color="#dd4b39"
        style="color: white"
      >
        <v-icon class="mr-2">mdi-google-plus</v-icon>
        Googleアカウントでログイン
      </v-btn>
      <v-btn
        class="mb-12 font-weight-bold text-capitalize"
        href="/api/oauths/twitter"
        xLarge
        color="#1DA1F2"
        style="color: white"
      >
        <v-icon class="mr-2">mdi-twitter</v-icon>
        Twitterアカウントでログイン
      </v-btn>
    </template>
  </RegistrationAndLoginBase>
</template>

<script>
import { mapActions } from 'vuex';
import UserLoginForm from '../parts/forms/UserLoginForm';
import RegistrationAndLoginBase from '../parts/base/RegistrationAndLoginBase';

export default {
  components: {
    RegistrationAndLoginBase,
    UserLoginForm,
  },
  data() {
    return {
      user: {
        email: '',
        password: '',
      },
    };
  },
  head: {
    title() {
      return {
        inner: 'ログイン',
        separator: '|',
        complement: 'Arrangy(アレンジー)',
      };
    },
    meta() {
      return [
        {
          name: 'description',
          content: this.siteDescription,
        },
        {
          property: 'og:url',
          content: 'https://arrangy.jp',
          id: 'og-url',
        },
        {
          property: 'og:title',
          content:
            'Arrangy(アレンジー) | コンビニ商品や外食店の料理を使用したアレンジ飯の共有サービス',
          id: 'og-title',
        },
        {
          property: 'og:description',
          content: this.siteDescription,
          id: 'og-description',
        },
        {
          property: 'og:image',
          content: 'https://arrangy.jp/images/og-image.png',
          id: 'og-image',
        },
      ];
    },
  },
  computed: {
    siteDescription() {
      return 'Arrangy(アレンジー)はアレンジ飯の共有サービスです。コンビニ商品や外食店の料理を使用したアレンジ飯を「知りたい」「共有したい」という方達は、是非覗いてみてください!!';
    },
  },
  methods: {
    ...mapActions('users', ['loginUser']),
    ...mapActions('snackbars', ['fetchSnackbarData']),
    loginFunction() {
      this.loginUser(this.user).then((user) => {
        if (user) {
          this.$router.push({ name: 'TopPage' });
          this.fetchSnackbarData({
            msg: 'ログインしました',
            color: 'success',
            isShow: true,
          });
        } else {
          this.fetchSnackbarData({
            msg: 'ログインに失敗しました',
            color: 'error',
            isShow: true,
          });
        }
      });
    },
  },
};
</script>
