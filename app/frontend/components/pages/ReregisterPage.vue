<template>
  <v-container>
    <v-row class="mb-10">
      <v-col class="pt-10" cols="auto">
        <div class="text-h4 mb-4 font-weight-black">新規登録</div>
        <div class="text-body-1 font-weight-medium">
          新規登録を完了する為に以下の項目を入力してください
        </div>
      </v-col>
    </v-row>
    <v-row class="d-flex justify-center">
      <v-col cols="12" md="6">
        <v-card class="pa-md-8">
          <ValidationObserver id="reregister-form" v-slot="{ handleSubmit }" tag="form">
            <v-card-text>
              <NicknameField
                :nickname="user.nickname"
                :rules="rules.nickname"
                @input="user.nickname = $event"
              />
              <EmailField :email="user.email" :rules="rules.email" @input="user.email = $event" />
            </v-card-text>
            <v-card-actions class="d-flex justify-center">
              <SubmitButton
                :xLarge="true"
                :color="'#cc3918'"
                @submit="handleSubmit(handleReregister)"
              >
                <template #text> 新規登録 </template>
              </SubmitButton>
            </v-card-actions>
          </ValidationObserver>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions } from 'vuex';

import EmailField from '../parts/formInputs/EmailField';
import NicknameField from '../parts/formInputs/NicknameFiled';
import SubmitButton from '../parts/buttons/SubmitButton';

export default {
  components: {
    EmailField,
    NicknameField,
    SubmitButton,
  },
  data() {
    return {
      user: {
        nickname: '',
        email: '',
      },
    };
  },
  computed: {
    rules() {
      return {
        nickname: { required: true, isUnique: 'nickname', max: 30 },
        email: { required: true, email: true, isUnique: 'email', max: 50 },
      };
    },
  },
  created() {
    const decodeUrl = decodeURIComponent(location.search);
    decodeUrl.match(/^\?nickname=(.+)&email=(.+)$/g);
    this.user.nickname = RegExp.$1;
    this.user.email = RegExp.$2;
  },
  methods: {
    ...mapActions('users', ['reregisterUser']),
    ...mapActions('snackbars', ['fetchSnackbarData']),
    handleReregister() {
      this.reregisterUser(this.user).then((user) => {
        if (user) {
          this.$router.push({ name: 'TopPage', query: { registration: true } });
        } else {
          this.fetchSnackbarData({
            msg: '新規登録に失敗しました',
            color: 'error',
            isShow: true,
          });
        }
      });
    },
  },
};
</script>
