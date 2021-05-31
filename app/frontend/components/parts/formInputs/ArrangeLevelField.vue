<template>
  <v-radio-group name="アレンジ度" row :value="value" @change="$emit('change', $event)">
    <v-radio
      v-for="(list, $index) in lists"
      :key="$index"
      :label="list.label"
      :color="list.color"
      :value="list.value"
    />
  </v-radio-group>
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
    lists() {
      return [
        { label: 'ちょい足し', color: '#009FE8', value: 0 },
        { label: '激変', color: 'red', value: 1 },
      ];
    },
  },
};
</script>
