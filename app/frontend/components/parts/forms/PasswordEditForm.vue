<template>
  <v-dialog :value="isShow" width="650px" @click:outside="closeDialog">
    <v-sheet class="pa-10">
      <ValidationObserver ref="form" v-slot="{ handleSubmit }" class="pb-6" tag="div">
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
            class="mb-6"
            label="パスワード(確認用)"
            :appendIcon="showPasswordConfirmation ? 'mdi-eye' : 'mdi-eye-off'"
            :type="showPasswordConfirmation ? 'text' : 'password'"
            :errorMessages="errors"
            :value="passwordConfirmation"
            @input="$emit('update:passwordConfirmation', $event)"
            @click:append="handleShowPasswordConfirmation"
          />
        </ValidationProvider>
        <div class="d-flex justify-center">
          <v-btn
            class="mx-4"
            xLarge
            style="color: white"
            color="red accent-2"
            @click="handleSubmit(handleUpdatePassword)"
          >
            更新する
          </v-btn>
          <v-btn class="mx-4" xLarge @click="closeDialog">戻る</v-btn>
        </div>
      </ValidationObserver>
      <p class="text-body2 text-center">
        プロフィールを変更する場合は
        <a @click="changeDialog"> こちら </a>
      </p>
    </v-sheet>
  </v-dialog>
</template>

<script>
export default {
  props: {
    password: {
      type: String,
      required: true,
    },
    passwordConfirmation: {
      type: String,
      required: true,
    },
    isShow: {
      type: Boolean,
    },
  },
  data() {
    return {
      rules: {
        password: { required: true, min: 6, regex: /^[0-9a-zA-Z]+$/i },
        confirmation: { required: true, confirmed: 'password' },
      },
      showPassword: false,
      showPasswordConfirmation: false,
    };
  },
  methods: {
    handleUpdatePassword() {
      this.$emit('updatePassword');
    },
    handleShowPassword() {
      this.showPassword = !this.showPassword;
    },
    handleShowPasswordConfirmation() {
      this.showPasswordConfirmation = !this.showPasswordConfirmation;
    },
    changeDialog() {
      this.$refs.form.reset();
      this.$emit('changeDialog');
    },
    closeDialog() {
      this.$refs.form.reset();
      this.$emit('closeDialog');
    },
  },
};
</script>
