<template>
  <ValidationProvider v-slot="{ errors }" :rules="rules" name="投稿内容">
    <v-textarea
      id="arrangement-context"
      label="投稿内容"
      outlined
      autoGrow
      clearable
      color="black"
      counter="1000"
      :errorMessages="errors"
      :value="context"
      @input="$emit('input', $event)"
    />
  </ValidationProvider>
</template>

<script>
export default {
  props: {
    context: {
      type: String,
      required: false,
      default: null,
    },
    rules: {
      type: Object,
      required: false,
      default: null,
    },
  },
};
</script>
