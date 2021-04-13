<template>
  <RegistrationAndLoginBase>
    <template slot="main1-title"> ログイン </template>
    <template slot="main1-context">
      新規登録が済んでいない方は
      <router-link class="router-link" :to="{ name: 'UserRegister' }"> こちら </router-link>
      から。
    </template>

    <template slot="main2-title"> ARRANGYアカウントで<br class="br-sp" />ログイン </template>
    <template slot="main2-context">
      <UserLoginForm v-bind.sync="user" @loginUser="loginFunction" />
    </template>

    <template slot="main3-title"> 他サービスのアカウントで<br class="br-sp" />ログイン</template>
    <template slot="main3-context">
      <v-btn
        class="mb-12 font-weight-bold text-capitalize"
        href="/api/oauth/google"
        xLarge
        color="#dd4b39"
        style="color: white"
      >
        <v-icon class="mr-2">mdi-google-plus</v-icon>
        Googleアカウントで登録
      </v-btn>
    </template>
  </RegistrationAndLoginBase>
</template>

<script>
import { mapActions } from 'vuex';
import UserLoginForm from '../../parts/forms/UserLoginForm';
import RegistrationAndLoginBase from '../../parts/base/RegistrationAndLoginBase';

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
        },
        {
          property: 'og:title',
          content:
            'Arrangy(アレンジー) | コンビニ商品や外食店の料理を使用したアレンジ飯の共有サービス',
        },
        {
          property: 'og:description',
          content: this.siteDescription,
        },
        {
          property: 'og:image',
          content: '/images/og-image.png',
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
