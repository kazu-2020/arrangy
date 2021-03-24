<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="7" class="pt-16 mx-auto">
        <v-card class="pa-4" color="grey lighten-5">
          <div class="text-h6 pt-8 px-8 mb-5 text-center font-weight-black">新規投稿</div>
          <ArrangementNewForm
            v-bind.sync="arrangement"
            :isLoadng="isLoading"
            @createArrangement="createArrangement"
            @uploadFile="uploadFile"
          />
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions } from 'vuex';
import ArrangementNewForm from '../parts/forms/ArrangementNewForm';

export default {
  components: {
    ArrangementNewForm,
  },
  data() {
    return {
      arrangement: {
        title: '',
        context: '',
        images: [],
      },
      isLoading: false,
    };
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    createArrangement() {
      this.isLoading = true;
      this.$devour
        .create('arrangement', this.arrangement)
        .then(() => {
          this.$router.push({ name: 'TopPage' });
          this.fetchSnackbarData({
            msg: '新しいアレンジ飯を投稿しました',
            color: 'success',
            isShow: true,
          });
        })
        .catch((error) => {
          this.isLoading = false;
          this.fetchSnackbarData({
            msg: '投稿に失敗しました',
            color: 'error',
            isShow: true,
          });
          console.log(error);
        });
    },
    uploadFile(src) {
      this.arrangement.images.splice(0, 1, src);
    },
  },
};
</script>
