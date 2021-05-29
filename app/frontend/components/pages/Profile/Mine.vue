<template>
  <v-row v-if="isCreated">
    <template v-if="arrangements.length">
      <v-col
        v-for="(arrangement, $index) in arrangements"
        :key="$index"
        cols="12"
        sm="4"
        md="4"
        style="position: relative"
      >
        <ArrangementSummary
          :arrangement="arrangement"
          :twitterShareUrl="twitterShareUrl(arrangement.id)"
        />
        <InitializedMenu :outlined="true" :absolute="true">
          <template #btn-text>
            <v-icon id="arrangement-menu-icon">mdi-dots-vertical</v-icon>
          </template>
          <template #list>
            <v-list id="arrangement-menu-list" dense>
              <v-list-item tag="button" @click="displayArrangementEditDialog(arrangement)">
                編集する
              </v-list-item>
              <v-list-item tag="button" @click.stop="displayDeleteArrangementDialog(arrangement)">
                削除する
              </v-list-item>
            </v-list>
          </template>
        </InitializedMenu>
      </v-col>

      <infinite-loading
        v-if="pagy.isActioned"
        direction="bottom"
        spinner="circles"
        @infinite="infinitieHandler"
      >
        <div slot="no-more" />
        <div slot="no-results" />
      </infinite-loading>
    </template>
    <template v-else>
      <div class="mx-auto">現在、投稿はありません</div>
    </template>
    <!-- 投稿編集フォーム -->
    <ArrangementEditForm
      :isShow="editArrangementDialogDisplayed"
      v-bind.sync="arrangementEdit"
      :loading="arrangementEditing"
      @updateArrangement="updateArrangement"
      @closeDialog="closeEditArrangement"
    />
    <!-- 投稿削除確認ダイアログ -->
    <DeleteConfirmationDialog
      :isShow="deleteArrangementDialogDisplayed"
      @deleteData="deleteArrangement"
      @closeDialog="closeDeleteArrangementDialog"
    >
      <template #title>投稿を削除する</template>
      <template #text> この投稿を本当に削除しますか？削除後は元に戻すことはできません。 </template>
    </DeleteConfirmationDialog>
  </v-row>
</template>

<script>
import { mapActions } from 'vuex';

import ArrangementEditForm from '../../parts/forms/ArrangementEditForm';
import ArrangementSummary from '../../parts/cards/ArrangementSummary';
import DeleteConfirmationDialog from '../../parts/dialogs/DeleteConfirmationDialog';
import InitializedMenu from '../../parts/menus/InitializedMenu';

export default {
  components: {
    ArrangementEditForm,
    ArrangementSummary,
    DeleteConfirmationDialog,
    InitializedMenu,
  },
  data() {
    return {
      arrangements: [],
      arrangementEdit: {
        id: '',
        title: '',
        context: '',
        rating: 0,
        afterArrangementPhotoURL: '',
        beforeArrangementPhotoURL: '',
      },
      arrangementDelete: {},
      pagy: {
        currentPage: 1,
        isActioned: false,
      },
      isCreated: false,
      arrangementEditing: false,
      deleteArrangementDialogDisplayed: false,
      editArrangementDialogDisplayed: false,
    };
  },
  computed: {
    arrangementParams() {
      return {
        title: this.arrangementEdit.title,
        context: this.arrangementEdit.context,
        rating: this.arrangementEdit.rating,
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
    twitterShareUrl() {
      return function (id) {
        const url = `https://arrangy.jp/arrangements/${id}`;
        return `https://twitter.com/share?text=こちらは人気のアレンジ飯です。皆さんも実際に作って食べてみてください。%0a他のアレンジ飯が気になる方は是非、Arrangy(アレンジー)にお越し下さい。&url=${url}&hashtags=Arrangy,アレンジ飯`;
      };
    },
  },
  created() {
    this.fetchArrangements();
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    ...mapActions('users', ['fetchAuthUser']),

    displayArrangementEditDialog(arrangement) {
      this.arrangementEdit.id = arrangement.id;
      this.arrangementEdit.title = arrangement.title;
      this.arrangementEdit.context = arrangement.context;
      this.arrangementEdit.rating = arrangement.rating;
      this.arrangementEdit.afterArrangementPhotoURL = arrangement.after_arrangement_photo.url;
      this.arrangementEdit.beforeArrangementPhotoURL = arrangement.before_arrangement_photo.url;

      this.editArrangementDialogDisplayed = true;
    },
    closeEditArrangement() {
      this.editArrangementDialogDisplayed = false;
    },

    displayDeleteArrangementDialog(arrangement) {
      this.arrangementDelete = { ...arrangement };
      this.deleteArrangementDialogDisplayed = true;
    },
    closeDeleteArrangementDialog() {
      this.deleteArrangementDialogDisplayed = false;
    },
    fetchArrangements() {
      this.$devour
        .request(`${this.$devour.apiUrl}/arrangements/postings`, 'GET', {
          page: this.pagy.currentPage,
        })
        .then((res) => {
          this.arrangements.push(...res.data);
          this.isCreated = true;
          this.pagy.currentPage += 1;
          if (res.meta.pagy.pages !== 1) {
            this.pagy.isActioned = true;
          }
        });
    },
    infinitieHandler($state) {
      this.$devour
        .request(`${this.$devour.apiUrl}/arrangements/postings`, 'GET', {
          page: this.pagy.currentPage,
        })
        .then((res) => {
          if (this.pagy.currentPage < res.meta.pagy.pages) {
            this.pagy.currentPage += 1;
            this.arrangements.push(...res.data);
            $state.loaded();
          } else {
            this.arrangements.push(...res.data);
            $state.complete();
          }
        });
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
            parameter: this.paramterParams,
          }
        )
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
      this.$devour.destroy('arrangement', this.arrangementDelete.id).then(() => {
        const index = this.arrangements.findIndex(
          (arrangement) => arrangement.id === this.arrangementDelete.id
        );
        this.arrangements.splice(index, 1);
        this.closeDeleteArrangementDialog();
        this.fetchSnackbarData({
          msg: '投稿を削除しました',
          color: 'success',
          isShow: true,
        });
        this.fetchAuthUser();
      });
    },
  },
};
</script>
