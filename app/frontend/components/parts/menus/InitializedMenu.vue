<template>
  <v-menu rounded :left="left" :bottom="bottom" :offsetY="offsetY">
    <template #activator="{ on, attrs }">
      <v-btn icon v-bind="attrs" v-on="on">
        <slot name="btn-text" />
      </v-btn>
    </template>
    <slot name="list" />
  </v-menu>
</template>

<script>
export default {
  props: {
    left: {
      type: Boolean,
    },
    bottom: {
      type: Boolean,
    },
    offsetY: {
      type: Boolean,
    },
  },
};
</script>
