<template>
  <v-container>
    <v-row class="mb-10">
      <v-col class="pt-10">
        <h3 class="text-h4 mb-4 font-weight-black">新規登録</h3>
        <p class="text-body-1">
          既にアカウントをお持ちの方は
          <router-link class="router-link" :to="{ name: 'UserLogin' }"> こちら </router-link>
          から。
        </p>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="5" md="5" lg="5" xl="5">
        <v-card height="100%">
          <div class="text-h6 pt-8 px-8 text-center font-weight-black">
            他サービスのアカウントで<br class="br-sp" />登録
          </div>
          <v-card-actions class="d-flex flex-column">
            <v-btn class="mb-12" x-large>Twitterアカウントで登録</v-btn>
            <v-btn class="mb-12" x-large>Googleアカウントで登録</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
      <v-col class="d-flex justify-center align-center" cols="12" sm="2" md="2" lg="2" xl="2">
        <p>または</p>
      </v-col>
      <v-col cols="12" sm="5" md="5" lg="5" xl="5">
        <UserRegisterForm v-bind.sync="user" @create-user="registerUser(user)" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions } from 'vuex';
import UserRegisterForm from '../parts/UserRegisterForm';
export default {
  components: {
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
  },
};
</script>
