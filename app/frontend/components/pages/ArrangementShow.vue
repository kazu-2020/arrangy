<template>
  <v-container>
    <v-row>
      <v-col class="pt-10 d-flex" cols="12">
        <h4 class="text-h4 mb-4 font-weight-black">
          {{ arrangement.title }}
        </h4>
      </v-col>
    </v-row>
    <v-row>
      <v-col :id="`arrangement-${arrangement.id}`" cols="12" sm="6">
        <v-img v-for="(image, $imageIndex) in arrangement.images" :key="$imageIndex" :src="image">
          <div v-if="authUser && authUser.id === arrangement.user.id" class="text-end">
            <InitializedMenu :outlined="true" :left="true">
              <template #btn-text>
                <v-icon id="arrangement-menu-icon">mdi-dots-vertical</v-icon>
              </template>
              <template #list>
                <v-list id="arrangement-menu-list" dense>
                  <v-list-item tag="button" @click.stop="displayArrangementEditDialog">
                    編集する
                  </v-list-item>
                  <v-list-item tag="button" @click.stop="displayDeleteArrangementDialog">
                    削除する
                  </v-list-item>
                </v-list>
              </template>
            </InitializedMenu>
          </div>
        </v-img>
        <v-row>
          <v-col cols="auto">
            {{ arrangement.created_at }}
          </v-col>
          <v-col> </v-col>
        </v-row>
      </v-col>
      <v-col cols="12" sm="6">
        <v-row class="mb-3">
          <v-col cols="auto">
            <v-avatar>
              <v-img :src="arrangement.user.avatar" />
            </v-avatar>
          </v-col>
          <v-col cols="auto">
            <h6 class="text-subtitle-1 font-weight-black">
              {{ arrangement.user.nickname }}
            </h6>
          </v-col>
          <v-col class="text-end">
            <!-- いいねボタン -->
            <SubmitButton
              :color="arrangement.liked_authuser ? '#ff5252' : null"
              @submit="handleLikedArrangement"
            >
              <template #text>
                <v-icon class="mr-1"> mdi-thumb-up-outline </v-icon>
                うまいいね
                {{ arrangement.likes_count }}
              </template>
            </SubmitButton>
          </v-col>
        </v-row>
        <v-sheet class="pa-5" :rounded="true" outlined color="#F5F5F5">
          <pre class="text-body-1">{{ arrangement.context }}</pre>
        </v-sheet>
      </v-col>
      <!-- 投稿編集用ダイアログ -->
      <ArrangementEditForm
        :isShow="editArrangementDialogDisplayed"
        v-bind.sync="arrangementEdit"
        @uploadFile="uploadFile"
        @updateArrangement="updateArrangement"
        @closeDialog="closeEditArrangement"
      />
      <!-- 投稿削除用ダイアログ -->
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
    </v-row>

    <v-row>
      <v-col cols="12" sm="8" class="mx-auto">
        <!-- コメント入力フォーム -->
        <template v-if="authUser">
          <CommentCreateForm v-bind.sync="commentCreate" @createComment="createComment" />
        </template>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="8" class="mx-auto">
        <template v-if="comments.length">
          <v-row class="d-flex flex-column">
            <v-col
              v-for="(comment, $index) in comments"
              :id="`comment-${comment.id}`"
              :key="$index"
              cols="12"
              class="mb-3"
            >
              <v-row>
                <v-col cols="auto">
                  <v-avatar>
                    <v-img :src="comment.user.avatar" />
                  </v-avatar>
                </v-col>
                <v-col cols="auto">
                  <h6 class="text-subtitle-1 font-weight-black">
                    {{ comment.user.nickname }}
                  </h6>
                </v-col>
                <v-col>
                  <p class="text-caption font-weight-light pt-1">
                    {{ comment.created_at }}
                  </p>
                </v-col>
                <v-col class="text-end">
                  <!-- メニューリスト -->
                  <div v-if="authUser && authUser.id === comment.user.id">
                    <InitializedMenu :left="true">
                      <template #btn-text>
                        <v-icon class="comment-menu-icon">mdi-dots-vertical</v-icon>
                      </template>
                      <template #list>
                        <v-list class="comment-menu-list" dense>
                          <v-list-item tag="button" @click.stop="displayCommentEditDialog(comment)">
                            編集する
                          </v-list-item>
                          <v-list-item
                            tag="button"
                            @click.stop="displayCommentDeleteDialog(comment)"
                          >
                            削除する
                          </v-list-item>
                        </v-list>
                      </template>
                    </InitializedMenu>
                  </div>
                </v-col>
              </v-row>
              <v-row class="d-flex justify-end">
                <v-col cols="11" class="py-0">
                  <v-sheet class="pa-5" :rounded="true" outlined color="#F5F5F5">
                    <pre
                      class="text-body-1">{{ comment.body }}<span v-if="comment.edited" class="text-caption font-weight-light">(編集済み)</span></pre>
                  </v-sheet>
                </v-col>
              </v-row>
            </v-col>

            <infinite-loading
              v-if="pagy.isActioned"
              direction="bottom"
              spinner="circles"
              @infinite="infiniteHandler"
            >
              <div slot="no-more" />
            </infinite-loading>

            <!-- コメント編集用フォーム -->
            <CommentEditForm
              :isShow="editCommentDialogDisplayed"
              v-bind.sync="commentEdit"
              @updateComment="updateComment"
              @closeDialog="closeEditComment"
            />
            <!-- コメント削除用ダイアログ -->
            <DeleteConfirmationDialog
              :isShow="deleteCommentDialogDisplayed"
              @closeDialog="closeDeleteComment"
              @deleteData="deleteComment"
            >
              <template #title>コメントを削除する</template>
              <template #text>
                このコメントを本当に削除しますか？削除後は元に戻すことはできません。
              </template>
            </DeleteConfirmationDialog>
          </v-row>
        </template>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import Jimp from 'jimp/es';
