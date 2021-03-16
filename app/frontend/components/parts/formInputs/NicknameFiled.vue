<template>
  <ValidationProvider v-slot="{ errors }" name="ニックネーム" mode="blur" :rules="rules">
    <v-text-field
      id="user-nickname"
      label="ニックネーム"
      type="text"
      :errorMessages="errors"
      :value="nickname"
      @input="$emit('input', $event)"
    />
  </ValidationProvider>
</template>

<script>
export default {
  props: {
    nickname: {
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
