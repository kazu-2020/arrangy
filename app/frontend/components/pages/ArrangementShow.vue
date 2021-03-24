<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="6" class="pt-16 mx-auto">
        <v-sheet
          :id="`arrangement-${arrangement.id}`"
          height="100%"
          width="80%"
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
              <img :src="user.avatar" />
            </v-avatar>
            <h4 class="text-subtitle-1">
              {{ user.nickname }}
            </h4>
            <v-spacer />
            <template v-if="authUser.id === user.id">
              <v-btn @click.stop="displayArrangementEditDialog">編集</v-btn>
            </template>
          </v-card-subtitle>
          <v-card-text>
            <v-sheet class="pa-5" :rounded="true" outlined color="#FAFAFA">
              <pre class="text-body-1" width="100%">{{ arrangement.context }}</pre>
            </v-sheet>
          </v-card-text>
        </v-sheet>
        <ArrangementEditForm
          v-if="editArrangementActed"
          :isShow="editArrangementDialogDisplayed"
          v-bind.sync="arrangementEdit"
          @uploadFile="uploadFile"
          @closeDialog="closeEditArrangement"
          @updateArrangement="updateArrangement"
        />
      </v-col>
      <v-col cols="12" sm="6"></v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import Jimp from 'jimp/es';
import ArrangementEditForm from '../parts/forms/ArrangementEditForm';

export default {
  components: {
    ArrangementEditForm,
  },
  data() {
    return {
      arrangement: {},
      user: {},
      arrangementEdit: {},
      editArrangementDialogDisplayed: false,
      editArrangementActed: false,
    };
  },
  computed: {
    ...mapGetters('users', ['authUser']),
  },
  created() {
    this.fetchArrangement();
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    fetchArrangement() {
      this.$devour.find('arrangement', this.$route.params.id).then((res) => {
        this.arrangement = res.data;
        this.user = res.data.user;
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
    handleShowEditArrangement() {
      this.editArrangementDialogDisplayed = !this.editArrangementDialogDisplayed;
    },
    initArrangement() {
      this.arrangementEdit = { ...this.arrangement, images: [...this.arrangement.images] };
      Jimp.read(this.arrangementEdit.images[0]).then((image) => {
        image.getBase64(Jimp.MIME_PNG, (err, src) => {
          this.arrangementEdit.images.splice(0, 1, src);
        });
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
  },
};
</script>

<style scoped>
pre {
  white-space: pre-wrap;
}
</style>
