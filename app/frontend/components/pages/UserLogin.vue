<template>
  <v-row class="d-flex align-center justify-center">
    <v-col cols="12" sm="10" md="8" lg="6">
      <div class="text-h3 text-center">ログイン</div>
      <v-card ref="form">
        <ValidationObserver v-slot="{ handleSubmit }">
          <v-card-text>
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
          <v-card-actions class="d-flex justify-center">
            <v-btn color="normal"> 戻る </v-btn>
            <v-btn color="primary" xLarge @click="handleSubmit(handleLogin)"> 登録する </v-btn>
          </v-card-actions>
        </ValidationObserver>
      </v-card>
    </v-col>
  </v-row>
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
