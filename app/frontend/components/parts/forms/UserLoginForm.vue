<template>
  <v-card>
    <div class="text-h6 pt-8 px-8 text-center font-weight-black">
      ARRANGYアカウントで<br class="br-sp" />ログイン
    </div>
    <ValidationObserver v-slot="{ handleSubmit }">
      <v-card-text class="px-8">
        <ValidationProvider
          v-slot="{ errors }"
          name="メールアドレス"
          mode="blur"
          :rules="rules.email"
        >
          <v-text-field
            id="user-email"
            label="メールアドレス"
            type="email"
            :errorMessages="errors"
            :value="email"
            @input="$emit('update:email', $event)"
          />
        </ValidationProvider>
        <ValidationProvider
          v-slot="{ errors }"
          name="パスワード"
          vid="password"
          mode="blur"
          :rules="rules.password"
        >
          <v-text-field
            id="user-password"
            :appendIcon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
            :type="showPassword ? 'text' : 'password'"
            label="パスワード"
            :errorMessages="errors"
            :value="password"
            @input="$emit('update:password', $event)"
            @click:append="handleShowPassword"
          />
        </ValidationProvider>
      </v-card-text>
      <v-card-actions class="d-flex justify-center pb-8">
        <v-btn
          class="px-4"
          style="color: white"
          color="red accent-2"
          xLarge
          @click="handleSubmit(handleLogin)"
        >
          <v-icon class="mr-1">mdi-email</v-icon>
          メールアドレスでログイン
        </v-btn>
      </v-card-actions>
    </ValidationObserver>
  </v-card>
</template>

<script>
export default {
  props: {
    email: {
      type: String,
      required: true,
    },
    password: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      rules: {
        email: { required: true, email: true, max: 50 },
        password: { required: true, min: 6, regex: /^[0-9a-zA-Z]+$/i },
      },
      showPassword: false,
    };
  },
  methods: {
    handleLogin() {
      this.$emit('login-user');
    },
    handleShowPassword() {
      this.showPassword = !this.showPassword;
    },
  },
};
</script>
