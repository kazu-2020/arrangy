<template>
  <v-container>
    <v-row class="pt-16">
      <v-col col="auto">
        <div class="text-h4 text-md-h3 font-weight-bold text-center">404 Not Found</div>
        <v-img src="/images/error-logo.png" height="300" contain />
      </v-col>
    </v-row>
    <v-row class="d-flex justify-center">
      <v-col cols="auto">
        <div class="text-body-2 text-md-body-1 mb-3">
          お探しのページはいずれかの理由により見つかりませんでした。
        </div>
        <div class="text-body-2 text-md-body-1 pl-md-5">
          <div v-for="(problem, $index) in problems" :key="$index" class="d-flex mb-2">
            <div class="mr-2">{{ problem.num }}</div>
            <div>{{ problem.content }}</div>
          </div>
        </div>
      </v-col>
    </v-row>
    <v-row>
      <v-col class="text-center">
        <v-btn outlined :to="{ name: 'TopPage' }">トップページへ戻る</v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  computed: {
    problems() {
      return [
        { num: '1.', content: 'ページのURLが変更された可能性があります。' },
        { num: '2.', content: 'ページのURLが削除された可能性があります。' },
        { num: '3.', content: 'URLが間違っている可能性があります。' },
      ];
    },
  },
};
</script>
