<template>
  <v-container>
    <v-row class="pt-10 mb-5">
      <v-col>
        <h6 class="text-h5 font-weight-bold">アレンジ飯を投稿する</h6>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" class="mx-auto">
        <ArrangementNewForm
          v-bind.sync="arrangement"
          :loading="arrangementCreating"
          @createArrangement="createArrangement"
          @uploadFile="uploadFile"
        />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions } from 'vuex';
import ArrangementNewForm from '../../parts/forms/ArrangementNewForm';

export default {
  components: {
    ArrangementNewForm,
  },
  data() {
    return {
      arrangement: {
        title: '',
        context: '',
        images: [],
      },
      arrangementCreating: false,
    };
  },
  head: {
    title() {
      return {
        inner: '新規投稿',
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
        },
        {
          property: 'og:title',
          content:
            'Arrangy(アレンジー) | コンビニ商品や外食店の料理を使用したアレンジ飯の共有サービス',
        },
        {
          property: 'og:description',
          content: this.siteDescription,
        },
        {
          property: 'og:image',
          content: 'https://arrangy.jp/images/og-image.png',
        },
      ];
    },
  },
  computed: {
    siteDescription() {
      return 'Arrangy(アレンジー)はアレンジ飯の共有サービスです。コンビニ商品や外食店の料理を使用したアレンジ飯を「知りたい」「共有したい」という方達は、是非覗いてみてください!!';
    },
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    createArrangement() {
      this.arrangementCreating = true;
      this.$devour
        .create('arrangement', this.arrangement)
        .then((res) => {
          this.$router.push({ name: 'ArrangementShow', params: { id: res.data.id } });
          this.arrangementCreating = false;
          this.fetchSnackbarData({
            msg: '新しいアレンジ飯を投稿しました',
            color: 'success',
            isShow: true,
          });
        })
        .catch(() => {
          this.arrangementCreating = false;
          this.fetchSnackbarData({
            msg: '投稿に失敗しました',
            color: 'error',
            isShow: true,
          });
        });
    },
    uploadFile(src) {
      this.arrangement.images.splice(0, 1, src);
    },
  },
};
</script>
