<template>
  <v-dialog :value="isShow" width="650px" @click:outside="$emit('closeDialog')">
    <v-card>
      <v-card-title class="font-weight-bold">
        <slot name="title" />
      </v-card-title>
      <v-card-text>
        <slot name="text" />
      </v-card-text>
      <v-card-actions>
        <v-spacer />
        <SubmitButton :color="'#ff5252'" @submit="$emit('deleteData')">
          <template #text>削除する</template>
        </SubmitButton>
        <NormalButton @click="$emit('closeDialog')">
          <template #text>キャンセル</template>
        </NormalButton>
      </v-card-actions>
    </v-card>
  </v-dialog>
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
    isShow: {
      type: Boolean,
    },
  },
};
</script>
