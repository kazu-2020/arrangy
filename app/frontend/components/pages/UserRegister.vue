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
        <v-card>
          <div class="text-h6 pt-8 px-8 text-center font-weight-black">
            メールアドレスを使用して<br class="br-sp" />新規登録
          </div>
          <ValidationObserver v-slot="{ handleSubmit }">
            <v-card-text>
              <ValidationProvider
                v-slot="{ errors }"
                mode="blur"
                rules="required|isUnique:nickname|max:10"
                name="ニックネーム"
              >
                <v-text-field
                  id="user-nickname"
                  v-model="user.nickname"
                  :errorMessages="errors"
                  type="text"
                  label="ニックネーム"
                />
              </ValidationProvider>
              <ValidationProvider
                v-slot="{ errors }"
                rules="required|email|isUnique:email|max:50"
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
              <ValidationProvider
                v-slot="{ errors }"
                rules="required|confirmed:password"
                name="パスワード(確認用)"
              >
                <v-text-field
                  id="user-confirmation"
                  v-model="user.password_confirmation"
                  :errorMessages="errors"
                  :appendIcon="showPasswordConfirmation ? 'mdi-eye' : 'mdi-eye-off'"
                  :type="showPasswordConfirmation ? 'text' : 'password'"
                  label="パスワード(確認用)"
                  @click:append="handleShowPasswordConfirmation"
                />
              </ValidationProvider>
            </v-card-text>
            <v-card-actions class="d-flex justify-center pb-8">
              <v-btn
                class="px-4"
                style="color: white"
                color="red accent-2"
                xLarge
                @click="handleSubmit(createUser)"
              >
                <v-icon class="mr-1">mdi-email</v-icon>
                メールアドレスで登録
              </v-btn>
            </v-card-actions>
          </ValidationObserver>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      user: {
        nickname: '',
        email: '',
        password: '',
        password_confirmation: '',
      },
      showPassword: false,
      showPasswordConfirmation: false,
    };
  },
  methods: {
    createUser() {
      this.$axios
        .post('users', { user: this.user })
        .then(() => alert('新規登録に成功しました'))
        .catch((error) => console.log(error));
    },
    handleShowPassword() {
      this.showPassword = !this.showPassword;
    },
    handleShowPasswordConfirmation() {
      this.showPasswordConfirmation = !this.showPasswordConfirmation;
    },
  },
};
</script>
