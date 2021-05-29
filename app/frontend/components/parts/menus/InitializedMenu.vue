<template>
  <v-menu rounded absolute>
    <template #activator="{ on, attrs }">
      <v-btn
        :absolute="absolute"
        top
        right
        icon
        outlined
        v-bind="attrs"
        style="background-color: white"
        v-on="on"
      >
        <slot name="btn-text" />
      </v-btn>
    </template>
    <slot name="list" />
  </v-menu>
</template>

<script>
export default {
  props: {
    absolute: {
      type: Boolean,
      default: false,
    },
  },
};
</script>
