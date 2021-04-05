<template>
  <ValidationProvider v-slot="{ errors }" name="タイトル" :rules="rules">
    <v-text-field
      id="arrangement-title"
      class="mb-6"
      type="text"
      label="タイトル"
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
      required: true,
    },
    rules: {
      type: Object,
      required: true,
    },
  },
};
</script>
