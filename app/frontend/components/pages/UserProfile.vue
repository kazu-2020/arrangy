<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12" sm="6">
        <v-row class="d-flex justify-center">
          <v-col cols="12" sm="8" class="pt-16">
            <v-sheet id="profile-sheet" class="pt-6 px-10 text-center" elevation="1">
              <h3 class="text-h6 font-weight-black mb-8">マイプロフィール</h3>
              <v-avatar class="mb-5" size="200">
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
              <v-btn class="mb-6" x-large @click.stop="showEditDialog">
                <v-icon class="mr-1">mdi-account-cog</v-icon>
                編集する
              </v-btn>
            </v-sheet>
            <ProfileEditForm
              v-if="isVisibleDialog"
              :is_show.sync="isShow"
              class="hoge"
              v-bind.sync="authUserEdit"
              @updateUser="updateFunction"
              @closeDialog="isShow = false"
            />
          </v-col>
        </v-row>
      </v-col>

      <v-col cols="12" sm="6"> hoge </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import ProfileEditForm from '../parts/forms/ProfileEditForm.vue';

export default {
  components: {
    ProfileEditForm,
  },
  data() {
    return {
      isVisibleDialog: false,
      isShow: false,
      authUserEdit: {},
    };
  },
  computed: {
    ...mapGetters('users', ['authUser']),
  },
  methods: {
    ...mapActions('users', ['updateAuthUser']),
    ...mapActions('snackbars', ['fetchSnackbarData']),
    showEditDialog() {
      this.authUserEdit = { ...this.authUser };
      this.isShow = true;
      this.isVisibleDialog = true;
      this.$nextTick(function () {
        // children指定するのは変更に弱そう...
        this.$children[1].$refs.pond.addFile(this.authUserEdit.avatar);
      });
    },
    updateFunction() {
      this.updateAuthUser(this.authUserEdit).then((user) => {
        if (user) {
          this.isShow = false;
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
  },
};
</script>
