<template>
  <v-container>
    <v-row class="mb-10">
      <v-col class="pt-10">
        <h3 class="text-h4 mb-4 font-weight-black">ログイン</h3>
        <p class="text-body-1">
          新規登録が済んでいない方は
          <router-link class="router-link" :to="{ name: 'UserRegister' }"> こちら </router-link>
          から。
        </p>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="5" md="5" lg="5" xl="5">
        <v-card height="100%">
          <div class="text-h6 pt-8 px-8 text-center font-weight-black">
            他サービスのアカウントで<br class="br-sp" />ログイン
          </div>
          <v-card-actions class="d-flex flex-column">
            <v-btn class="mb-12" x-large>Twitterアカウントでログイン</v-btn>
            <v-btn class="mb-12" x-large>Googleアカウントでログイン</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
      <v-col class="d-flex justify-center align-center" cols="12" sm="2" md="2" lg="2" xl="2">
        <p>または</p>
      </v-col>
      <v-col cols="12" sm="5" md="5" lg="5" xl="5">
        <UserLoginForm v-bind.sync="user" @login-user="loginFunction" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions } from 'vuex';
import UserLoginForm from '../parts/UserLoginForm.vue';
export default {
  components: {
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
