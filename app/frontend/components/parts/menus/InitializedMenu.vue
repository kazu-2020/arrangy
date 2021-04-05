<template>
  <v-menu rounded :bottom="bottom" :offsetY="offsetY">
    <template #activator="{ on, attrs }">
      <v-btn class="bg-white" :absolute="absolute" top right icon outlined v-bind="attrs" v-on="on">
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
    },
    bottom: {
      type: Boolean,
    },
    offsetY: {
      type: Boolean,
    },
    outlined: {
      type: Boolean,
    },
  },
};
</script>

<style scoped>
.bg-white {
  background-color: #eeeeee;
}
</style>
