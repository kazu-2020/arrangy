<template>
  <v-btn
    class="font-weight-bold"
    style="color: white"
    depressed
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
      required: true,
    },
    disabled: {
      type: Boolean,
    },
  },
};
</script>
