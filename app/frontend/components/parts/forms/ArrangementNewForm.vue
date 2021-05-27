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

        <ValidationProvider
          ref="beforeArrangement"
          name="アレンジ前の写真"
          mode="change"
          :rules="rules.images"
        >
          <v-file-input
            id="before-arrangement"
            label="アレンジ前の写真"
            style="display: none"
            accept="image/jpeg, image/jpg, image/png"
            @change="handleFileChange('beforeArrangement', $event)"
          />
        </ValidationProvider>

        <ValidationProvider
          ref="afterArrangement"
          name="アレンジ後の写真"
          mode="change"
          :rules="rules.images"
        >
          <v-file-input
            id="after-arrangement"
            label="アレンジ後の写真"
            style="display: none"
            accept="image/jpeg, image/jpg, image/png"
            @change="handleFileChange('afterArrangement', $event)"
          />
        </ValidationProvider>
      </v-col>
      <!-- アレンジ前の写真投稿 -->
      <v-col cols="12" md="auto">
        <v-sheet
          class="d-flex align-center justify-center mx-auto"
          height="300"
          width="300"
          style="position: relative; border: 2px dashed"
          color="#eeeeee"
        >
          <template v-if="beforeArrangement.previewDisplayed">
            <v-img
              id="preview-image"
              :src="beforeArrangementPhotoURL"
              :lazySrc="beforeArrangementPhotoURL"
              maxHeight="300"
              maxWidth="300"
            >
              <template #placeholder>
                <v-row class="fill-height ma-0" align="center" justify="center">
                  <VueLoading type="spiningDubbles" color="#4CAF50" />
                </v-row>
              </template>
            </v-img>
            <v-btn
              id="cancel-button"
              fab
              small
              depressed
              dark
              absolute
              top
              right
              @click="deleteFile('beforeArrangementPhotoURL', 'beforeArrangement')"
            >
              <v-icon>mdi-close</v-icon>
            </v-btn>
          </template>
          <div v-else class="text-center">
            <NormalButton
              class="mb-5"
              :xLarge="true"
              :loading="beforeArrangement.fileUploading"
              @click="uploadBeforeArrangementfile"
            >
              <template #text class="text-button">
                <v-icon class="mr-1">mdi-camera</v-icon>
                アレンジ前の写真を選択
              </template>
            </NormalButton>
            <div class="text-caption" style="color: red">{{ beforeArrangement.fileError }}</div>
          </div>
        </v-sheet>
      </v-col>
      <!-- アレンジ後の写真投稿 -->
      <v-col cols="12" md="auto">
        <v-sheet
          class="d-flex align-center justify-center mx-auto"
          height="300"
          width="300"
          style="position: relative; border: 2px dashed"
          color="#eeeeee"
        >
          <template v-if="afterArrangement.previewDisplayed">
            <v-img
              id="preview-image"
              :lazySrc="afterArrangementPhotoURL"
              :src="afterArrangementPhotoURL"
              maxHeight="300"
              maxWidth="300"
            >
              <template #placeholder>
                <v-row class="fill-height ma-0" align="center" justify="center">
                  <VueLoading type="spiningDubbles" color="#4CAF50" />
                </v-row>
              </template>
            </v-img>
            <v-btn
              id="cancel-button"
              fab
              small
              depressed
              dark
              absolute
              top
              right
              @click="deleteFile('afterArrangementPhotoURL', 'afterArrangement')"
            >
              <v-icon>mdi-close</v-icon>
            </v-btn>
          </template>
          <div v-else class="text-center">
            <NormalButton
              class="mb-5"
              :xLarge="true"
              :loading="afterArrangement.fileUploading"
              @click="uploadAfterArrangementfile"
            >
              <template #text class="text-button">
                <v-icon class="mr-1">mdi-camera</v-icon>
                アレンジ後の写真を選択
              </template>
            </NormalButton>
            <div class="text-caption" style="color: red">{{ afterArrangement.fileError }}</div>
          </div>
        </v-sheet>
      </v-col>
    </v-row>

    <!-- アレンジ前のトリミング用ダイアログ -->
    <v-dialog
      v-model="beforeArrangement.trimmingDialogDisplayed"
      maxWidth="650"
      :eager="true"
      persistent
    >
      <v-sheet id="before-trimming-dialog" class="pa-5 pa-md-10 mx-auto" color="#eeeeee">
        <VueCropper
          ref="beforeArrangementCropper"
          :aspectRatio="1 / 1"
          :viewMode="2"
          class="mb-5"
        />
        <v-card-actions class="d-flex justify-center">
          <SubmitButton
            class="mx-2"
            :color="'#cc3918'"
            :xLarge="true"
            :loading="beforeArrangement.trimLoading"
            @submit="uploadToS3('beforeArrangementPhotoURL', 'beforeArrangement')"
          >
            <template #text> トリミングする </template>
          </SubmitButton>
          <NormalButton
            class="mx-2"
            :xLarge="true"
            @click="closeTrimmingDialog('beforeArrangement')"
          >
            <template #text>キャンセル</template>
          </NormalButton>
        </v-card-actions>
      </v-sheet>
    </v-dialog>
    <!-- アレンジ後のトリミング用ダイアログ -->
    <v-dialog
      v-model="afterArrangement.trimmingDialogDisplayed"
      maxWidth="650"
      :eager="true"
      persistent
    >
      <v-sheet id="after-trimming-dialog" class="pa-5 pa-md-10 mx-auto" color="#eeeeee">
        <VueCropper ref="afterArrangementCropper" :aspectRatio="1 / 1" :viewMode="2" class="mb-5" />
        <v-card-actions class="d-flex justify-center">
          <SubmitButton
            class="mx-2"
            :color="'#cc3918'"
            :xLarge="true"
            :loading="afterArrangement.trimLoading"
            @submit="uploadToS3('afterArrangementPhotoURL', 'afterArrangement')"
          >
            <template #text> トリミングする </template>
          </SubmitButton>
          <NormalButton
            class="mx-2"
            :xLarge="true"
            @click="closeTrimmingDialog('afterArrangement')"
          >
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
    beforeArrangementPhotoURL: {
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
      uploadFileName: '',
      beforeArrangement: {
        fileUploading: false,
        fileError: '',
        trimmingDialogDisplayed: false,
        trimLoading: false,
        previewDisplayed: false,
      },
      afterArrangement: {
        fileUploading: false,
        fileError: '',
        trimmingDialogDisplayed: false,
        trimLoading: false,
        previewDisplayed: false,
      },
    };
  },
  computed: {
    rules() {
      return {
        title: { required: true, max: 30 },
        context: { required: true, max: 1000 },
        images: { required: true, ext: ['jpeg', 'jpg', 'png'], size: 10000 },
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
    uploadBeforeArrangementfile() {
      document.querySelector('#before-arrangement').click();
    },
    uploadAfterArrangementfile() {
      document.querySelector('#after-arrangement').click();
    },
    deleteFile(column, ref) {
      this.$emit(`update:${column}`, '');
      this.$refs[ref].validate('');
      this[ref].previewDisplayed = false;
    },
    closeTrimmingDialog(ref) {
      this[ref].trimmingDialogDisplayed = false;
      this.$refs[ref].validate('');
    },
    async handleFileChange(ref, file) {
      const result = await this.$refs[ref].validate(file);
      if (result.valid) {
        this[ref].fileUploading = true;
        this[ref].fileError = '';
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
              this[ref].fileUploading = false;
              this[ref].trimmingDialogDisplayed = true;
              this.$refs[`${ref}Cropper`].replace(src);
            });
          })
          .catch((err) => {
            alert('サイズが大き過ぎます。他の写真を投稿してください。');
            console.log(err);
          });
        URL.revokeObjectURL(imageURL);
      } else {
        this[ref].fileError = result.errors[0];
      }
    },
    async uploadToS3(column, ref) {
      this[ref].trimLoading = true;
      const res = await this.$devour.request(`${this.$devour.apiUrl}/presigned_post/new`, 'GET');
      const formData = await this.createFormData(ref, res.meta.fields);

      this.$devour.request(res.meta.url, 'POST', {}, formData).then((res) => {
        this.$emit(`update:${column}`, res.meta.url);
        this[ref].trimmingDialogDisplayed = false;
        this[ref].previewDisplayed = true;
        this[ref].trimLoading = false;
      });
    },
    createFormData(ref, fields) {
      return new Promise((resolve) => {
        this.$refs[`${ref}Cropper`]
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
