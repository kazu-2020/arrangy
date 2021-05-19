<template>
  <v-card class="pa-2 pa-md-8">
    <v-card-title class="font-weight-light text-md-h6 text-subtitle-1 text-md-center">
      新しいパスワードを入力して下さい
    </v-card-title>
    <ValidationObserver id="forgot-password-form" v-slot="{ handleSubmit }" tag="form">
      <v-card-text>
        <PasswordField
          :password="user.password"
          :rules="rules.password"
          @input="user.password = $event"
        />
        <PasswordConfirmationField
          :password="user.password_confirmation"
          :rules="rules.confirmation"
          @input="user.password_confirmation = $event"
        />
      </v-card-text>
      <v-card-actions class="d-flex justify-center">
        <SubmitButton
          :xLarge="true"
          :color="'#cc3918'"
          @submit="handleSubmit(handleUpdatePassword)"
        >
          <template #text>更新する</template>
        </SubmitButton>
      </v-card-actions>
    </ValidationObserver>
  </v-card>
</template>

<script>
import { mapActions } from 'vuex';
import PasswordField from '../../parts/formInputs/PasswordField';
import PasswordConfirmationField from '../../parts/formInputs/PasswordConfirmationField';
import SubmitButton from '../../parts/buttons/SubmitButton';

export default {
  components: {
    PasswordField,
    PasswordConfirmationField,
    SubmitButton,
  },
  data() {
    return {
      user: {
        password: '',
        password_confirmation: '',
        token: '',
      },
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
        password: { required: true, min: 6, regex: /^[0-9a-zA-Z]+$/i },
        confirmation: { required: true, confirmed: 'password' },
      };
    },
    siteDescription() {
      return 'Arrangy(アレンジー)はアレンジ飯の共有サービスです。コンビニ商品や外食店の料理を使用したアレンジ飯を「知りたい」「共有したい」という方達は、是非覗いてみてください!!';
    },
  },
  created() {
    const decodeUrl = decodeURIComponent(location.search);
    decodeUrl.match(/^\?token=(.+)$/g);
    this.user.token = RegExp.$1;
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    handleUpdatePassword() {
      this.$devour
        .request(
          `${this.$devour.apiUrl}/password_resets/${this.user.token}`,
          'PATCH',
          {},
          this.user
        )
        .then(() => {
          this.$router.push({ name: 'UserLogin' });
          this.fetchSnackbarData({
            msg: 'パスワードを再設定しました。',
            color: 'success',
            isShow: true,
          });
        })
        .catch(() => {
          this.$router.push({ name: 'ResetPassword' });
          this.fetchSnackbarData({
            msg: '期限が切れています。再度、メールを送信して下さい。',
            color: 'error',
            isShow: true,
          });
        });
    },
  },
};
</script>
