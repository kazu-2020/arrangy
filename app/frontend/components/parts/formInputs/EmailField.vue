<template>
  <ValidationProvider v-slot="{ errors }" name="メールアドレス" mode="blur" :rules="rules">
    <v-text-field
      id="user-email"
      label="メールアドレス"
      type="email"
      :errorMessages="errors"
      :value="email"
      @input="$emit('input', $event)"
    />
  </ValidationProvider>
</template>

<script>
export default {
  props: {
    email: {
      type: String,
      required: true,
    },
    rules: {
      type: Object,
      required: true,
    },
  },
};
</script>
