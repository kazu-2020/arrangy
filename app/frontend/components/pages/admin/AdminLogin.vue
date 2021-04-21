<template>
  <v-container class="fill-height">
    <v-row class="d-flex justify-center">
      <v-col cols="12" md="6">
        <v-card>
          <ValidationObserver id="login-using-address" v-slot="{ handleSubmit }" tag="form">
            <v-card-text class="px-8">
              <EmailField :email="user.email" :rules="rules.email" @input="user.email = $event" />
              <PasswordField
                :password="user.password"
                :rules="rules.password"
                @input="user.password = $event"
              />
            </v-card-text>
            <v-card-actions class="d-flex justify-center pb-8">
              <SubmitButton
                :xLarge="true"
                :color="'#cc3918'"
                @submit="handleSubmit(handleLoginAdmin)"
              >
                <template #text> 管理画面へログイン </template>
              </SubmitButton>
            </v-card-actions>
          </ValidationObserver>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import EmailField from '../../parts/formInputs/EmailField';
import PasswordField from '../../parts/formInputs/PasswordField';
import SubmitButton from '../../parts/buttons/SubmitButton';
import { mapActions } from 'vuex';

export default {
  components: {
    EmailField,
    PasswordField,
    SubmitButton,
  },
  data() {
    return {
      user: {
        email: '',
        password: '',
      },
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
    ...mapActions('adminUsers', ['loginAdmin']),
    ...mapActions('snackbars', ['fetchSnackbarData']),
    handleLoginAdmin() {
      this.loginAdmin(this.user).then((user) => {
        if (user) {
          this.$router.push({ name: 'AdminUsers' });
          this.fetchSnackbarData({
            msg: 'ログインしました',
            color: 'success',
            isShow: true,
          });
        } else {
          this.fetchSnackbarData({
            msg: 'ログインに失敗しました',
            color: 'error',
            isShow: true,
          });
        }
      });
    },
  },
};
</script>
