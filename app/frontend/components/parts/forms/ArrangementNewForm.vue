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
            id="arrangement-photo"
            label="投稿写真"
            style="display: none"
            accept="image/jpeg, image/jpg, image/png"
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
          <template v-if="previewDisplayed">
            <v-img
              id="preview-image"
              :src="afterArrangementPhotoURL"
              maxHeight="300"
              maxWidth="300"
            />
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
        <VueCropper ref="cropper" :aspectRatio="1 / 1" :viewMode="2" class="mb-5" />
        <v-card-actions class="d-flex justify-center">
          <SubmitButton class="mx-2" :color="'#cc3918'" :xLarge="true" @submit="uploadToS3">
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

    <v-row class="mb-10">
      <v-col cols="12" sm="4">
        <div class="text-h6 font-weight-bold">パラメーターを設定する</div>
        <div class="text-caption">※任意</div>
        <div class="d-flex flex-column">
          <div class="text-caption light-weight-text">各項目: 1~5で設定できます</div>
        </div>
      </v-col>
      <v-col>
        <div>
          <ParameterField :value="taste" @input="$emit('update:taste', $event)">
            <template #label>
              <div class="mr-4">美味さ</div>
            </template>
          </ParameterField>
          <ParameterField :value="spiciness" @input="$emit('update:spiciness', $event)">
            <template #label>
              <div class="mr-8">辛さ</div>
            </template>
          </ParameterField>
          <ParameterField :value="sweetness" @input="$emit('update:sweetness', $event)">
            <template #label>
              <div class="mr-8">甘さ</div>
            </template>
          </ParameterField>
          <ParameterField :value="satisfaction" @input="$emit('update:satisfaction', $event)">
            <template #label>
              <div>食べ応え</div>
            </template>
          </ParameterField>
        </div>
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

import ContextField from '../formInputs/ContextField';
import NormalButton from '../buttons/NormalButton';
import ParameterField from '../formInputs/ParameterField';
import SubmitButton from '../buttons/SubmitButton';
import TitleField from '../formInputs/TitleField';

export default {
  components: {
    ContextField,
    NormalButton,
    ParameterField,
    TitleField,
    SubmitButton,
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
    afterArrangementPhotoURL: {
      type: String,
      required: true,
    },
    taste: {
      type: Number,
      required: true,
    },
    spiciness: {
      type: Number,
      required: true,
    },
    sweetness: {
      type: Number,
      required: true,
    },
    satisfaction: {
      type: Number,
      required: true,
    },
    loading: {
      type: Boolean,
    },
  },
  data() {
    return {
      fileError: '',
      uploadFileName: '',
      previewDisplayed: false,
      fileUploading: false,
      trimmingDialogDisplayed: false,
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
    tickLabels() {
      return ['0', '1', '2', '3', '4', '5'];
    },
  },
  methods: {
    handleCreateArrangement() {
      this.$emit('createArrangement');
    },
    fileUpload() {
      document.querySelector('#arrangement-photo').click();
    },
    deleteFile() {
      this.$refs.fileForm.validate('');
      this.$emit('uploadFile', '');
      this.previewDisplayed = false;
    },
    closeTrimmingDialog() {
      this.trimmingDialogDisplayed = false;
      this.$refs.fileForm.validate('');
    },
    async handleFileChange(file) {
      const result = await this.$refs.fileForm.validate(file);
      if (result.valid) {
        this.fileUploading = true;
        this.fileError = '';
        this.uploadFileName = file.name.substring(0, file.name.lastIndexOf('.'));

        Jimp.decoders['image/jpeg'] = (data) => {
          return JimpJPEG.decode(data, {
            maxMemoryUsageInMB: 1024,
          });
        };

        const imageURL = URL.createObjectURL(file);
        Jimp.read(imageURL)
          .then((jimp) => {
            if (jimp.bitmap.width > jimp.bitmap.height) {
              return jimp.resize(500, Jimp.AUTO);
            } else {
              return jimp.resize(Jimp.AUTO, 500);
            }
          })
          .then((jimp) => {
            jimp.getBase64(Jimp.MIME_PNG, (err, src) => {
              this.fileUploading = false;
              this.trimmingDialogDisplayed = true;
              this.$refs.cropper.replace(src);
            });
          })
          .catch((err) => {
            alert('サイズが大き過ぎます。他の写真を投稿してください。');
            console.log(err);
          });
        URL.revokeObjectURL(imageURL);
      } else {
        this.fileError = result.errors[0];
      }
    },
    async uploadToS3() {
      const res = await this.$devour.request(`${this.$devour.apiUrl}/presigned_post/new`, 'GET');
      const formData = await this.createFormData(res.meta.fields);

      this.$devour.request(res.meta.url, 'POST', {}, formData).then((res) => {
        this.$emit('update:afterArrangementPhotoURL', res.meta.url);
        this.trimmingDialogDisplayed = false;
        this.previewDisplayed = true;
      });
    },
    createFormData(fields) {
      return new Promise((resolve) => {
        this.$refs.cropper
          .getCroppedCanvas({
            width: 300,
            height: 300,
            imageSmoothingQuality: 'medium',
          })
          .toBlob((blob) => {
            const formData = new FormData();
            for (const key in fields) {
              formData.append(key, fields[key]);
            }
            formData.append('file', blob, this.uploadFileName);
            resolve(formData);
          });
      });
    },
  },
};
</script>
