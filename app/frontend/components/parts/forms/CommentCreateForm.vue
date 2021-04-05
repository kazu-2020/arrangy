<template>
  <ValidationObserver id="create-comment-form" v-slot="{ invalid }" class="mb-3" tag="form">
    <ValidationProvider name="コメント" :rules="rules" mode="input">
      <v-textarea
        id="comment-body"
        label="コメント"
        autoGrow
        rows="1"
        color="black"
        :value="body"
        @click="displayedButton = true"
        @input="$emit('update:body', $event ? $event.trim() : $event)"
      />
    </ValidationProvider>
    <div v-if="displayedButton" class="d-flex justify-end">
      <SubmitButton
        class="mx-2"
        :color="'#ff5252'"
        :disabled="invalid"
        @submit="$emit('createComment')"
      >
        <template #text>コメントする</template>
      </SubmitButton>
      <NormalButton @click="handleCancel">
        <template #text>キャンセル</template>
      </NormalButton>
    </div>
  </ValidationObserver>
</template>

<script>
import SubmitButton from '../buttons/SubmitButton';
import NormalButton from '../buttons/NormalButton';

export default {
  components: {
    SubmitButton,
    NormalButton,
  },
  props: {
    body: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      displayedButton: false,
    };
  },
  computed: {
    rules() {
      return { required: true, max: 1000 };
    },
  },
  methods: {
    handleCancel() {
      this.displayedButton = false;
      this.$emit('update:body', '');
    },
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
  right: -10px;
}
</style>
