<template>
  <v-container>
    <v-row class="pt-5">
      <v-col>
        <h6 class="text-h6 font-weight-bold">アレンジ飯を投稿する</h6>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" class="pt-16 mx-auto">
        <ArrangementNewForm
          v-bind.sync="arrangement"
          @createArrangement="createArrangement"
          @uploadFile="uploadFile"
        />
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
    };
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    createArrangement() {
      this.$devour
        .create('arrangement', this.arrangement)
        .then((res) => {
          this.$router.push({ name: 'ArrangementShow', params: { id: res.data.id } });
          this.fetchSnackbarData({
            msg: '新しいアレンジ飯を投稿しました',
            color: 'success',
            isShow: true,
          });
        })
        .catch((error) => {
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
