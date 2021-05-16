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
  computed: {
    rules() {
      return {
        email: { required: true, email: true, max: 50 },
      };
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
