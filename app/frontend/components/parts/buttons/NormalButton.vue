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
