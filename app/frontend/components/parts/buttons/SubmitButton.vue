<template>
  <v-btn
    class="font-weight-bold"
    depressed
    outlined
    :color="color"
    :disabled="disabled"
    :loading="loading"
    :xLarge="xLarge"
    @click="$emit('submit')"
  >
    <slot name="text" />
    <template #loader>
      <v-progress-circular color="#eeeeee" indeterminate />
    </template>
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
    loading: {
      type: Boolean,
    },
  },
};
</script>
