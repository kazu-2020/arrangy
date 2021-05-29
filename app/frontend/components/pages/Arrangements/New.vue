<template>
  <v-container>
    <v-row class="pt-10 mb-md-3">
      <v-col>
        <h6 class="text-h5 font-weight-bold">アレンジ飯を投稿する</h6>
      </v-col>
    </v-row>
    <v-row class="pb-10">
      <v-col cols="12" class="mx-auto">
        <ArrangementNewForm
          v-bind.sync="arrangementForm"
          :loading="arrangementCreating"
          @createArrangement="createArrangement"
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
      arrangementForm: {
        title: '',
        context: '',
        rating: 0,
        afterArrangementPhotoURL: '',
        beforeArrangementPhotoURL: '',
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
    arrangement() {
      return {
        title: this.arrangementForm.title,
        context: this.arrangementForm.context,
        rating: this.arrangementForm.rating,
      };
    },
    beforeArrangementPhoto() {
      return {
        url: this.arrangementForm.beforeArrangementPhotoURL,
      };
    },
    afterArrangementPhoto() {
      return {
        url: this.arrangementForm.afterArrangementPhotoURL,
      };
    },
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    ...mapActions('users', ['fetchAuthUser']),
    createArrangement() {
      this.arrangementCreating = true;
      this.$devour
        .request(
          `${this.$devour.apiUrl}/arrangements`,
          'POST',
          {},
          {
            arrangement: this.arrangement,
            after_arrangement_photo: this.afterArrangementPhoto,
            before_arrangement_photo: this.beforeArrangementPhoto,
          }
        )
        .then((res) => {
          this.$router.push({ name: 'ArrangementShow', params: { id: res.data.id } });
          this.fetchSnackbarData({
            msg: '新しいアレンジ飯を投稿しました',
            color: 'success',
            isShow: true,
          });
          this.fetchAuthUser();
          this.arrangementCreating = false;
        })
        .catch(() => {
          this.fetchSnackbarData({
            msg: '投稿に失敗しました',
            color: 'error',
            isShow: true,
          });
          this.arrangementCreating = false;
        });
    },
  },
};
</script>