import ArrangementEditForm from '../parts/forms/ArrangementEditForm';
import DeleteConfirmationDialog from '../parts/dialogs/DeleteConfirmationDialog';
import CommentCreateForm from '../parts/forms/CommentCreateForm';
import CommentEditForm from '../parts/forms/CommentEditForm';
import InitializedMenu from '../parts/menus/InitializedMenu';
import SubmitButton from '../parts/buttons/SubmitButton';

export default {
  components: {
    ArrangementEditForm,
    DeleteConfirmationDialog,
    CommentCreateForm,
    CommentEditForm,
    InitializedMenu,
    SubmitButton,
  },
  data() {
    return {
      arrangement: {
        id: '',
        title: '',
        context: '',
        images: [],
        created_at: '',
        liked_authuser: '',
        likes_count: '',
        user: {
          nickname: '',
          avatar: '',
        },
      },
      arrangementEdit: {
        id: '',
        title: '',
        context: '',
        images: [],
      },
      comments: [],
      commentCreate: {
        body: '',
      },
      commentEdit: {
        id: '',
        body: '',
      },
      deletedComment: {},
      pagy: {
        currentPage: 1,
        isActioned: false,
      },
      editArrangementDialogDisplayed: false,
      editCommentDialogDisplayed: false,
      deleteCommentDialogDisplayed: false,
      deleteArrangementDialogDisplayed: false,
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
    },
    displayCommentEditDialog(comment) {
      this.commentEdit = { ...comment };
      this.handleShowEditComment();
    },
    displayDeleteArrangementDialog() {
      this.deleteArrangementDialogDisplayed = true;
    },
    displayCommentDeleteDialog(comment) {
      this.deletedComment = { ...comment };
      this.deleteCommentDialogDisplayed = true;
    },
    closeEditArrangement() {
      this.handleShowEditArrangement();
    },
    closeEditComment() {
      this.handleShowEditComment();
    },
    closeDeleteArrangementDialog() {
      this.deleteArrangementDialogDisplayed = false;
    },
    closeDeleteComment() {
      this.deleteCommentDialogDisplayed = false;
    },
    handleShowEditArrangement() {
      this.editArrangementDialogDisplayed = !this.editArrangementDialogDisplayed;
    },
    handleShowEditComment() {
      this.editCommentDialogDisplayed = !this.editCommentDialogDisplayed;
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
    updateComment() {
      this.$devour
        .update('comment', this.commentEdit)
        .then((res) => {
          const index = this.comments.findIndex((comment) => comment.id === res.data.id);
          this.comments.splice(index, 1, res.data);
          this.handleShowEditComment();
        })
        .catch((err) => console.log(err));
    },
    deleteComment() {
      this.$devour.destroy('comment', this.deletedComment.id).then(() => {
        const index = this.comments.findIndex((comment) => comment.id === this.deletedComment.id);
        this.comments.splice(index, 1);
        this.deleteCommentDialogDisplayed = false;
        this.fetchSnackbarData({
          msg: 'コメントを削除しました',
          color: 'success',
          isShow: true,
        });
      });
    },

    handleLikedArrangement() {
      if (this.arrangement.liked_authuser) {
        this.$devour
          .one('arrangement', this.arrangement.id)
          .all('like')
          .destroy()
          .then(() => {
            this.arrangement.liked_authuser = false;
            this.arrangement.likes_count -= 1;
          });
      } else {
        this.$devour
          .one('arrangement', this.arrangement.id)
          .all('like')
          .post({})
          .then(() => {
            this.arrangement.liked_authuser = true;
            this.arrangement.likes_count += 1;
          });
      }
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
