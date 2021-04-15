<template>
  <RegistrationAndLoginBase>
    <template slot="main1-title">新規登録</template>
    <template slot="main1-context">
      既にアカウントをお持ちの方は
      <router-link class="router-link" :to="{ name: 'UserLogin' }"> こちら </router-link>
      から。
    </template>

    <template slot="main2-title"> メールアドレスを使用して新規登録</template>
    <template slot="main2-context">
      <UserRegisterForm v-bind.sync="user" @registerUser="registerFunction" />
    </template>

    <template slot="main3-title"> 他サービスのアカウントで登録 </template>
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
import RegistrationAndLoginBase from '../parts/base/RegistrationAndLoginBase';
import UserRegisterForm from '../parts/forms/UserRegisterForm';

export default {
  components: {
    RegistrationAndLoginBase,
    UserRegisterForm,
  },
  data() {
    return {
      user: {
        nickname: '',
        email: '',
        password: '',
        password_confirmation: '',
      },
    };
  },
  head: {
    title() {
      return {
        inner: '新規登録',
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
    ...mapActions('users', ['registerUser']),
    ...mapActions('snackbars', ['fetchSnackbarData']),
    registerFunction() {
      this.registerUser(this.user).then((user) => {
        if (user) {
          this.$router.push({ name: 'TopPage' });
        } else {
          this.fetchSnackbarData({
            msg: '新規登録に失敗しました',
            color: 'error',
            isShow: true,
          });
        }
      });
    },
    handleRegisterGoogle() {
      this.$devour.request(`${this.$devour.apiUrl}/oauth/google`, 'GET');
    },
  },
};
</script>
