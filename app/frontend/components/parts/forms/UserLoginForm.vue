<template>
  <v-card id="login-using-address">
    <div class="text-h6 pt-8 px-8 text-center font-weight-black">
      ARRANGYアカウントで<br class="br-sp" />ログイン
    </div>
    <ValidationObserver v-slot="{ handleSubmit }" tag="form">
      <v-card-text class="px-8">
        <EmailField :email="email" :rules="rules.email" @input="$emit('update:email', $event)" />
        <PasswordField
          :password="password"
          :rules="rules.password"
          @input="$emit('update:password', $event)"
        />
      </v-card-text>
      <v-card-actions class="d-flex justify-center pb-8">
        <SubmitButton :xLarge="true" :color="'#ff5252'" @submit="handleSubmit(handleLoginUser)">
          <template #text>
            <v-icon class="mr-1">mdi-email-outline</v-icon>
            メールアドレスでログイン
          </template>
        </SubmitButton>
      </v-card-actions>
    </ValidationObserver>
  </v-card>
</template>

<script>
import EmailField from '../formInputs/EmailField';
import PasswordField from '../formInputs/PasswordField';
import SubmitButton from '../buttons/SubmitButton';

export default {
  components: {
    EmailField,
    PasswordField,
    SubmitButton,
  },
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
    };
  },
  methods: {
    handleLoginUser() {
      this.$emit('loginUser');
    },
  },
};
</script>
