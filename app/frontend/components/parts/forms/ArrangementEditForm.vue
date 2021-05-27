<template>
  <v-dialog :value="isShow" width="800px" @click:outside="closeDialog">
    <v-sheet id="arrangement-edit-form" class="pa-10" color="#eeeeee" :rounded="true">
      <v-row>
        <!-- アレンジ前の写真 -->
        <v-col cols="12" md="6">
          <div class="text-center mb-5">
            <v-img
              class="mx-auto mb-5"
              :src="beforeArrangementPhotoURL"
              :lazySrc="beforeArrangementPhotoURL"
            >
              <template #placeholder>
                <v-row class="fill-height ma-0" align="center" justify="center">
                  <VueLoading type="spiningDubbles" color="#4CAF50" />
                </v-row>
              </template>
            </v-img>
            <div>
              <NormalButton
                :loading="beforeArrangement.fileUploading"
                @click="uploadBeforeArrangementfile"
              >
                <template #text>アレンジ前の写真を変更する</template>
              </NormalButton>
              <div>
                <div class="text-caption light-weight-text">画像形式: JPEG/PNG</div>
                <div class="text-caption light-weight-text">容量: 10MB以内</div>
              </div>
            </div>
          </div>

          <ValidationProvider
            v-slot="{ errors }"
            ref="beforeArrangement"
            name="アレンジ前の写真"
            mode="change"
            :rules="rules.images"
          >
            <v-file-input
              id="before-arrangement"
              label="アレンジ前の写真"
              accept="image/jpg, image/jpeg, image/png, image/gif"
              style="display: none"
              @change="handleFileChange('beforeArrangement', $event)"
            />
            <v-alert
              :value="beforeArrangement.fileErrorDisplayed"
              type="error"
              dense
              outlined
              :icon="false"
            >
              {{ errors[0] }}
            </v-alert>
          </ValidationProvider>
        </v-col>
        <!-- アレンジ後の写真 -->
        <v-col cols="12" md="6">
          <div class="text-center mb-5">
            <v-img
              class="mx-auto mb-5"
              :src="afterArrangementPhotoURL"
              :lazySrc="afterArrangementPhotoURL"
            >
              <template #placeholder>
                <v-row class="fill-height ma-0" align="center" justify="center">
                  <VueLoading type="spiningDubbles" color="#4CAF50" />
                </v-row>
              </template>
            </v-img>
            <div>
              <NormalButton
                :loading="afterArrangement.fileUploading"
                @click="uploadAfterArrangementfile"
              >
                <template #text>アレンジ後の写真を変更する</template>
              </NormalButton>
              <div>
                <div class="text-caption light-weight-text">画像形式: JPEG/PNG</div>
                <div class="text-caption light-weight-text">容量: 10MB以内</div>
              </div>
            </div>
          </div>
        </v-col>

        <ValidationProvider
          v-slot="{ errors }"
          ref="afterArrangement"
          name="アレンジ後の写真"
          mode="change"
          :rules="rules.images"
        >
          <v-file-input
            id="after-arrangement"
            label="アレンジ後の写真"
            accept="image/jpg, image/jpeg, image/png, image/gif"
            style="display: none"
            @change="handleFileChange('afterArrangement', $event)"
          />
          <v-alert
            :value="afterArrangement.fileErrorDisplayed"
            type="error"
            dense
            outlined
            :icon="false"
          >
            {{ errors[0] }}
          </v-alert>
        </ValidationProvider>
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
          <VueCropper
            ref="afterArrangementCropper"
            :aspectRatio="1 / 1"
            :viewMode="2"
            class="mb-5"
          />
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

      <ValidationObserver ref="form" v-slot="{ invalid }" tag="form">
        <TitleField :title="title" :rules="rules.title" @input="$emit('update:title', $event)" />
        <ContextField
          :context="context"
          :rules="rules.context"
          @input="$emit('update:context', $event)"
        />
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
        <div class="text-center">
          <SubmitButton
            class="mx-2"
            :xLarge="true"
            :color="'#cc3918'"
            :disabled="invalid"
            :loading="loading"
            @submit="handleUpdateArrangement"
          >
            <template #text>変更する</template>
          </SubmitButton>
          <NormalButton class="mx-2" :xLarge="true" @click="closeDialog">
            <template #text>戻る</template>
          </NormalButton>
        </div>
      </ValidationObserver>
    </v-sheet>
  </v-dialog>
</template>

<script>
import Jimp from 'jimp/es';
import JimpJPEG from 'jpeg-js';

import ContextField from '../formInputs/ContextField';
import NormalButton from '../buttons/NormalButton';
import SubmitButton from '../buttons/SubmitButton';
import TitleField from '../formInputs/TitleField';
import ParameterField from '../formInputs/ParameterField';

export default {
  components: {
    ContextField,
    NormalButton,
    SubmitButton,
    TitleField,
    ParameterField,
  },
  props: {
    id: {
      type: String,
      required: true,
    },
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

    isShow: {
      type: Boolean,
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
        fileErrorDisplayed: false,
        trimmingDialogDisplayed: false,
        trimLoading: false,
        previewDisplayed: false,
      },
      afterArrangement: {
        fileUploading: false,
        fileError: '',
        fileErrorDisplayed: false,
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
        images: { required: true, size: 10000, ext: ['jpg', 'jpeg', 'png'] },
      };
    },
  },
  methods: {
    uploadBeforeArrangementfile() {
      document.querySelector('#before-arrangement').click();
    },
    uploadAfterArrangementfile() {
      document.querySelector('#after-arrangement').click();
    },
    handleUpdateArrangement() {
      this.hideErrorMessage();
      this.$emit('updateArrangement');
    },
    closeDialog() {
      this.hideErrorMessage();
      this.$emit('closeDialog');
    },
    hideErrorMessage() {
      // バリデーション失敗後だと、エラーメッセージが残ってしまう為
      this.beforeArrangement.fileErrorDisplayed = false;
      this.afterArrangement.fileErrorDisplayed = false;
      this.$refs.beforeArrangement.reset();
      this.$refs.afterArrangement.reset();
      this.fileErrorDisplayed = false;
    },
    closeTrimmingDialog(ref) {
      this[ref].trimmingDialogDisplayed = false;
      this.$refs[ref].validate('');
    },
    async handleFileChange(ref, file) {
      const result = await this.$refs[ref].validate(file);
      if (result.valid) {
        this[ref].fileUploading = true;
        this.$refs[ref].reset();
        this[ref].fileErrorDisplayed = false;
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
        this[ref].fileErrorDisplayed = true;
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
