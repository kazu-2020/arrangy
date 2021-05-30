<template>
  <ValidationObserver id="login-using-address" v-slot="{ handleSubmit }" tag="form">
    <v-card-text class="px-8">
      <EmailField :email="email" :rules="rules.email" @input="$emit('update:email', $event)" />
      <PasswordField
        :password="password"
        :rules="rules.password"
        @input="$emit('update:password', $event)"
      />
      <v-checkbox
        label="次回からのログインを省略する。"
        :inputValue="remember"
        color="success"
        @change="$emit('update:remember', $event)"
      />
      <div class="text-body-2">
        Arrangyの利用を継続した場合、
        <a style="color: #cc3918" @click.stop="termsDialogDisplayed = true"> 利用規約 </a>
        及び
        <a style="color: #cc3918" @click.stop="privacyPolicyDialogDisplayed = true">
          プライバシーポリシー
        </a>
        に同意したことになります。
      </div>
    </v-card-text>
    <v-card-actions class="d-flex justify-center">
      <SubmitButton :xLarge="true" :color="'#cc3918'" @submit="handleSubmit(handleLoginUser)">
        <template #text>
          <v-icon class="mr-1">mdi-email-outline</v-icon>
          メールアドレスでログイン
        </template>
      </SubmitButton>
    </v-card-actions>

    <div class="d-flex justify-center">
      <v-btn text rounded :to="{ name: 'ResetPassword' }" color="#cc3918" class="mb-5">
        パスワードをお忘れの方はこちら
      </v-btn>
    </div>

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
import NormalButton from '../buttons/NormalButton';
import PasswordField from '../formInputs/PasswordField';
import PrivacyPolicyBody from '../base/PrivacyPolicyBody';
import SubmitButton from '../buttons/SubmitButton';
import TermsBody from '../base/TermsBody';

export default {
  components: {
    EmailField,
    NormalButton,
    PasswordField,
    PrivacyPolicyBody,
    SubmitButton,
    TermsBody,
  },
  props: {
    email: {
      type: String,
      required: true,
    },
    password: {
      type: String,
      required: true,
    },
    remember: {
      type: Boolean,
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
        email: { required: true, email: true, max: 50 },
        password: { required: true, min: 6, regex: /^[0-9a-zA-Z]+$/i },
      };
    },
  },
  methods: {
    handleLoginUser() {
      this.$emit('loginUser');
    },
  },
};
</script>
