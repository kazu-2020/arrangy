<template>
  <ValidationObserver id="register-using-address" v-slot="{ handleSubmit }" tag="form">
    <v-card-text class="px-8">
      <NicknameField
        :nickname="nickname"
        :rules="rules.nickname"
        @input="$emit('update:nickname', $event)"
      />
      <EmailField :email="email" :rules="rules.email" @input="$emit('update:email', $event)" />
      <PasswordField
        :password="password"
        :rules="rules.password"
        @input="$emit('update:password', $event)"
      />
      <PasswordConfirmationField
        :password="password_confirmation"
        :rules="rules.password_confirmation"
        @input="$emit('update:password_confirmation', $event)"
      />
      <div class="text-body-2">
        Arrangyの利用を開始した場合、
        <a style="color: #cc3918" @click.stop="termsDialogDisplayed = true">利用規約</a>
        及び
        <a style="color: #cc3918" @click.stop="privacyPolicyDialogDisplayed = true">
          プライバシーポリシー
        </a>
        に同意したことになります。
      </div>
    </v-card-text>
    <v-card-actions class="d-flex justify-center flex-column pb-8">
      <SubmitButton :xLarge="true" :color="'#cc3918'" @submit="handleSubmit(handleRegisterUser)">
        <template #text>
          <v-icon class="mr-1">mdi-email-outline</v-icon>
          メールアドレスで登録
        </template>
      </SubmitButton>
    </v-card-actions>

    <!-- 利用規約ダイアログ -->
    <v-dialog v-model="termsDialogDisplayed" maxWidth="1100">
      <v-sheet>
        <TermsBody />
        <v-card-actions class="d-flex justify-center">
          <NormalButton :xLarge="true" @click="termsDialogDisplayed = false">
            <template #text>戻る</template>
          </NormalButton>
        </v-card-actions>
      </v-sheet>
    </v-dialog>

    <!-- プライバシーポリシーダイアログ -->
    <v-dialog v-model="privacyPolicyDialogDisplayed" maxWidth="1100">
      <v-sheet>
        <PrivacyPolicyBody />
        <v-card-actions class="d-flex justify-center">
          <NormalButton :xLarge="true" @click="privacyPolicyDialogDisplayed = false">
            <template #text>戻る</template>
          </NormalButton>
        </v-card-actions>
      </v-sheet>
    </v-dialog>
  </ValidationObserver>
</template>

<script>
import EmailField from '../formInputs/EmailField';
import NicknameField from '../formInputs/NicknameFiled';
import NormalButton from '../buttons/NormalButton';
import PasswordConfirmationField from '../formInputs/PasswordConfirmationField';
import PasswordField from '../formInputs/PasswordField';
import PrivacyPolicyBody from '../base/PrivacyPolicyBody';
import SubmitButton from '../buttons/SubmitButton';
import TermsBody from '../base/TermsBody';

export default {
  components: {
    EmailField,
    NicknameField,
    NormalButton,
    PasswordConfirmationField,
    PasswordField,
    PrivacyPolicyBody,
    SubmitButton,
    TermsBody,
  },
  props: {
    nickname: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
    password: {
      type: String,
      required: true,
    },
    // eslint-disable-next-line vue/prop-name-casing
    password_confirmation: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      termsDialogDisplayed: false,
      privacyPolicyDialogDisplayed: false,
    };
  },
  computed: {
    rules() {
      return {
        nickname: { required: true, isUnique: 'nickname', max: 30 },
        email: { required: true, email: true, isUnique: 'email', max: 50 },
        password: { required: true, min: 6, regex: /^[0-9a-zA-Z]+$/i },
        password_confirmation: { required: true, confirmed: 'password' },
      };
    },
  },
  methods: {
    handleRegisterUser() {
      this.$emit('registerUser');
    },
  },
};
</script>
