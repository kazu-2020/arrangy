<template>
  <v-container :id="`arrangement-${arrangementInformation.id}`">
    <v-row class="pt-10">
      <v-col
        class="text-justify text-h4 font-weight-black"
        style="word-break: break-all"
        cols="12"
        md
      >
        {{ arrangementInformation.title }}
      </v-col>
      <v-col cols="auto">
        <v-rating
          :length="5"
          :value="arrangementInformation.rating"
          color="orange"
          backgroundColor="orange lighten-3"
          readonly
          large
        />
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" md="5">
        <v-img
          :src="arrangementInformation.after_arrangement_photo.url"
          lazySrc="/images/dummy.png"
          style="position: relative"
        >
          <template v-if="arrangementInformation.arrange_level === 1">
            <v-avatar
              color="red"
              class="font-weight-bold"
              style="position: absolute; top: 0; left: 0; color: #ffef02"
              size="52"
            >
              激変
            </v-avatar>
          </template>
          <template v-else>
            <v-avatar
              color="#009FE8"
              class="font-weight-bold"
              style="position: absolute; top: 0; left: 0; color: #ffef02"
              size="52"
            >
              <span>ちょい足し</span>
            </v-avatar>
          </template>

          <template v-if="authUser && authUser.id === arrangementInformation.user.id">
            <InitializedMenu :absolute="true">
              <template #btn-text>
                <v-icon id="arrangement-menu-icon">mdi-dots-vertical</v-icon>
              </template>
              <template #list>
                <v-list id="arrangement-menu-list" dense>
                  <v-list-item tag="button" @click.stop="displayArrangementEditDialog">
                    <v-list-item-icon>
                      <v-icon>mdi-clipboard-edit</v-icon>
                    </v-list-item-icon>
                    <v-list-item-title> 編集する</v-list-item-title>
                  </v-list-item>
                  <v-list-item tag="button" @click.stop="displayDeleteArrangementDialog">
                    <v-list-item-icon>
                      <v-icon>mdi-trash-can-outline</v-icon>
                    </v-list-item-icon>
                    <v-list-item-title> 削除する</v-list-item-title>
                  </v-list-item>
                </v-list>
              </template>
            </InitializedMenu>
          </template>
          <v-img
            :src="arrangementInformation.before_arrangement_photo.url"
            width="25%"
            style="position: absolute; bottom: 0; right: 0"
          />

          <template #placeholder>
            <v-row class="fill-height ma-0" align="center" justify="center">
              <VueLoading type="spiningDubbles" color="#4CAF50" />
            </v-row>
          </template>
        </v-img>

        <v-row>
          <v-col cols="auto">
            {{ arrangementInformation.created_at }}
          </v-col>
        </v-row>
      </v-col>
      <v-col cols="12" md="1" />
      <v-col cols="12" md="6">
        <v-row class="">
          <v-col cols="auto pb-0">
            <v-avatar>
              <v-img :src="arrangementInformation.user.avatar_url" />
            </v-avatar>
          </v-col>
          <v-col cols="9" class="pb-0">
            <div class="text-subtitle-1 font-weight-black text-truncate">
              {{ arrangementInformation.user.nickname }}
            </div>
          </v-col>
        </v-row>
        <v-row class="d-flex justify-end">
          <v-col cols="6" md="auto">
            <!-- twitterシェアボタン -->
            <v-btn color="#1DA1F2" style="color: white" small :value="true" :href="twitterShare">
              <v-icon class="mr-1"> mdi-twitter </v-icon>
              シェアする
            </v-btn>
          </v-col>
          <v-col cols="6" md="auto">
            <!-- いいねボタン -->
            <SubmitButton
              :small="true"
              :color="arrangementInformation.liked_authuser ? '#cc3918' : null"
              :disabled="authUser ? false : true"
              @submit="handleLikedArrangement"
            >
              <template #text>
                <v-icon class="mr-1"> mdi-thumb-up-outline </v-icon>
                うまいいね
                {{ arrangementInformation.likes_count }}
              </template>
            </SubmitButton>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12">
            <v-sheet class="pa-5 mb-5" :rounded="true" outlined color="#F5F5F5">
              <pre class="text-body-1">{{ arrangementInformation.context }}</pre>
            </v-sheet>
          </v-col>
        </v-row>
      </v-col>
      <!-- 投稿編集用ダイアログ -->
      <ArrangementEditForm
        :isShow="editArrangementDialogDisplayed"
        v-bind.sync="arrangementEdit"
        :loading="arrangementEditing"
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
      <v-col cols="12" md="8" class="mx-auto">
        <!-- コメント入力フォーム -->
        <template v-if="authUser">
          <CommentCreateForm v-bind.sync="commentCreate" @createComment="createComment" />
        </template>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" md="8" class="mx-auto">
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
                    <v-img :src="comment.user.avatar_url" />
                  </v-avatar>
                </v-col>
                <v-col alignSelf="center" class="text-subtitle-1 font-weight-black text-truncate">
                  {{ comment.user.nickname }}
                </v-col>
                <v-col cols="auto" alignSelf="center">
                  <v-row>
                    <v-col
                      cols="auto"
                      class="text-caption font-weight-light pt-1 text-center"
                      alignSelf="center"
                    >
                      {{ comment.created_at }}
                    </v-col>
                    <v-col cols="auto">
                      <template v-if="authUser && authUser.id === comment.user.id">
                        <InitializedMenu>
                          <template #btn-text>
                            <v-icon class="comment-menu-icon">mdi-dots-vertical</v-icon>
                          </template>
                          <template #list>
                            <v-list class="comment-menu-list" dense>
                              <v-list-item
                                tag="button"
                                @click.stop="displayCommentEditDialog(comment)"
                              >
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
                      </template>
                    </v-col>
                  </v-row>
                </v-col>
              </v-row>
              <v-row class="d-flex justify-end">
                <v-col cols="11" class="py-0">
                  <v-sheet class="pa-5" :rounded="true" outlined color="#F5F5F5">
                    <pre class="text-body-1">{{ comment.body }}</pre>
                    <v-card-actions v-if="comment.edited">
                      <v-spacer />
                      <div class="text-caption font-weight-light">(編集済み)</div>
                    </v-card-actions>
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
        <template v-else>
          <v-row>
            <v-col cols="12" class="text-center font-weight-black">
              現在コメントはありません。
            </v-col>
          </v-row>
        </template>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';

