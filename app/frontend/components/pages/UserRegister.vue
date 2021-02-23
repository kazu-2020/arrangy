<template>
  <v-row class="d-flex align-center justify-center">
    <v-col
      cols="12"
      sm="10"
      md="8"
      lg="6"
    >
      <div class="text-h3 text-center">
        新規作成
      </div>
      <v-card ref="form">
        <ValidationObserver v-slot="{ handleSubmit }">
          <v-card-text>
            <ValidationProvider
              v-slot="{ errors }"
              rules="required|isUnique:nickname|max:10"
              name="ニックネーム"
            >
              <v-text-field
                id="user-nickname"
                v-model="user.nickname"
                :errorMessages="errors"
                :mode="blur"
                type="text"
                label="ニックネーム"
              />
            </ValidationProvider>
            <ValidationProvider
              v-slot="{ errors }"
              rules="required|email|isUnique:email|max:50"
              name="メールアドレス"
            >
              <v-text-field
                id="user-email"
                v-model="user.email"
                :errorMessages="errors"
                :mode="blur"
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
          <v-card-actions class="d-flex justify-center">
            <v-btn color="normal">
              戻る
            </v-btn>
            <v-btn
              color="primary"
              xLarge
              :disabled="invalid"
              @click="handleSubmit(createUser)"
            >
              登録する
            </v-btn>
          </v-card-actions>
        </ValidationObserver>
      </v-card>
    </v-col>
  </v-row>
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
