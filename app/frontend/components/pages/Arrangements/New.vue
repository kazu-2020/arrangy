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
          v-bind.sync="arrangementForm"
          :parameter="parameter"
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
        afterArrangementPhotoURL: '',
        taste: 0,
        spiciness: 0,
        sweetness: 0,
        satisfaction: 0,
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
      };
    },
    afterArrangementPhoto() {
      return {
        url: this.arrangementForm.afterArrangementPhotoURL,
      };
    },
    parameter() {
      return {
        taste: this.arrangementForm.taste,
        spiciness: this.arrangementForm.spiciness,
        sweetness: this.arrangementForm.sweetness,
        satisfaction: this.arrangementForm.satisfaction,
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
            parameter: this.parameter,
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