import ArrangementEditForm from '../../parts/forms/ArrangementEditForm';
import CommentCreateForm from '../../parts/forms/CommentCreateForm';
import CommentEditForm from '../../parts/forms/CommentEditForm';
import DeleteConfirmationDialog from '../../parts/dialogs/DeleteConfirmationDialog';
import InitializedMenu from '../../parts/menus/InitializedMenu';
import SubmitButton from '../../parts/buttons/SubmitButton';

export default {
  components: {
    ArrangementEditForm,
    CommentCreateForm,
    CommentEditForm,
    DeleteConfirmationDialog,
    InitializedMenu,
    SubmitButton,
  },
  data() {
    return {
      arrangementInformation: {
        id: '',
        title: '',
        context: '',
        arrange_level: 0,
        rating: 0,
        created_at: '',
        liked_authuser: '',
        likes_count: '',
        user: {
          nickname: '',
          avatar_url: '',
        },
        after_arrangement_photo: {
          url: '',
        },
        before_arrangement_photo: {
          url: '',
        },
      },
      arrangementEdit: {
        id: '',
        title: '',
        context: '',
        arrangeLevel: 0,
        rating: 0,
        afterArrangementPhotoURL: '',
        beforeArrangementPhotoURL: '',
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
      arrangementEditing: false,
      editArrangementDialogDisplayed: false,
      editCommentDialogDisplayed: false,
      deleteCommentDialogDisplayed: false,
      deleteArrangementDialogDisplayed: false,
    };
  },
  head: {
    title() {
      return {
        inner: this.arrangementInformation.title,
        separator: '|',
        complement: 'Arrangy(アレンジー)',
      };
    },
    meta() {
      return [
        {
          name: 'description',
          content: this.arrangementInformation.context,
          id: 'description',
        },
        {
          property: 'og:url',
          content: `https://arrangy.jp/arrangements/${this.arrangementInformation.id}`,
          id: 'og-url',
        },
        {
          property: 'og:title',
          content: `${this.arrangementInformation.user.nickname}さんのアレンジ飯です | Arrangy(アレンジー)`,
          id: 'og-title',
        },
        {
          property: 'og:description',
          content: this.arrangementInformation.context,
          id: 'og-description',
        },
        {
          property: 'og:image',
          content: this.arrangementInformation.after_arrangement_photo.url,
          id: 'og-image',
        },
      ];
    },
  },
  computed: {
    ...mapGetters('users', ['authUser']),
    arrangementParams() {
      return {
        title: this.arrangementEdit.title,
        context: this.arrangementEdit.context,
        rating: this.arrangementEdit.rating,
        arrange_level: this.arrangementEdit.arrangeLevel,
      };
    },
    afterArrangementPhotoParams() {
      return {
        url: this.arrangementEdit.afterArrangementPhotoURL,
      };
    },
    beforeArrangementPhotoParams() {
      return {
        url: this.arrangementEdit.beforeArrangementPhotoURL,
      };
    },
    twitterShare() {
      const url = `https://arrangy.jp/arrangements/${this.arrangementInformation.id}`;
      return `https://twitter.com/share?text=今回、紹介するアレンジ飯は「${this.arrangementInformation.title}」です。皆さんも実際に作って食べてみてください。%0a他のアレンジ飯が気になる方は是非、Arrangy(アレンジー)にお越し下さい。&url=${url}&hashtags=Arrangy,アレンジ飯`;
    },
  },
  created() {
    this.fetchArrangement();
  },
  updated() {
    this.$emit('updateHead');
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    ...mapActions('users', ['fetchAuthUser']),

    fetchArrangement() {
      this.$devour.find('arrangement', this.$route.params.id).then((res) => {
        this.arrangementInformation = res.data;
        this.fetchComment();
      });
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
      this.arrangementEdit.id = this.arrangementInformation.id;
      this.arrangementEdit.title = this.arrangementInformation.title;
      this.arrangementEdit.context = this.arrangementInformation.context;
      this.arrangementEdit.rating = this.arrangementInformation.rating;
      this.arrangementEdit.arrangeLevel = this.arrangementInformation.arrange_level;
      this.arrangementEdit.afterArrangementPhotoURL = this.arrangementInformation.after_arrangement_photo.url;
      this.arrangementEdit.beforeArrangementPhotoURL = this.arrangementInformation.before_arrangement_photo.url;

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
    updateArrangement() {
      this.arrangementEditing = true;
      this.$devour
        .request(
          `${this.$devour.apiUrl}/arrangements/${this.arrangementEdit.id}`,
          'PATCH',
          {},
          {
            arrangement: this.arrangementParams,
            after_arrangement_photo: this.afterArrangementPhotoParams,
            before_arrangement_photo: this.beforeArrangementPhotoParams,
          }
        )
        .then((res) => {
          this.arrangementInformation = res.data;
          this.closeEditArrangement();
          this.fetchSnackbarData({
            msg: '投稿を更新しました',
            color: 'success',
            isShow: true,
          });
        })
        .catch(() => {
          this.fetchSnackbarData({
            msg: '投稿を更新できませんでした',
            color: 'error',
            isShow: true,
          });
        });
      this.arrangementEditing = false;
    },
    deleteArrangement() {
      this.$devour.destroy('arrangement', this.$route.params.id).then(() => {
        this.fetchSnackbarData({
          msg: '投稿を削除しました',
          color: 'success',
          isShow: true,
        });
        this.fetchAuthUser();
        this.$router.push({ name: 'UserProfile' });
      });
    },

    createComment() {
      this.$devour
        .one('arrangement', this.arrangementInformation.id)
        .all('comment')
        .post(this.commentCreate)
        .then((res) => {
          this.comments.unshift(res.data);
          this.commentCreate.body = '';
        });
    },
    updateComment() {
      this.$devour.update('comment', this.commentEdit).then((res) => {
        const index = this.comments.findIndex((comment) => comment.id === res.data.id);
        this.comments.splice(index, 1, res.data);
        this.handleShowEditComment();
      });
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
      if (this.arrangementInformation.liked_authuser) {
        this.$devour
          .one('arrangement', this.arrangementInformation.id)
          .all('like')
          .destroy()
          .then(() => {
            this.arrangementInformation.liked_authuser = false;
            this.arrangementInformation.likes_count -= 1;
            this.fetchAuthUser();
          });
      } else {
        this.$devour
          .one('arrangement', this.arrangementInformation.id)
          .all('like')
          .post({})
          .then(() => {
            this.arrangementInformation.liked_authuser = true;
            this.arrangementInformation.likes_count += 1;
            this.fetchAuthUser();
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
        });
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
