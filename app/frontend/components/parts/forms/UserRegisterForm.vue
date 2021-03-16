<template>
  <v-card>
    <div class="text-h6 pt-8 px-8 text-center font-weight-black">
      メールアドレスを使用して<br class="br-sp" />新規登録
    </div>
    <ValidationObserver v-slot="{ handleSubmit }">
      <v-card-text class="px-8">
        <ValidationProvider
          v-slot="{ errors }"
          name="ニックネーム"
          mode="blur"
          :rules="rules.nickname"
        >
          <v-text-field
            id="user-nickname"
            label="ニックネーム"
            type="text"
            :errorMessages="errors"
            :value="nickname"
            @input="$emit('update:nickname', $event)"
          />
        </ValidationProvider>
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
          :rules="rules.password"
        >
          <v-text-field
            id="user-password"
            label="パスワード"
            :appendIcon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
            :type="showPassword ? 'text' : 'password'"
            :errorMessages="errors"
            :value="password"
            @input="$emit('update:password', $event)"
            @click:append="handleShowPassword"
          />
        </ValidationProvider>
        <ValidationProvider
          v-slot="{ errors }"
          name="パスワード(確認用)"
          :rules="rules.confirmation"
        >
          <v-text-field
            id="user-confirmation"
            label="パスワード(確認用)"
            :appendIcon="showPasswordConfirmation ? 'mdi-eye' : 'mdi-eye-off'"
            :type="showPasswordConfirmation ? 'text' : 'password'"
            :errorMessages="errors"
            :value="password_confirmation"
            @input="$emit('update:password_confirmation', $event)"
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
          @click="handleSubmit(handleCreateUser)"
        >
          <v-icon class="mr-1">mdi-email</v-icon>
          メールアドレスで登録
        </v-btn>
      </v-card-actions>
    </ValidationObserver>
  </v-card>
</template>

<script>
export default {
  props: {
    nickname: {
      type: String,
      requred: true,
      default: '',
    },
    email: {
      type: String,
      requred: true,
      default: '',
    },
    password: {
      type: String,
      requred: true,
      default: '',
    },
    // eslint-disable-next-line vue/prop-name-casing
    password_confirmation: {
      type: String,
      requred: true,
      default: '',
    },
  },
  data() {
    return {
      rules: {
        nickname: { required: true, isUnique: 'nickname', max: 10 },
        email: { required: true, email: true, isUnique: 'email', max: 50 },
        password: { required: true, min: 6, regex: /^[0-9a-zA-Z]+$/i },
        confirmation: { required: true, confirmed: 'password' },
      },
      showPassword: false,
      showPasswordConfirmation: false,
    };
  },
  methods: {
    handleShowPassword() {
      this.showPassword = !this.showPassword;
    },
    handleShowPasswordConfirmation() {
      this.showPasswordConfirmation = !this.showPasswordConfirmation;
    },
    handleCreateUser() {
      this.$emit('create-user');
    },
  },
};
</script>
