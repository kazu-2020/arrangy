<template>
  <ValidationObserver id="arrangement-new-form" v-slot="{ passed }" tag="form">
    <v-row class="mb-10">
      <v-col cols="12" sm="4">
        <div class="text-h6 font-weight-bold">写真を選択する</div>
        <div class="text-caption" style="color: #cc3918">※必須</div>
        <div class="d-flex flex-column">
          <div class="text-caption light-weight-text">画像形式: JPEG/PNG</div>
          <div class="text-caption light-weight-text">容量: 10MB以内</div>
        </div>

        <ValidationProvider ref="fileForm" name="投稿写真" mode="change" :rules="rules.images">
          <v-file-input
            id="arrangement-images"
            label="投稿写真"
            accept="image/jpeg, image/jpg, image/png"
            style="display: none"
            @change="handleFileChange"
          />
        </ValidationProvider>
      </v-col>
      <v-col cols="12" md="auto">
        <v-sheet
          class="d-flex align-center justify-center mx-auto"
          height="300"
          width="300"
          style="position: relative; border: 2px dashed"
          color="#eeeeee"
        >
          <template v-if="previewImage">
            <v-img id="preview-image" :src="previewImage" maxHeight="300" maxWidth="300" />
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
          <div v-else class="text-center">
            <NormalButton class="mb-5" :xLarge="true" :loading="fileUploading" @click="fileUpload">
              <template #text class="text-button">
                <v-icon class="mr-1">mdi-camera</v-icon>
                写真を選択
              </template>
            </NormalButton>
            <div class="text-caption" style="color: red">{{ fileError }}</div>
          </div>
        </v-sheet>
      </v-col>
    </v-row>

    <!-- トリミング用ダイアログ -->
    <v-dialog v-model="trimmingDialogDisplayed" maxWidth="650" :eager="true" persistent>
      <v-sheet id="trimming-dialog" class="pa-5 pa-md-10 mx-auto" color="#eeeeee">
        <VueCropper ref="cropper" :aspectRatio="1 / 1" :src="imgSrc" :viewMode="2" class="mb-5" />
        <v-card-actions class="d-flex justify-center">
          <SubmitButton class="mx-2" :color="'#cc3918'" :xLarge="true" @submit="imageTrimming">
            <template #text> トリミングする </template>
          </SubmitButton>
          <NormalButton class="mx-2" :xLarge="true" @click="closeTrimmingDialog">
            <template #text>キャンセル</template>
          </NormalButton>
        </v-card-actions>
      </v-sheet>
    </v-dialog>

    <v-row class="mb-10">
      <v-col cols="12" sm="4">
        <div class="text-h6 font-weight-bold">タイトルを追加する</div>
        <div class="text-caption" style="color: #cc3918">※必須</div>
        <div class="d-flex flex-column">
          <div class="text-caption light-weight-text">文字数: 30字以内</div>
        </div>
      </v-col>
      <v-col>
        <TitleField :title="title" :rules="rules.title" @input="$emit('update:title', $event)" />
      </v-col>
    </v-row>

    <v-row class="mb-10">
      <v-col cols="12" sm="4">
        <div class="text-h6 font-weight-bold">コメントを追加する</div>
        <div class="text-caption" style="color: #cc3918">※必須</div>
        <div class="d-flex flex-column">
          <div class="text-caption light-weight-text">文字数: 1000字以内</div>
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
        :color="'#cc3918'"
        :disabled="!passed"
        :loading="loading"
        @submit="handleCreateArrangement"
      >
        <template #text> アレンジ飯を投稿する </template>
      </SubmitButton>
    </v-card-actions>
  </ValidationObserver>
</template>

<script>
import Jimp from 'jimp/es';
import JimpJPEG from 'jpeg-js';
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
      required: true,
    },
    context: {
      type: String,
      required: true,
    },
    images: {
      type: Array,
      required: true,
    },
    loading: {
      type: Boolean,
    },
  },
  data() {
    return {
      previewImage: '',
      isPreview: false,
      fileUploading: false,
      imgSrc: '',
      trimmingDialogDisplayed: false,
      fileError: '',
    };
  },
  computed: {
    rules() {
      return {
        images: { required: true, ext: ['jpeg', 'jpg', 'png'], size: 10000 },
        title: { required: true, max: 30 },
        context: { required: true, max: 1000 },
      };
    },
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
    closeTrimmingDialog() {
      this.trimmingDialogDisplayed = false;
      this.$refs.fileForm.validate('');
    },
    async handleFileChange(value) {
      const result = await this.$refs.fileForm.validate(value);
      if (result.valid) {
        this.fileUploading = true;
        this.fileError = '';

        const img = new Image();
        const imageURL = URL.createObjectURL(value);
        img.src = imageURL;

        let width = 0;
        let height = 0;

        img.onload = () => {
          width = img.width;
          height = img.height;
        };

        Jimp.decoders['image/jpeg'] = (data) => {
          return JimpJPEG.decode(data, {
            maxMemoryUsageInMB: 1024,
          });
        };

        const jimpImage = await Jimp.read(imageURL).catch((err) => {
          alert('サイズが大き過ぎます。他の写真を投稿してください。');
          console.log(err);
        });
        if (!jimpImage) return;

        if (width > height) {
          jimpImage.resize(500, Jimp.AUTO);
        } else {
          jimpImage.resize(Jimp.AUTO, 500);
        }

        jimpImage.getBase64(Jimp.MIME_PNG, (err, src) => {
          this.imgSrc = src;
          this.fileUploading = false;
          this.trimmingDialogDisplayed = true;
          this.$refs.cropper.replace(src);
        });
        URL.revokeObjectURL(imageURL);
      } else {
        console.log(result);
        this.fileError = result.errors[0];
      }
    },
    imageTrimming() {
      this.isPreview = true;
      const trimmedImage = this.$refs.cropper
        .getCroppedCanvas({
          width: 300,
          height: 300,
          fillColor: '#eeeeee',
          imageSmoothingQuality: 'medium',
        })
        .toDataURL();
      this.previewImage = trimmedImage;
      this.$emit('uploadFile', trimmedImage);
      this.trimmingDialogDisplayed = false;
    },
  },
};
</script>
