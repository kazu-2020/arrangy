<template>
  <v-container v-if="isCreated" fluid>
    <v-row v-if="pagy.pageCounts > 1">
      <v-col cols="12">
        <v-pagination
          id="top-pagination"
          v-model="pagy.currentPage"
          color="#cc3918"
          circle
          :length="pagy.pageCounts"
        />
      </v-col>
    </v-row>

    <v-row v-if="arrangements.length">
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
                <v-list-item-icon>
                  <v-icon>mdi-clipboard-edit</v-icon>
                </v-list-item-icon>
                <v-list-item-title> 編集する</v-list-item-title>
              </v-list-item>
              <v-list-item tag="button" @click.stop="displayDeleteArrangementDialog(arrangement)">
                <v-list-item-icon>
                  <v-icon>mdi-trash-can-outline</v-icon>
                </v-list-item-icon>
                <v-list-item-title> 削除する</v-list-item-title>
              </v-list-item>
            </v-list>
          </template>
        </InitializedMenu>
      </v-col>
    </v-row>
    <v-row v-else>
      <v-col cols="12" class="font-weight-bold text-center">現在、投稿はありません。</v-col>
    </v-row>

    <v-row v-if="pagy.pageCounts > 1">
      <v-col cols="12">
        <v-pagination
          id="bottom-pagination"
          v-model="pagy.currentPage"
          circle
          color="#cc3918"
          :length="pagy.pageCounts"
        />
      </v-col>
    </v-row>
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
  </v-container>
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
        arrangeLevel: 0,
        rating: 0,
        afterArrangementPhotoURL: '',
        beforeArrangementPhotoURL: '',
      },
      arrangementDelete: {},
      pagy: {
        currentPage: 1,
        pageCounts: 1,
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
    twitterShareUrl() {
      return function (id) {
        const url = `https://arrangy.jp/arrangements/${id}`;
        return `https://twitter.com/share?text=こちらは人気のアレンジ飯です。皆さんも実際に作って食べてみてください。%0a他のアレンジ飯が気になる方は是非、Arrangy(アレンジー)にお越し下さい。&url=${url}&hashtags=Arrangy,アレンジ飯`;
      };
    },
  },
  watch: {
    'pagy.currentPage': function (newValue) {
      this.fetchArrangements(newValue);
    },
  },
  created() {
    this.fetchArrangements(1);
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    ...mapActions('users', ['fetchAuthUser']),

    displayArrangementEditDialog(arrangement) {
      this.arrangementEdit.id = arrangement.id;
      this.arrangementEdit.title = arrangement.title;
      this.arrangementEdit.context = arrangement.context;
      this.arrangementEdit.rating = arrangement.rating;
      this.arrangementEdit.arrangeLevel = arrangement.arrange_level;
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
    fetchArrangements(page) {
      this.$devour
        .request(`${this.$devour.apiUrl}/arrangements/postings`, 'GET', {
          page: page,
        })
        .then((res) => {
          this.arrangements = res.data;
          this.isCreated = true;
          this.pagy.currentPage = res.meta.pagy.page;
          this.pagy.pageCounts = res.meta.pagy.pages;
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
