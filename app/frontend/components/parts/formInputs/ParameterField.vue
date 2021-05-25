<template>
  <v-slider
    :value="value"
    min="0"
    max="5"
    step="1"
    ticks="always"
    :tickLabels="tickLabels"
    trackColor="black"
    thumbColor="#cc3918"
    trackFillColor="#cc3918"
    @input="$emit('input', $event)"
  >
    <template #label>
      <slot name="label" />
    </template>
  </v-slider>
</template>

<script>
export default {
  props: {
    value: {
      type: Number,
      required: true,
    },
  },
  computed: {
    tickLabels() {
      return ['0', '1', '2', '3', '4', '5'];
    },
  },
};
</script>
