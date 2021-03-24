<template>
  <v-dialog :value="isShow" width="650px" @click:outside="$emit('closeDialog')">
    <v-card>
      <v-card-title class="font-weight-bold">投稿を削除する</v-card-title>
      <v-card-text> この投稿を本当に削除しますか？削除後は元に戻すことはできません。 </v-card-text>
      <v-card-actions>
        <v-spacer />
        <v-btn
          class="font-weight-bold"
          style="color: white"
          color="#ff5252"
          @click="$emit('deleteArrangement')"
        >
          削除する
        </v-btn>
        <v-btn class="font-weight-bold" @click="$emit('closeDialog')">キャンセル</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    isShow: {
      type: Boolean,
    },
  },
};
</script>
