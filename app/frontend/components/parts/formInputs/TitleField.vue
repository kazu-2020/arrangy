<template>
  <ValidationProvider v-slot="{ errors }" :rules="rules" name="タイトル">
    <v-text-field
      id="arrangement-title"
      class="mb-6"
      type="text"
      label="タイトル"
      clearable
      color="black"
      counter="30"
      :errorMessages="errors"
      :value="title"
      @input="$emit('input', $event)"
    />
  </ValidationProvider>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      requird: false,
      default: null,
    },
    rules: {
      type: Object,
      required: true,
    },
  },
};
</script>
