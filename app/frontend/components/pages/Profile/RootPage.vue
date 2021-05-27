<template>
  <v-container fluid>
    <v-row class="pt-5 pt-md-16">
      <v-col cols="12" sm="5">
        <v-row class="d-flex justify-center">
          <v-col id="myprofile" cols="12" sm="8" class="text-center">
            <div>
              <v-avatar tile size="150" color="mb-3">
                <v-img :src="authUser.avatar_url" />
              </v-avatar>
              <div class="text-h6 font-weight-medium">{{ authUser.nickname }}</div>
              <div class="text-subtitle-1">{{ authUser.email }}</div>
            </div>
            <v-simple-table class="mb-5" style="background-color: #eeeeee">
              <template #default>
                <thead>
                  <tr>
                    <th class="text-left"></th>
                    <th class="text-left"></th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>投稿数</td>
                    <td>{{ authUser.arrangements_count }}</td>
                  </tr>
                  <tr>
                    <td>うまいいね数</td>
                    <td>{{ authUser.likes_count }}</td>
                  </tr>
                </tbody>
              </template>
            </v-simple-table>

            <NormalButton class="mb-6" :xLarge="true" @click="displayProfileEditDialog">
              <template #text>
                <v-icon class="mr-1">mdi-account-cog</v-icon>
                編集する
              </template>
            </NormalButton>
            <p class="text-body2">
              パスワードを変更する場合は
              <a style="color: #cc3918" @click.stop="displayPasswordEditDialog"> こちら </a>
            </p>
            <SubmitButton :xLarge="true" :color="'#cc3918'" @submit="handleDestroyUser">
              <template #text> 退会する </template>
            </SubmitButton>
          </v-col>
        </v-row>
      </v-col>

      <v-col cols="12" sm="6">
        <v-row>
          <v-btn class="mr-2" outlined :to="{ name: 'UserProfile' }" exact>投稿一覧</v-btn>
          <v-btn class="ml-s" outlined :to="{ name: 'Favorites' }" exact>お気に入り一覧</v-btn>
        </v-row>
        <!-- 投稿一覧 お気に入り一覧-->
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

import NormalButton from '../../parts/buttons/NormalButton';
import PasswordEditForm from '../../parts/forms/PasswordEditForm';
import ProfileEditForm from '../../parts/forms/ProfileEditForm';
import SubmitButton from '../../parts/buttons/SubmitButton';

export default {
  components: {
    NormalButton,
    PasswordEditForm,
    ProfileEditForm,
    SubmitButton,
  },
  data() {
    return {
      authUserEdit: {
        id: '',
        nickname: '',
        email: '',
        avatar_url: '',
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
  head: {
    title() {
      return {
        inner: `${this.authUser.nickname}さんのページ`,
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
    ...mapGetters('users', ['authUser']),
    siteDescription() {
      return 'Arrangy(アレンジー)はアレンジ飯の共有サービスです。コンビニ商品や外食店の料理を使用したアレンジ飯を「知りたい」「共有したい」という方達は、是非覗いてみてください!!';
    },
  },
  updated() {
    this.$emit('updateHead');
  },
  methods: {
    ...mapActions('users', ['updateAuthUser', 'destroyUser']),
    ...mapActions('snackbars', ['fetchSnackbarData']),

    displayProfileEditDialog() {
      this.authUserEdit = { ...this.authUser };
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
        .request(`${this.$devour.apiUrl}/auth_user/password`, 'PATCH', {}, this.passwordEdit)
        .then(() => {
          this.fetchSnackbarData({
            msg: 'パスワードを更新しました',
            color: 'success',
            isShow: true,
          });
          this.closeEditPasswordDialog();
        })
        .catch(() => {
          this.fetchSnackbarData({
            msg: 'パスワードの更新に失敗しました',
            color: 'error',
            isShow: true,
          });
        });
    },
    handleDestroyUser() {
      this.destroyUser(this.authUser).then(() => {
        this.$router.push({ name: 'TopPage' });
        this.fetchSnackbarData({
          msg: '退会しました',
          color: 'success',
          isShow: true,
        });
      });
    },
  },
};
</script>
