<template>
  <div>
    <v-slider
      :value="taste"
      min="0"
      max="5"
      step="1"
      ticks="always"
      :tickLabels="tickLabels"
      trackColor="black"
      thumbColor="#cc3918"
      trackFillColor="#cc3918"
      @input="$emit('update:taste', $event)"
    >
      <template #label>
        <div class="mr-4">美味さ</div>
      </template></v-slider
    >
    <v-slider
      :value="spiciness"
      min="0"
      max="5"
      step="1"
      ticks="always"
      :tickLabels="tickLabels"
      trackColor="black"
      thumbColor="#cc3918"
      trackFillColor="#cc3918"
      @input="$emit('update:spiciness', $event)"
    >
      <template #label>
        <div class="mr-8">辛さ</div>
      </template>
    </v-slider>
    <v-slider
      :value="sweetness"
      min="0"
      max="5"
      step="1"
      ticks="always"
      :tickLabels="tickLabels"
      trackColor="black"
      thumbColor="#cc3918"
      trackFillColor="#cc3918"
      @input="$emit('update:sweetness', $event)"
    >
      <template #label>
        <div class="mr-8">甘さ</div>
      </template>
    </v-slider>
    <v-slider
      :value="satisfaction"
      label="食べ応え"
      min="0"
      max="5"
      step="1"
      ticks="always"
      :tickLabels="tickLabels"
      trackColor="black"
      thumbColor="#cc3918"
      trackFillColor="#cc3918"
      @input="$emit('update:satisfaction', $event)"
    />
  </div>
</template>

<script>
export default {
  props: {
    taste: {
      type: Number,
      required: true,
    },
    spiciness: {
      type: Number,
      required: true,
    },
    sweetness: {
      type: Number,
      required: true,
    },
    satisfaction: {
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
