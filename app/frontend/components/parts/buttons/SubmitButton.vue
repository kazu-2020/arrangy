<template>
  <v-btn
    class="font-weight-bold"
    depressed
    outlined
    :color="color"
    :xLarge="xLarge"
    :disabled="disabled"
    @click="$emit('submit')"
  >
    <slot name="text" />
  </v-btn>
</template>

<script>
export default {
  props: {
    xLarge: {
      type: Boolean,
    },
    color: {
      type: String,
      required: false,
      default: null,
    },
    disabled: {
      type: Boolean,
    },
  },
};
</script>
