<template>
  <v-container>
    <v-row class="pt-16">
      <v-col col="auto">
        <div class="text-h4 text-md-h3 font-weight-bold text-center">500 Internal Server Error</div>
        <v-img src="/images/error-logo.png" height="300" contain />
      </v-col>
    </v-row>
    <v-row class="d-flex justify-center">
      <v-col cols="auto">
        <div class="text-body-2 text-md-body-1 mb-3">
          サーバーエラーが発生した為、お探しのページを表示できません。<br />
          再度時間を置いてからアクセスしてください。
        </div>
      </v-col>
    </v-row>
    <v-row>
      <v-col class="text-center">
        <v-btn outlined @click="comeBack">ページへ戻る</v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  methods: {
    ...mapActions('responseState', ['fetchResponseState']),
    comeBack() {
      this.fetchResponseState({ status: '', state: '' });
      this.$router.go(-1);
    },
  },
};
</script>

<style></style>
