<template>
  <v-dialog :value="isShow" width="650px" @click:outside="closeDialog">
    <v-sheet id="arrangement-edit-form" class="pa-10" color="#eeeeee" :rounded="true">
      <div class="text-center mb-5">
        <v-img class="mx-auto mb-5" :src="images ? images[0] : ''" width="70%" />
        <div>
          <NormalButton :loading="fileUploading" @click="fileUpload">
            <template #text>投稿写真を変更する</template>
          </NormalButton>
          <div>
            <div class="text-caption light-weight-text">画像形式: JPEG/PNG</div>
            <div class="text-caption light-weight-text">容量: 10MB以内</div>
          </div>
        </div>
      </div>
      <ValidationProvider
        v-slot="{ errors }"
        ref="fileForm"
        name="投稿写真"
        mode="change"
        :rules="rules.images"
      >
        <v-file-input
          id="arrangement-images"
          label="投稿写真"
          accept="image/jpg, image/jpeg, image/png, image/gif"
          style="display: none"
          @change="handleFileChange"
        />
        <v-alert :value="fileErrorDisplayed" type="error" dense outlined :icon="false">
          {{ errors[0] }}
        </v-alert>
      </ValidationProvider>

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

      <ValidationObserver ref="form" v-slot="{ invalid }" tag="form">
        <TitleField :title="title" :rules="rules.title" @input="$emit('update:title', $event)" />
        <ContextField
          :context="context"
          :rules="rules.context"
          @input="$emit('update:context', $event)"
        />
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
    images: {
      type: Array,
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
      fileErrorDisplayed: false,
      fileUploading: false,
      trimmingDialogDisplayed: false,
      imgSrc: '',
    };
  },
  computed: {
    rules() {
      return {
        images: { required: true, size: 10000, ext: ['jpg', 'jpeg', 'png'] },
        title: { required: true, max: 30 },
        context: { required: true, max: 1000 },
      };
    },
  },
  methods: {
    fileUpload() {
      document.querySelector('#arrangement-images').click();
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
      this.$refs.fileForm.reset();
      this.fileErrorDisplayed = false;
    },
    closeTrimmingDialog() {
      this.trimmingDialogDisplayed = false;
      this.$refs.fileForm.validate('');
    },
    async handleFileChange(value) {
      const result = await this.$refs.fileForm.validate(value);
      if (result.valid) {
        this.hideErrorMessage();
        this.fileUploading = true;

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
        this.fileErrorDisplayed = true;
      }
    },
    imageTrimming() {
      const trimmedImage = this.$refs.cropper
        .getCroppedCanvas({
          width: 300,
          height: 300,
          fillColor: '#eeeeee',
          imageSmoothingQuality: 'medium',
        })
        .toDataURL();
      this.$emit('uploadFile', trimmedImage);
      this.trimmingDialogDisplayed = false;
    },
  },
};
</script>
