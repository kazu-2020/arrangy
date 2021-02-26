<template>
  <v-container fill-height>
    <v-row class="d-flex justify-center">
      <v-col cols="12" sm="7">
        <v-card class="pa-4" color="grey lighten-5">
          <div class="text-h6 pt-8 px-8 text-center font-weight-black">新規投稿</div>
          <ValidationObserver v-slot="{ handleSubmit }">
            <v-card-text>
              <ValidationProvider
                v-slot="{ errors }"
                ref="fileForm"
                name="投稿写真"
                mode="change"
                :rules="{ required: true, ext: ['jpg', 'jpeg', 'png', 'gif'] }"
              >
                <v-file-input
                  id="arrangement-images"
                  label="投稿写真"
                  color="black"
                  chips
                  clearable
                  hint="有効なファイル形式はjpg jpeg png gifです"
                  prepend-icon
                  prepend-inner-icon="mdi-camera"
                  show-size
                  :error-messages="errors"
                  @change="handleFileChange"
                />
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
              {{ arrangement }}
            </v-card-text>
            <v-card-actions class="d-flex justify-center">
              <v-btn
                style="color: white"
                color="red accent-2"
                x-large
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
export default {
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
    createArrangement() {
      this.$axios
        .post('arrangements', this.arrangement)
        .then(() => alert('投稿しました'))
        .catch((error) => console.log(error));
    },
    async handleFileChange(value) {
      const result = await this.$refs.fileForm.validate(value);
      if (result.valid) {
        this.arrangement.images.splice(0, 1, value);
      } else {
        return;
      }
    },
  },
};
</script>
