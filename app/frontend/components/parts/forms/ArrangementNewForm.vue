<template>
  <ValidationObserver id="arrangement-new-form" v-slot="{ passed }" tag="form">
    <v-row class="mb-10">
      <v-col cols="12" sm="4">
        <h6 class="text-h6 font-weight-bold">写真を選択する</h6>
        <p class="text-caption" style="color: #ff5252">※必須</p>
        <div class="d-flex flex-column">
          <span class="text-caption light-weight-text">画像形式: JPEG/PNG</span>
          <span class="text-caption light-weight-text">容量: 10MB以内</span>
        </div>
        <ValidationProvider
          ref="fileForm"
          name="投稿写真"
          mode="change"
          :rules="{ required: true, ext: ['jpeg', 'jpg', 'png'], size: 10240 }"
        >
          <v-file-input
            id="arrangement-images"
            label="投稿写真"
            accept="image/jpeg, image/jpg, image/png"
            style="display: none"
            @change="handleFileChange"
          />
        </ValidationProvider>
      </v-col>
      <v-col cols="12" sm="5">
        <v-sheet
          class="d-flex align-center justify-center"
          height="300"
          style="position: relative; border: 2px dashed"
        >
          <template v-if="previewImage">
            <v-img id="preview-image" height="300" :src="previewImage" />
            <v-btn
              id="cancel-button"
              fab
              small
              depressed
              dark
              absolute
              top
              right
              @click="deleteFile"
            >
              <v-icon>mdi-close</v-icon>
            </v-btn>
          </template>
          <template v-else>
            <NormalButton :xLarge="true" @click="fileUpload">
              <template #text class="text-button">
                <v-icon class="mr-1">mdi-camera</v-icon>
                写真を選択
              </template>
            </NormalButton>
          </template>
        </v-sheet>
      </v-col>
    </v-row>

    <v-row class="mb-10">
      <v-col cols="12" sm="4">
        <h6 class="text-h6 font-weight-bold">タイトルを追加する</h6>
        <p class="text-caption" style="color: #ff5252">※必須</p>
        <div class="d-flex flex-column">
          <span class="text-caption light-weight-text">文字数: 30字以内</span>
        </div>
      </v-col>
      <v-col>
        <TitleField :title="title" :rules="rules.title" @input="$emit('update:title', $event)" />
      </v-col>
    </v-row>

    <v-row class="mb-10">
      <v-col cols="12" sm="4">
        <h6 class="text-h6 font-weight-bold">コメントを追加する</h6>
        <p class="text-caption" style="color: #ff5252">※必須</p>
        <div class="d-flex flex-column">
          <span class="text-caption light-weight-text">文字数: 1000字以内</span>
        </div>
      </v-col>
      <v-col>
        <ContextField
          :context="context"
          :rules="rules.context"
          @input="$emit('update:context', $event)"
        />
      </v-col>
    </v-row>

    <v-card-actions class="d-flex justify-center">
      <SubmitButton
        :xLarge="true"
        :color="'#ff5252'"
        :disabled="!passed"
        @submit="handleCreateArrangement"
      >
        <template #text> アレンジ飯を投稿する </template>
      </SubmitButton>
    </v-card-actions>
  </ValidationObserver>
</template>

<script>
import Jimp from 'jimp/es';
import TitleField from '../formInputs/TitleField';
import ContextField from '../formInputs/ContextField';
import SubmitButton from '../buttons/SubmitButton';
import NormalButton from '../buttons/NormalButton';

export default {
  components: {
    TitleField,
    ContextField,
    SubmitButton,
    NormalButton,
  },
  props: {
    title: {
      type: String,
      required: false,
      default: null,
    },
    context: {
      type: String,
      required: false,
      default: null,
    },
    images: {
      type: Array,
      required: false,
      default: null,
    },
  },
  data() {
    return {
      rules: {
        images: { required: true, ext: ['jpg', 'jpeg', 'png', 'gif'], size: 10240 },
        title: { required: true, max: 30 },
        context: { required: true, max: 1000 },
      },
      previewImage: '',
      isPreview: false,
    };
  },
  methods: {
    handleCreateArrangement() {
      this.$emit('createArrangement');
    },
    fileUpload() {
      document.querySelector('#arrangement-images').click();
    },
    deleteFile() {
      this.$refs.fileForm.validate('');
      this.$emit('uploadFile', '');
      this.previewImage = '';
      this.isPreview = false;
    },
    async handleFileChange(value) {
      const result = await this.$refs.fileForm.validate(value);
      if (result.valid) {
        const imageURL = URL.createObjectURL(value);
        Jimp.read(imageURL)
          .then((image) => {
            image.cover(300, 300).getBase64(Jimp.MIME_PNG, (err, src) => {
              this.$emit('uploadFile', src);
              this.previewImage = src;
              this.isPreview = true;
            });
            URL.revokeObjectURL(imageURL);
          })
          .catch((error) => {
            alert('サイズが大き過ぎます。他の写真を投稿してください。');
            console.log(error);
          });
      } else {
        this.previewImage = '';
        this.isPreview = false;
      }
    },
  },
};
</script>
