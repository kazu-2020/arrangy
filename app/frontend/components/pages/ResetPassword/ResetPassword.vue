<template>
  <v-card class="pa-2 pa-md-8">
    <v-card-title class="font-weight-light text-md-h6 text-subtitle-1 text-md-center">
      登録しているメールアドレスをご入力ください。<br />
      入力したアドレス宛にメールを送信します。
    </v-card-title>
    <ValidationObserver id="forgot-password-form" v-slot="{ handleSubmit }" tag="form">
      <v-card-text>
        <EmailField :email="email" :rules="rules.email" @input="email = $event" />
      </v-card-text>
      <v-card-actions class="d-flex justify-center">
        <SubmitButton :xLarge="true" :color="'#cc3918'" @submit="handleSubmit(handleSendMail)">
          <template #text>メールを送信</template>
        </SubmitButton>
      </v-card-actions>
    </ValidationObserver>
  </v-card>
</template>

<script>
import { mapActions } from 'vuex';
import EmailField from '../../parts/formInputs/EmailField';
import SubmitButton from '../../parts/buttons/SubmitButton';

export default {
  components: {
    EmailField,
    SubmitButton,
  },
  data() {
    return {
      email: '',
    };
  },
  head: {
    title() {
      return {
        inner: 'パスワード再設定',
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
    rules() {
      return {
        email: { required: true, email: true, max: 50 },
      };
    },
    siteDescription() {
      return 'Arrangy(アレンジー)はアレンジ飯の共有サービスです。コンビニ商品や外食店の料理を使用したアレンジ飯を「知りたい」「共有したい」という方達は、是非覗いてみてください!!';
    },
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    handleSendMail() {
      this.$devour
        .request(`${this.$devour.apiUrl}/password_resets`, 'POST', {}, { email: this.email })
        .then(() => {
          this.fetchSnackbarData({
            msg: 'メールを送信しました',
            color: 'success',
            isShow: true,
          });
        })
        .catch(() => {
          this.fetchSnackbarData({
            msg: 'メール送信に失敗しました',
            color: 'error',
            isShow: true,
          });
        });
    },
  },
};
</script>
