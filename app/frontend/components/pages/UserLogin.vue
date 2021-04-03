<template>
  <RegistrationAndLoginBase>
    <template slot="main1-title"> ログイン </template>
    <template slot="main1-context">
      新規登録が済んでいない方は
      <router-link class="router-link" :to="{ name: 'UserRegister' }"> こちら </router-link>
      から。
    </template>

    <template slot="main2-title"> 他サービスのアカウントで<br class="br-sp" />ログイン</template>
    <template slot="main2-context">
      <v-btn class="mb-12" xlarge>twitterアカウントでログイン</v-btn>
      <v-btn class="mb-12" xlarge>googleアカウントでログイン</v-btn>
    </template>

    <template slot="main3-title"> ARRANGYアカウントで<br class="br-sp" />ログイン </template>
    <template slot="main3-context">
      <UserLoginForm v-bind.sync="user" @loginUser="loginFunction" />
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
