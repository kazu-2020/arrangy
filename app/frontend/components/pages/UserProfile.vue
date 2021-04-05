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
            <!-- プロフィール編集フォーム -->
            <ProfileEditForm
              v-bind.sync="authUserEdit"
              :isShow="editProfileDialogDisplayed"
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
          </v-col>
        </v-row>
      </v-col>
      <!-- 投稿一覧 -->
      <v-col cols="12" sm="6">
        <v-row>
          <div class="text-h6 font-weight-black mb-8 mx-auto">投稿一覧</div>
        </v-row>
        <v-row>
          <template v-if="arrangements.length">
            <v-col
              v-for="(arrangement, $index) in arrangements"
              :key="$index"
              cols="12"
              sm="4"
              md="4"
              style="position: relative"
            >
              <ArrangementSummary :arrangement="arrangement" />
              <InitializedMenu :outlined="true" :absolute="true" class="initialized-menu">
                <template #btn-text>
                  <v-icon id="arrangement-menu-icon">mdi-dots-vertical</v-icon>
                </template>
                <template #list>
                  <v-list id="arrangement-menu-list" dense>
                    <v-list-item tag="button" @click="displayArrangementEditDialog(arrangement)">
                      編集する
                    </v-list-item>
                    <v-list-item
                      tag="button"
                      @click.stop="displayDeleteArrangementDialog(arrangement)"
                    >
                      削除する
                    </v-list-item>
                  </v-list>
                </template>
              </InitializedMenu>
            </v-col>

            <ArrangementEditForm
              :isShow="editArrangementDialogDisplayed"
              v-bind.sync="arrangementEdit"
              @uploadFile="uploadFile"
              @updateArrangement="updateArrangement"
              @closeDialog="closeEditArrangement"
            />

            <DeleteConfirmationDialog
              :isShow="deleteArrangementDialogDisplayed"
              @deleteData="deleteArrangement"
              @closeDialog="closeDeleteArrangementDialog"
            >
              <template #title>投稿を削除する</template>
              <template #text>
                この投稿を本当に削除しますか？削除後は元に戻すことはできません。
              </template>
            </DeleteConfirmationDialog>

            <infinite-loading
              v-if="pagy.isActioned"
              direction="bottom"
              spinner="circles"
              @infinite="infiniteHandler"
            >
              <div slot="no-more" />
            </infinite-loading>
          </template>

          <v-col v-else cols="12" class="text-center">
            <p>現在、投稿はありません</p>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import Jimp from 'jimp/es';

import ArrangementSummary from '../parts/cards/ArrangementSummary';
import ArrangementEditForm from '../parts/forms/ArrangementEditForm';
import DeleteConfirmationDialog from '../parts/dialogs/DeleteConfirmationDialog';
import ProfileEditForm from '../parts/forms/ProfileEditForm';
import PasswordEditForm from '../parts/forms/PasswordEditForm';
import InitializedMenu from '../parts/menus/InitializedMenu';
import NormalButton from '../parts/buttons/NormalButton';

export default {
  components: {
    ArrangementEditForm,
    ArrangementSummary,
    DeleteConfirmationDialog,
    ProfileEditForm,
    PasswordEditForm,
    NormalButton,
    InitializedMenu,
  },
  data() {
    return {
      authUserEdit: {
        id: '',
        nickname: '',
        email: '',
        avatar: '',
      },
      arrangements: [],
      arrangementEdit: {
        id: '',
        title: '',
        context: '',
        images: [],
      },
      passwordEdit: {
        password: '',
        password_confirmation: '',
      },
      pagy: {
        currentPage: 1,
        isActioned: false,
      },
      deletedArrangement: {},
      editArrangementDialogDisplayed: false,
      editProfileDialogDisplayed: false,
      editPasswordDialogDisplayed: false,
      deleteArrangementDialogDisplayed: false,
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
        if (res.meta.pagy.pages !== 1) {
          this.pagy.isActioned = true;
        }
      });
  },
  methods: {
    ...mapActions('users', ['updateAuthUser']),
    ...mapActions('snackbars', ['fetchSnackbarData']),
    displayProfileEditDialog() {
      this.initAuthUserEdit();
      this.handleShowEditProfile();
    },
    displayPasswordEditDialog() {
      this.handleShowEditPassword();
    },
    closeEditPasswordDialog() {
      this.handleShowEditPassword();
      this.passwordEdit.password_confirmation = '';
      this.passwordEdit.password = '';
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

    displayArrangementEditDialog(arrangement) {
      this.initArrangement(arrangement);
      this.handleShowEditArrangement();
    },
    handleShowEditArrangement() {
      this.editArrangementDialogDisplayed = !this.editArrangementDialogDisplayed;
    },
    closeEditArrangement() {
      this.handleShowEditArrangement();
    },
    uploadFile(src) {
      this.arrangementEdit.images.splice(0, 1, src);
    },
    updateArrangement() {
      this.$devour
        .update('arrangement', this.arrangementEdit)
        .then((res) => {
          const index = this.arrangements.findIndex(
            (arrangement) => arrangement.id === res.data.id
          );
          this.arrangements.splice(index, 1, res.data);
          this.closeEditArrangement();
          this.fetchSnackbarData({
            msg: '投稿を更新しました',
            color: 'success',
            isShow: true,
          });
        })
        .catch((err) => {
          this.fetchSnackbarData({
            msg: '投稿を更新できませんでした',
            color: 'error',
            isShow: true,
          });
          console.log(err);
        });
    },

    displayDeleteArrangementDialog(arrangement) {
      this.deletedArrangement = { ...arrangement };
      this.deleteArrangementDialogDisplayed = true;
    },

    closeDeleteArrangementDialog() {
      this.deleteArrangementDialogDisplayed = false;
    },

    deleteArrangement() {
      this.$devour.destroy('arrangement', this.deletedArrangement.id).then(() => {
        const index = this.arrangements.findIndex(
          (arrangement) => arrangement.id === this.deletedArrangement.id
        );
        this.arrangements.splice(index, 1);
        this.closeDeleteArrangementDialog();
        this.fetchSnackbarData({
          msg: '投稿を削除しました',
          color: 'success',
          isShow: true,
        });
      });
    },

    initArrangement(arrangement) {
      this.arrangementEdit = { ...arrangement, images: [...arrangement.images] };
      Jimp.read(this.arrangementEdit.images[0]).then((image) => {
        image.getBase64(Jimp.MIME_PNG, (err, src) => this.arrangementEdit.images.splice(0, 1, src));
      });
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
  },
};
</script>
