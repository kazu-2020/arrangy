<template>
  <v-dialog :value="isShow" width="650px" @click:outside="$emit('closeDialog')">
    <v-sheet id="comment-edit-form" class="pa-5" color="#eeeeee" :rounded="true">
      <ValidationObserver v-slot="{ invalid }" class="pos-re mb-3" tag="form" mode="input">
        <ValidationProvider name="コメント" :rules="rules">
          <v-textarea
            id="comment-body"
            label="コメント"
            autoGrow
            rows="1"
            hideDetails="auto"
            outlined
            color="black"
            :value="body"
            @input="$emit('update:body', $event ? $event.trim() : $event)"
          />
        </ValidationProvider>
        <v-card-actions class="pb-0">
          <v-spacer />
          <SubmitButton :color="'#cc3918'" :disabled="invalid" @submit="$emit('updateComment')">
            <template #text>更新する</template>
          </SubmitButton>
          <NormalButton @click="$emit('closeDialog')">
            <template #text>キャンセル</template>
          </NormalButton>
        </v-card-actions>
      </ValidationObserver>
    </v-sheet>
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
    id: {
      type: String,
      required: true,
    },
    body: {
      type: String,
      required: true,
    },
    isShow: {
      type: Boolean,
    },
  },
  computed: {
    rules() {
      return { required: true, max: 1000 };
    },
  },
};
</script>
