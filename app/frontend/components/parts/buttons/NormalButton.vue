<template>
  <v-btn class="font-weight-bold" depressed outlined :xLarge="xLarge" @click.stop="$emit('click')">
    <slot name="text" />
  </v-btn>
</template>

<script>
export default {
  props: {
    xLarge: {
      type: Boolean,
    },
  },
};
</script>
