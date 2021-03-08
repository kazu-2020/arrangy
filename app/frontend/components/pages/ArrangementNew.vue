<template>
  <v-container fill-height>
    <v-row class="d-flex justify-center">
      <v-col cols="12" sm="7">
        <v-card class="pa-4" color="grey lighten-5">
          <div class="text-h6 pt-8 px-8 mb-5 text-center font-weight-black">新規投稿</div>
          <v-img v-show="isPreview" class="mb-5" :src="previewImage" contain height="300" />
          <ValidationObserver v-slot="{ handleSubmit }">
            <v-card-text>
              <ValidationProvider
                v-slot="{ errors }"
                ref="fileForm"
                name="投稿写真"
                mode="change"
                :rules="{ required: true, ext: ['jpg', 'jpeg', 'png', 'gif'], size: 10240 }"
              >
                <v-file-input
                  id="arrangement-images"
                  label="投稿写真"
                  color="black"
                  clearable
                  hint="有効なファイル形式はjpg jpeg png gifです"
                  prepend-icon
                  prepend-inner-icon="mdi-camera"
                  persistent-hint
                  :error-messages="errors"
                  @change="handleFileChange"
                >
                  <template #selection="{ text }">
                    <v-chip small label color="grey lighten-1">
                      {{ text }}
                    </v-chip>
                  </template>
                </v-file-input>
              </ValidationProvider>
              <ValidationProvider
                v-slot="{ errors }"
                :rules="{ required: true, max: 30 }"
                name="タイトル"
              >
                <v-text-field
                  id="arrangement-title"
                  v-model="arrangement.title"
                  class="mb-6"
                  type="text"
                  label="タイトル"
                  clearable
                  color="black"
                  counter="30"
                  :error-messages="errors"
                />
              </ValidationProvider>
              <ValidationProvider
                v-slot="{ errors }"
                :rules="{ required: true, max: 1000 }"
                name="投稿内容"
              >
                <v-textarea
                  id="arrangement-context"
                  v-model="arrangement.context"
                  label="投稿内容"
                  outlined
                  auto-grow
                  clearable
                  color="black"
                  counter="1000"
                  :error-messages="errors"
                />
              </ValidationProvider>
            </v-card-text>
            <v-card-actions class="d-flex justify-center">
              <v-btn
                style="color: white"
                color="red accent-2"
                x-large
                :loading="isLoading"
                :disabled="isLoading"
                @click="handleSubmit(createArrangement)"
              >
                <v-icon class="mr-1">mdi-send</v-icon>
                投稿する
              </v-btn>
            </v-card-actions>
          </ValidationObserver>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import Jimp from 'jimp/es';
import { mapActions } from 'vuex';
export default {
  data() {
    return {
      arrangement: {
        title: '',
        context: '',
        images: [],
      },
      previewImage: '',
      isPreview: false,
      isLoading: false,
    };
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    createArrangement() {
      this.isLoading = true;
      this.$axios
        .post('arrangements', this.arrangement)
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
    async handleFileChange(value) {
      const result = await this.$refs.fileForm.validate(value);
      if (result.valid) {
        const imageURL = URL.createObjectURL(value);
        Jimp.read(imageURL)
          .then((image) => {
            image
              .cover(300, 300)
              .quality(85)
              .getBase64(Jimp.MIME_PNG, (err, src) => {
                this.arrangement.images.splice(0, 1, src);
                this.isPreview = true;
                this.previewImage = src;
              });
            URL.revokeObjectURL(imageURL);
          })
          .catch((error) => {
            alert('アップロードに失敗しました');
            console.log(error);
          });
      } else {
        this.isPreview = false;
        this.previewImage = '';
      }
    },
  },
};
</script>
