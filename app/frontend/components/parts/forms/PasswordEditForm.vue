<template>
  <v-dialog :value="isShow" width="650px" @click:outside="closeDialog">
    <v-sheet id="password-edit-from" class="pa-10">
      <ValidationObserver ref="form" v-slot="{ handleSubmit }" class="pb-6" tag="div">
        <PasswordField
          :password="password"
          :rules="rules.password"
          @input="$emit('update:password', $event)"
        />
        <PasswordConfirmationField
          :password="passwordConfirmation"
          :rules="rules.confirmation"
          @input="$emit('update:passwordConfirmation', $event)"
        />
        <div class="d-flex justify-center">
          <v-btn
            class="mx-4"
            xLarge
            style="color: white"
            color="#ff5252"
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
import PasswordField from '../formInputs/PasswordField';
import PasswordConfirmationField from '../formInputs/PasswordConfirmationField';

export default {
  components: {
    PasswordField,
    PasswordConfirmationField,
  },
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
    };
  },
  methods: {
    handleUpdatePassword() {
      this.$emit('updatePassword');
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
