<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12" sm="6" class="pt-16 px-sm-16">
        <v-row justify="center" noGutters>
          <v-col cols="12" sm="10">
            <v-card
              :id="`arrangement-${arrangement.id}`"
              class="mx-auto"
              color="#eeeeee"
              elevation="1"
            >
              <v-img
                v-for="(image, $imageIndex) in arrangement.images"
                :key="$imageIndex"
                :src="image"
              />
              <v-card-title class="mb-4">
                <h4 class="text-subtitle-1 font-weight-bold">{{ arrangement.title }}</h4>
              </v-card-title>
              <v-card-subtitle class="d-flex">
                <v-avatar size="25" class="mr-4">
                  <img :src="arrangement.user.avatar" />
                </v-avatar>
                <h4 class="text-subtitle-1">
                  {{ arrangement.user.nickname }}
                </h4>
                <v-spacer />
                <template v-if="authUser && authUser.id === arrangement.user.id">
                  <!-- メニューリスト -->
                  <v-menu rounded left>
                    <template #activator="{ on, attrs }">
                      <v-btn id="menu-icon" icon v-bind="attrs" v-on="on">
                        <v-icon>mdi-dots-vertical</v-icon>
                      </v-btn>
                    </template>

                    <v-list id="arrangement-menu-list" dense>
                      <v-list-item @click.stop="displayArrangementEditDialog">
                        編集する
                      </v-list-item>
                      <v-list-item @click.stop="displayArrangementDeleteDialog">
                        削除する
                      </v-list-item>
                    </v-list>
                  </v-menu>
                </template>
              </v-card-subtitle>
              <v-card-text>
                <v-sheet class="pa-5" :rounded="true" outlined color="#FAFAFA">
                  <pre class="text-body-1">{{ arrangement.context }}</pre>
                </v-sheet>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
        <!-- 投稿編集用ダイアログ -->
        <ArrangementEditForm
          v-if="editArrangementActed"
          :isShow="editArrangementDialogDisplayed"
          v-bind.sync="arrangementEdit"
          @uploadFile="uploadFile"
          @closeDialog="closeEditArrangement"
          @updateArrangement="updateArrangement"
        />
        <!-- 投稿削除確認用ダイアログ -->
        <ConfirmationDialog
          :isShow="confirmationDialogDisplayed"
          @closeDialog="closeConfirmationDialog"
          @deleteArrangement="deleteArrangement"
        />
      </v-col>

      <v-col cols="12" sm="6" class="pt-16 px-sm-16">
        <!-- コメント作成フォーム -->
        <CommentCreateForm v-bind.sync="commentCreate" @createComment="createComment" />
        <!-- コメント一覧 -->
        <template v-if="comments.length">
          <v-sheet>
            <v-col v-for="(comment, $index) in comments" :key="$index" cols="12" class="pa-0">
              <v-sheet class="pa-5 d-flex" color="">
                <v-avatar size="25" class="mr-4">
                  <img :src="comment.user.avatar" />
                </v-avatar>
                <div>
                  <div class="d-flex">
                    <p class="text-subtitle-1 font-weight-bold mr-3">
                      {{ comment.user.nickname }}
                    </p>
                    <p class="text-caption ont-weight-light">
                      {{ comment.created_at }}
                    </p>
                  </div>
                  <pre class="text-body-1">{{ comment.body }}</pre>
                </div>
              </v-sheet>
              <v-divider />
            </v-col>
            <infinite-loading
              v-if="pagy.isActioned"
              direction="bottom"
              spinner="circles"
              @infinite="infiniteHandler"
            >
              <div slot="no-more" />
            </infinite-loading>
          </v-sheet>
        </template>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import Jimp from 'jimp/es';
import ArrangementEditForm from '../parts/forms/ArrangementEditForm';
import ConfirmationDialog from '../parts/dialogs/ConfirmationDialog';
import CommentCreateForm from '../parts/forms/CommentCreateForm';

export default {
  components: {
    ArrangementEditForm,
    ConfirmationDialog,
    CommentCreateForm,
  },
  data() {
    return {
      arrangement: {
        id: '',
        title: '',
        context: '',
        images: [],
        user: {
          nickname: '',
          avatar: '',
        },
      },
      comments: [],
      arrangementEdit: {},
      commentCreate: {
        body: '',
      },
      pagy: {
        currentPage: 1,
        isActioned: false,
      },
      editArrangementDialogDisplayed: false,
      confirmationDialogDisplayed: false,
      editArrangementActed: false,
    };
  },
  computed: {
    ...mapGetters('users', ['authUser']),
  },
  created() {
    this.fetchArrangement();
    this.fetchComment();
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    fetchArrangement() {
      this.$devour
        .find('arrangement', this.$route.params.id)
        .then((res) => (this.arrangement = res.data));
    },
    fetchComment() {
      this.$devour
        .one('arrangement', this.$route.params.id)
        .all('comment')
        .get()
        .then((res) => {
          this.comments.push(...res.data);
          this.pagy.currentPage += 1;
          if (res.meta.pagy.pages !== 1) {
            this.pagy.isActioned = true;
          }
        });
    },
    displayArrangementEditDialog() {
      this.initArrangement();
      this.handleShowEditArrangement();
      this.editArrangementActed = true;
    },
    closeEditArrangement() {
      this.handleShowEditArrangement();
    },
    closeConfirmationDialog() {
      this.confirmationDialogDisplayed = false;
    },
    handleShowEditArrangement() {
      this.editArrangementDialogDisplayed = !this.editArrangementDialogDisplayed;
    },
    initArrangement() {
      this.arrangementEdit = { ...this.arrangement, images: [...this.arrangement.images] };
      Jimp.read(this.arrangementEdit.images[0]).then((image) => {
        image.getBase64(Jimp.MIME_PNG, (err, src) => this.arrangementEdit.images.splice(0, 1, src));
      });
    },
    uploadFile(src) {
      this.arrangementEdit.images.splice(0, 1, src);
    },
    updateArrangement() {
      this.$devour
        .update('arrangement', this.arrangementEdit)
        .then((res) => {
          this.arrangement = res.data;
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
    displayArrangementDeleteDialog() {
      this.confirmationDialogDisplayed = true;
    },
    deleteArrangement() {
      this.$devour.destroy('arrangement', this.$route.params.id).then(() => {
        this.fetchSnackbarData({
          msg: '投稿を削除しました',
          color: 'success',
          isShow: true,
        });
        this.$router.push({ name: 'UserProfile' });
      });
    },
    createComment() {
      this.$devour
        .one('arrangement', this.arrangement.id)
        .all('comment')
        .post(this.commentCreate)
        .then((res) => {
          this.comments.unshift(res.data);
          this.commentCreate.body = '';
        });
    },
    infiniteHandler($state) {
      this.$devour
        .one('arrangement', this.$route.params.id)
        .all('comment')
        .get()
        .then((res) => {
          if (this.pagy.currentPage < res.meta.pagy.pages) {
            this.pagy.currentPage += 1;
            this.comments.push(...res.data);
            $state.loaded();
          } else {
            this.comments.push(...res.data);
            $state.complete();
          }
        })
        .catch((err) => console.log(err));
    },
  },
};
</script>

<style scoped>
pre {
  white-space: pre-wrap;
  word-break: break-all;
  word-wrap: break-word;
}
</style>
