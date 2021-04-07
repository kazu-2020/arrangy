<template>
  <v-container fluid>
    <v-row class="pt-16">
      <v-col cols="12" sm="5">
        <v-row class="d-flex justify-center">
          <v-col cols="12" sm="8">
            <v-sheet id="myprofile" class="py-6 px-10 text-center" elevation="1">
              <div class="text-h6 font-weight-bold mb-8">プロフィール</div>
              <v-avatar class="mb-5" size="60%" minHeight="200" minWidth="200">
                <v-img :src="authUser.avatar" />
              </v-avatar>
              <div class="text-left mb-6">
                <div>
                  <div class="text-subtitle-1 font-weight-black">ニックネーム</div>
                  <div>{{ authUser.nickname }}</div>
                </div>
                <v-divider class="mb-6" />
                <div>
                  <div class="text-subtitle-1 font-weight-black">メールアドレス</div>
                  <div>{{ authUser.email }}</div>
                </div>
                <v-divider class="mb-6" />
              </div>
              <NormalButton class="mb-6" :xLarge="true" @click="displayProfileEditDialog">
                <template #text>
                  <v-icon class="mr-1">mdi-account-cog</v-icon>
                  編集する
                </template>
              </NormalButton>
              <p class="text-body2">
                パスワードを変更する場合は
                <a @click.stop="displayPasswordEditDialog"> こちら </a>
              </p>
            </v-sheet>
          </v-col>
        </v-row>
      </v-col>
      <!-- 投稿一覧 -->
      <v-col cols="12" sm="6">
        <v-row>
          <v-btn class="mr-2" outlined plain :to="{ name: 'UserProfile' }">投稿一覧</v-btn>
          <v-btn class="ml-s" outlined plain :to="{ name: 'Favorites' }">お気に入り一覧</v-btn>
        </v-row>
        <router-view />
      </v-col>
    </v-row>
    <!-- プロフィール編集フォーム -->
    <ProfileEditForm
      v-bind.sync="authUserEdit"
      :isShow="editProfileDialogDisplayed"
      :loading="profileUpdating"
      @updateProfile="updateProfile"
      @changeDialog="changeProfileToPassword"
      @closeDialog="closeEditProfileDialog"
    />
    <!-- パスワード編集フォーム -->
    <PasswordEditForm
      v-bind.sync="passwordEdit"
      :isShow="editPasswordDialogDisplayed"
      @updatePassword="updatePassword"
      @changeDialog="changePasswordToProfile"
      @closeDialog="closeEditPasswordDialog"
    />
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import Jimp from 'jimp/es';

import NormalButton from '../../parts/buttons/NormalButton';
import PasswordEditForm from '../../parts/forms/PasswordEditForm';
import ProfileEditForm from '../../parts/forms/ProfileEditForm';

export default {
  components: {
    NormalButton,
    PasswordEditForm,
    ProfileEditForm,
  },
  data() {
    return {
      authUserEdit: {
        id: '',
        nickname: '',
        email: '',
        avatar: '',
      },
      passwordEdit: {
        password: '',
        password_confirmation: '',
      },
      editProfileDialogDisplayed: false,
      editPasswordDialogDisplayed: false,
      profileUpdating: false,
    };
  },
  computed: {
    ...mapGetters('users', ['authUser']),
  },
  methods: {
    ...mapActions('users', ['updateAuthUser']),
    ...mapActions('snackbars', ['fetchSnackbarData']),

    displayProfileEditDialog() {
      this.initAuthUserEdit();
      this.editProfileDialogDisplayed = true;
    },
    closeEditProfileDialog() {
      this.editProfileDialogDisplayed = false;
    },

    displayPasswordEditDialog() {
      this.editPasswordDialogDisplayed = true;
    },
    closeEditPasswordDialog() {
      this.editPasswordDialogDisplayed = false;
      this.passwordEdit.password_confirmation = '';
      this.passwordEdit.password = '';
    },

    changeProfileToPassword() {
      this.closeEditProfileDialog();
      this.displayPasswordEditDialog();
    },
    changePasswordToProfile() {
      this.closeEditPasswordDialog();
      this.displayProfileEditDialog();
    },

    updateProfile() {
      this.profileUpdating = true;
      this.updateAuthUser(this.authUserEdit).then((user) => {
        if (user) {
          this.closeEditProfileDialog();
          this.profileUpdating = false;
          this.fetchSnackbarData({
            msg: 'プロフィールを更新しました',
            color: 'success',
            isShow: true,
          });
        } else {
          this.profileUpdating = false;
          this.fetchSnackbarData({
            msg: 'プロフィールを更新できませんでした',
            color: 'error',
            isShow: true,
          });
        }
      });
    },
    updatePassword() {
      this.$devour
        .request(
          `${this.$devour.apiUrl}/auth_user/password`,
          'PATCH',
          {},
          { password: this.password, password_confirmation: this.password_confirmation }
        )
        .then(() => {
          this.fetchSnackbarData({
            msg: 'パスワードを更新しました',
            color: 'success',
            isShow: true,
          });
          this.closeEditPasswordDialog();
        })
        .catch((err) => {
          this.fetchSnackbarData({
            msg: 'パスワードの更新に失敗しました',
            color: 'error',
            isShow: true,
          });
          console.log(err);
        });
    },
    initAuthUserEdit() {
      this.authUserEdit = { ...this.authUser };
      // base64でencodeしてないとサーバー側でdecodeする際にerror
      Jimp.read(this.authUserEdit.avatar).then((image) => {
        image.getBase64(Jimp.MIME_PNG, (err, src) => {
          this.authUserEdit.avatar = src;
        });
      });
    },
  },
};
</script>
