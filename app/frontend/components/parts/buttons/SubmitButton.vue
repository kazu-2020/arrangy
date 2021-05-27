<template>
  <v-btn
    class="font-weight-bold btn"
    depressed
    outlined
    :color="color"
    :disabled="disabled"
    :loading="loading"
    :xLarge="xLarge"
    :small="small"
    @click="$emit('submit')"
  >
    <slot name="text" />
    <template #loader>
      <VueLoading type="barsCylon" color=" #4CAF50" />
    </template>
  </v-btn>
</template>

<script>
export default {
  props: {
    small: {
      type: Boolean,
    },
    xLarge: {
      type: Boolean,
    },
    color: {
      type: String,
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

<style scoped>
.btn {
  border: 2.5px solid;
}
</style>
