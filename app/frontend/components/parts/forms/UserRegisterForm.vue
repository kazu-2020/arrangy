<template>
  <ValidationObserver id="register-using-address" v-slot="{ handleSubmit }" tag="form">
    <v-card-text class="px-8">
      <NicknameField
        :nickname="nickname"
        :rules="rules.nickname"
        @input="$emit('update:nickname', $event)"
      />
      <EmailField :email="email" :rules="rules.email" @input="$emit('update:email', $event)" />
      <PasswordField
        :password="password"
        :rules="rules.password"
        @input="$emit('update:password', $event)"
      />
      <PasswordConfirmationField
        :password="password_confirmation"
        :rules="rules.password_confirmation"
        @input="$emit('update:password_confirmation', $event)"
      />
    </v-card-text>
    <v-card-actions class="d-flex justify-center pb-8">
      <SubmitButton :xLarge="true" :color="'#ff5252'" @submit="handleSubmit(handleRegisterUser)">
        <template #text>
          <v-icon class="mr-1">mdi-email-outline</v-icon>
          メールアドレスで登録
        </template>
      </SubmitButton>
    </v-card-actions>
  </ValidationObserver>
</template>

<script>
import NicknameField from '../formInputs/NicknameFiled';
import EmailField from '../formInputs/EmailField';
import PasswordField from '../formInputs/PasswordField';
import PasswordConfirmationField from '../formInputs/PasswordConfirmationField';
import SubmitButton from '../buttons/SubmitButton';

export default {
  components: {
    NicknameField,
    EmailField,
    PasswordField,
    PasswordConfirmationField,
    SubmitButton,
  },
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
        nickname: { required: true, isUnique: 'nickname', max: 30 },
        email: { required: true, email: true, isUnique: 'email', max: 50 },
        password: { required: true, min: 6, regex: /^[0-9a-zA-Z]+$/i },
        password_confirmation: { required: true, confirmed: 'password' },
      },
    };
  },
  methods: {
    handleRegisterUser() {
      this.$emit('registerUser');
    },
  },
};
</script>
