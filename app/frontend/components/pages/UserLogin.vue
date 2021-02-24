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
          <p class="text-h6 pt-8 px-8 text-center font-weight-black">
            他サービスのアカウントで<br class="br-sp" />ログイン
          </p>
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
        <v-card>
          <p class="text-h6 pt-8 px-8 text-center font-weight-black">
            ARRANGYアカウントで<br class="br-sp" />ログイン
          </p>
          <ValidationObserver v-slot="{ handleSubmit }">
            <v-card-text class="px-8">
              <ValidationProvider
                v-slot="{ errors }"
                rules="required|email|max:50"
                mode="blur"
                name="メールアドレス"
              >
                <v-text-field
                  id="user-email"
                  v-model="user.email"
                  :errorMessages="errors"
                  type="email"
                  label="メールアドレス"
                />
              </ValidationProvider>
              <ValidationProvider
                v-slot="{ errors }"
                :rules="{ required: true, min: 6, regex: /^[0-9a-zA-Z]+$/i }"
                vid="password"
                name="パスワード"
              >
                <v-text-field
                  id="user-password"
                  v-model="user.password"
                  :errorMessages="errors"
                  :appendIcon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                  :type="showPassword ? 'text' : 'password'"
                  label="パスワード"
                  @click:append="handleShowPassword"
                />
              </ValidationProvider>
            </v-card-text>
            <v-card-actions class="d-flex justify-center pb-8">
              <v-btn
                class="px-4"
                style="color: white"
                color="red accent-2"
                x-large
                @click="handleSubmit(handleLogin)"
              >
                <v-icon class="mr-1">mdi-email</v-icon>
                メールアドレスでログイン
              </v-btn>
            </v-card-actions>
          </ValidationObserver>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions } from 'vuex';
export default {
  data() {
    return {
      user: {
        email: '',
        password: '',
      },
      showPassword: false,
    };
  },
  methods: {
    ...mapActions('users', ['loginUser']),
    handleShowPassword() {
      this.showPassword = !this.showPassword;
    },
    handleLogin() {
      this.loginUser(this.user);
    },
  },
};
</script>
