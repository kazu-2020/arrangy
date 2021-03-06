<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12" sm="6">
        <v-row class="d-flex justify-center">
          <v-col cols="12" sm="8" class="pt-16">
            <v-sheet id="profile-sheet" class="py-6 px-10 text-center" elevation="1">
              <h3 class="text-h6 font-weight-black mb-8">マイプロフィール</h3>
              <v-avatar class="or-avatar mb-5" size="200">
                <img :src="authUser.avatar" />
              </v-avatar>
              <div class="text-left mb-6">
                <div>
                  <h3 class="text-subtitle-1 font-weight-black">ニックネーム</h3>
                  <div>{{ authUser.nickname }}</div>
                </div>
                <v-divider class="mb-6" />
                <div>
                  <h3 class="text-subtitle-1 font-weight-black">メールアドレス</h3>
                  <div>{{ authUser.email }}</div>
                </div>
                <v-divider class="mb-6" />
              </div>
              <v-btn class="mb-6" xLarge @click.stop="displayProfileEditDialog">
                <v-icon class="mr-1">mdi-account-cog</v-icon>
                編集する
              </v-btn>
              <p class="text-body2">
                パスワードを変更する場合は
                <a @click.stop="displayPasswordEditDialog"> こちら </a>
              </p>
            </v-sheet>
            <!-- プロフィール編集フォーム -->
            <ProfileEditForm
              v-if="editProfileActed"
              v-bind.sync="authUserEdit"
              :isShow.sync="editProfileDialogDisplayed"
              @updateProfile="updateProfile"
              @changeDialog="changeProfileToPassword"
              @closeDialog="closeEditProfileDialog"
            />
            <!-- パスワード編集フォーム -->
            <PasswordEditForm
              v-if="editPasswordActed"
              :password.sync="password"
              :passwordConfirmation.sync="password_confirmation"
              :isShow.sync="editPasswordDialogDisplayed"
              @updatePassword="updatePassword"
              @changeDialog="changePasswordToProfile"
              @closeDialog="closeEditPasswordDialog"
            />
          </v-col>
        </v-row>
      </v-col>
      <!-- 投稿一覧 -->
      <v-col cols="12" sm="6" class="pt-16">
        <v-row>
          <h3 class="text-h6 font-weight-black mb-8 mx-auto">投稿一覧</h3>
        </v-row>
        <v-row>
          <v-col
            v-for="(arrangement, $index) in arrangements"
            :key="$index"
            cols="12"
            sm="4"
            md="4"
          >
            <ArrangementSummary :arrangement="arrangement" :user="authUser" />
          </v-col>
          <infinite-loading
            v-if="pagy.isActioned"
            direction="bottom"
            spinner="circles"
            @infinite="infiniteHandler"
          >
            <div slot="no-more" />
          </infinite-loading>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import Jimp from 'jimp/es';
import ProfileEditForm from '../parts/forms/ProfileEditForm';
import PasswordEditForm from '../parts/forms/PasswordEditForm';
import ArrangementSummary from '../parts/cards/ArrangementSummary';

export default {
  components: {
    ProfileEditForm,
    PasswordEditForm,
    ArrangementSummary,
  },
  data() {
    return {
      authUserEdit: {},
      arrangements: [],
      password: '',
      password_confirmation: '',
      editProfileActed: false,
      editPasswordActed: false,
      editProfileDialogDisplayed: false,
      editPasswordDialogDisplayed: false,
      pagy: {
        currentPage: 1,
        isActioned: false,
      },
    };
  },
  computed: {
    ...mapGetters('users', ['authUser']),
  },
  created() {
    this.$devour
      .request(`${this.$devour.apiUrl}/arrangements/mine`, 'GET', { page: this.pagy.currentPage })
      .then((res) => {
        this.arrangements = res.data;
        this.pagy.currentPage += 1;
        this.pagy.isActioned = true;
      });
  },
  methods: {
    ...mapActions('users', ['updateAuthUser']),
    ...mapActions('snackbars', ['fetchSnackbarData']),
    displayProfileEditDialog() {
      this.initAuthUserEdit();
      this.handleShowEditProfile();
      this.editProfileActed = true;
    },
    displayPasswordEditDialog() {
      this.handleShowEditPassword();
      this.editPasswordActed = true;
    },
    closeEditPasswordDialog() {
      this.handleShowEditPassword();
      this.password = '';
      this.password_confirmation = '';
    },
    closeEditProfileDialog() {
      this.handleShowEditProfile();
    },
    changeProfileToPassword() {
      this.closeEditProfileDialog();
      this.displayPasswordEditDialog();
    },
    changePasswordToProfile() {
      this.closeEditPasswordDialog();
      this.displayProfileEditDialog();
    },
    handleShowEditPassword() {
      this.editPasswordDialogDisplayed = !this.editPasswordDialogDisplayed;
    },
    handleShowEditProfile() {
      this.editProfileDialogDisplayed = !this.editProfileDialogDisplayed;
    },
    infiniteHandler($state) {
      this.$devour
        .request(`${this.$devour.apiUrl}/arrangements/mine`, 'GET', { page: this.pagy.currentPage })
        .then((res) => {
          if (this.pagy.currentPage < res.meta.pagy.pages) {
            this.pagy.currentPage += 1;
            this.arrangements.push(...res.data);
            $state.loaded();
          } else {
            this.arrangements.push(...res.data);
            $state.complete();
          }
        })
        .catch((err) => console.log(err));
    },
    updateProfile() {
      this.updateAuthUser(this.authUserEdit).then((user) => {
        if (user) {
          this.handleShowEditProfile();
          this.fetchSnackbarData({
            msg: 'プロフィールを更新しました',
            color: 'success',
            isShow: true,
          });
        } else {
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
          `${this.$devour.apiUrl}/profile/password`,
          'PATCH',
          {},
          { password: this.password, password_confirmation: this.password_confirmation }
        )
        .then(() => {
          this.handleShowEditPassword();
          this.fetchSnackbarData({
            msg: 'パスワードを更新しました',
            color: 'success',
            isShow: true,
          });
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
