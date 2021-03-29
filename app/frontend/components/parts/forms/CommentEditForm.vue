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
            clearable
            color="black"
            :value="body"
            @input="$emit('update:body', $event ? $event.trim() : $event)"
          />
        </ValidationProvider>
        <v-card-actions class="pb-0">
          <v-spacer />
          <v-btn
            class="font-weight-bold"
            style="color: white"
            color="#ff5252"
            depressed
            :disabled="invalid"
            @click="$emit('updateComment')"
          >
            更新する
          </v-btn>
          <v-btn class="font-weight-bold" depressed outlined @click="$emit('closeDialog')">
            キャンセル
          </v-btn>
        </v-card-actions>
      </ValidationObserver>
    </v-sheet>
  </v-dialog>
</template>

<script>
export default {
  props: {
    id: {
      type: String,
      required: true,
    },
    body: {
      type: String,
      required: false,
      default: null,
    },
    isShow: {
      type: Boolean,
    },
  },
  data() {
    return {
      rules: { required: true, max: 1000 },
    };
  },
};
</script>
