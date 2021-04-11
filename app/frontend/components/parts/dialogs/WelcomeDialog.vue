<template>
  <v-dialog :value="dialog" maxWidth="630" @click:outside="$emit('close-dialog')">
    <v-card id="welcome-dialog">
      <v-card-title class="font-weight-black text-h5 d-flex justify-center title">
        Arrangyへようこそ
      </v-card-title>
      <v-card-text class="text-body-1 font-weight-bold pa-8 text-md-center">
        Arrangyへのご登録ありがとうございます。<br />
        早速、あなたのアレンジ飯を投稿してみましょう。
      </v-card-text>
      <v-card-actions class="d-flex justify-space-around pb-8">
        <v-btn
          class="font-weight-bold btn"
          outlined
          color="#cc3918"
          xLarge
          :to="{ name: 'ArrangementNew' }"
        >
          投稿ページへ
        </v-btn>
        <NormalButton :xLarge="true" @click="$emit('close-dialog')">
          <template #text>あとで</template>
        </NormalButton>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import NormalButton from '../buttons/NormalButton';
export default {
  components: {
    NormalButton,
  },
  props: {
    dialog: {
      type: Boolean,
    },
  },
};
</script>

<style scoped>
.btn {
  border: 2.5px solid;
}
.title {
  background-color: #cc3918;
  color: white;
}
</style>
