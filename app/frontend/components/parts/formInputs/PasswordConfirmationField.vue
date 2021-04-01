<template>
  <ValidationProvider v-slot="{ errors }" name="パスワード(確認用)" :rules="rules" mode="blur">
    <v-text-field
      id="user-confirmation"
      label="パスワード(確認用)"
      :appendIcon="showPasswordConfirmation ? 'mdi-eye' : 'mdi-eye-off'"
      :type="showPasswordConfirmation ? 'text' : 'password'"
      :errorMessages="errors"
      :value="password"
      @input="$emit('input', $event)"
      @click:append="handleShowPasswordConfirmation"
    />
  </ValidationProvider>
</template>

<script>
export default {
  props: {
    password: {
      type: String,
      required: true,
    },
    rules: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      showPasswordConfirmation: false,
    };
  },
  methods: {
    handleShowPasswordConfirmation() {
      this.showPasswordConfirmation = !this.showPasswordConfirmation;
    },
  },
};
</script>

<style></style>
