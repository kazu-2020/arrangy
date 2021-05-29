<template>
  <ValidationProvider name="評価" :rules="rules">
    <v-rating
      id="rating-field"
      length="5"
      :value="value"
      backgroundColor="orange lighten-3"
      color="orange"
      :large="large"
      @input="$emit('input', $event)"
    />
  </ValidationProvider>
</template>

<script>
export default {
  props: {
    value: {
      type: Number,
      required: true,
    },
    rules: {
      type: Object,
      required: true,
    },
    large: {
      type: Boolean,
      default: false,
    },
  },
};
</script>
