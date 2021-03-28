<template>
  <ValidationObserver v-slot="{ invalid }" class="pos-re mb-3" tag="form" mode="input">
    <ValidationProvider name="コメント" :rules="rules">
      <v-textarea
        id="comment-body"
        label="コメント"
        autoGrow
        rows="1"
        color="black"
        :value="body"
        @input="$emit('update:body', $event)"
      />
    </ValidationProvider>
    <v-btn
      class="font-weight-bold comment-btn"
      icon
      depressed
      :disabled="invalid"
      @click="$emit('createComment')"
    >
      <v-icon>mdi-send</v-icon>
    </v-btn>
  </ValidationObserver>
</template>

<script>
export default {
  props: {
    body: {
      type: String,
      required: false,
      default: '',
    },
  },
  data() {
    return {
      rules: { required: true, max: 1000 },
    };
  },
};
</script>

<style scoped>
.pos-re {
  position: relative;
}

.comment-btn {
  position: absolute;
  bottom: 15px;
  right: 5px;
}
</style>
