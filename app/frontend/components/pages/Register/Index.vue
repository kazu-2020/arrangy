<template>
  <RegistrationAndLoginBase>
    <template slot="main1-title">新規登録</template>
    <template slot="main1-context">
      既にアカウントをお持ちの方は
      <router-link class="router-link" :to="{ name: 'UserLogin' }"> こちら </router-link>
      から。
    </template>

    <template slot="main2-title"> 他サービスのアカウントで<br class="br-sp" />登録 </template>
    <template slot="main2-context">
      <v-btn class="mb-12" xLarge>Twitterアカウントで登録</v-btn>
      <v-btn class="mb-12" xLarge>Googleアカウントで登録</v-btn>
    </template>

    <template slot="main3-context">
      <UserRegisterForm v-bind.sync="user" @registerUser="registerFunction" />
    </template>
    <template slot="main3-title"> メールアドレスを使用して<br class="br-sp" />新規登録</template>
  </RegistrationAndLoginBase>
</template>

<script>
import { mapActions } from 'vuex';
import RegistrationAndLoginBase from '../../parts/base/RegistrationAndLoginBase';
import UserRegisterForm from '../../parts/forms/UserRegisterForm';

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
  },
};
</script>
