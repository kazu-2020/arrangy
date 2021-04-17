<template>
  <div>
    <v-container fluid class="px-0">
      <v-row noGutters class="d-flex justify-center">
        <v-col cols="auto">
          <v-img src="/images/about-page-logo.png" />
        </v-col>
        <v-col cols="auto">
          <v-card-text class="pt-md-16 mb-5 text-subtitle-1 text-md-h5 font-weight-bold">
            コンビニ商品や外食店の料理を使用した<br class="br-pc" />アレンジ飯を共有するサービスです
          </v-card-text>
          <v-card-actions class="d-flex justify-center">
            <v-btn xLarge outlined class="btn" color="#cc3918" :to="{ name: 'ArrangementNew' }">
              <div class="font-weight-bold">新規登録ページへ</div>
            </v-btn>
          </v-card-actions>
        </v-col>
      </v-row>

      <v-row class="d-flex justify-center" style="background-color: #fafafa">
        <v-col cols="auto" class="py-10">
          <v-card-title class="mb-5 text-h6 text-md-h5 font-weight-bold">
            あなたのアレンジ飯を投稿しよう
          </v-card-title>
          <v-card-text class="text-body-1">
            あなたの素敵なアレンジ飯を投稿しよう!!<br />
            投稿することで他の人達からコメントを貰えます。<br />
            別のアレンジを教えてもらえるかも!?
          </v-card-text>
        </v-col>
        <v-col cols="auto" class="py-10">
          <v-img src="/images/photo.png" />
        </v-col>
      </v-row>

      <v-row class="d-flex justify-center">
        <v-col cols="auto" class="py-10">
          <v-img src="/images/like.png" />
        </v-col>
        <v-col cols="auto" class="py-10">
          <v-card-title class="mb-3 text-h6 text-md-h5 font-weight-bold">
            ｢うまいいね」ボタンを押そう
          </v-card-title>
          <v-card-text class="text-body-1">
            気になったり、美味しかったアレンジ飯には「うまいいね」しよう。<br class="br-pc" />
            「うまいいね」した投稿は「お気に入り一覧」から見返すことができます。
          </v-card-text>
        </v-col>
      </v-row>

      <v-row class="d-flex justify-center" style="background-color: #fafafa">
        <v-col cols="auto" class="py-10">
          <v-card-title class="mb-3 text-h6 text-md-h5 font-weight-bold">
            あなたの声をお聞かせてください
          </v-card-title>
          <v-card-text class="text-body-1">
            Arrangyは出来て間もないサービスです。<br />
            その為、｢こんな機能が欲しい」などの<br class="br-sp" />フィードバックは大歓迎です!!
          </v-card-text>
        </v-col>
        <v-col cols="auto" class="py-10">
          <v-img src="/images/request.png" />
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  head: {
    title() {
      return {
        inner: 'サービス概要',
        separator: '|',
        complement: 'Arrangy(アレンジー)',
      };
    },
    meta() {
      return [
        {
          name: 'description',
          content: this.siteDescription,
        },
        {
          property: 'og:url',
          content: 'https://arrangy.jp',
          id: 'og-url',
        },
        {
          property: 'og:title',
          content:
            'Arrangy(アレンジー) | コンビニ商品や外食店の料理を使用したアレンジ飯の共有サービス',
          id: 'og-title',
        },
        {
          property: 'og:description',
          content: this.siteDescription,
          id: 'og-description',
        },
        {
          property: 'og:image',
          content: 'https://arrangy.jp/images/og-image.png',
          id: 'og-image',
        },
      ];
    },
  },
  computed: {
    siteDescription() {
      return 'Arrangy(アレンジー)はアレンジ飯の共有サービスです。コンビニ商品や外食店の料理を使用したアレンジ飯を「知りたい」「共有したい」という方達は、是非覗いてみてください!!';
    },
  },
};
</script>

<style scoped>
.btn {
  border: 2.5px solid;
}
</style>
