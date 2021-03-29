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
        <v-btn
          class="font-weight-bold"
          style="color: white"
          color="#ff5252"
          @click="$emit('deleteData')"
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
