<template>
  <ValidationProvider
    v-slot="{ errors }"
    name="パスワード"
    vid="password"
    :rules="rules"
    mode="blur"
  >
    <v-text-field
      id="user-password"
      label="パスワード"
      :appendIcon="passwordDisplayed ? 'mdi-eye' : 'mdi-eye-off'"
      :type="passwordDisplayed ? 'text' : 'password'"
      :errorMessages="errors"
      :value="password"
      @input="$emit('input', $event)"
      @click:append="handleShowPassword"
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
      passwordDisplayed: false,
    };
  },
  methods: {
    handleShowPassword() {
      this.passwordDisplayed = !this.passwordDisplayed;
    },
  },
};
</script>
