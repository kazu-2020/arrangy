<template>
  <v-btn
    class="font-weight-bold btn"
    depressed
    outlined
    :disabled="disabled"
    :loading="loading"
    :xLarge="xLarge"
    @click.stop="$emit('click')"
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
    xLarge: {
      type: Boolean,
    },
    loading: {
      type: Boolean,
    },
    disabled: {
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
