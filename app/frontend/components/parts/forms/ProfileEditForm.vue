<template>
  <v-dialog :value="isShow" width="650px" @click:outside="closeDialog">
    <v-sheet id="profile-edit-form" class="pa-5 pa-md--10">
      <div class="text-center mb-5">
        <v-avatar class="mb-5" tile size="200">
          <v-img :src="avatar_url" lazySrc="/images/dummy.png" />
        </v-avatar>
        <div>
          <NormalButton :loading="fileUploading" @click="fileUpload">
            <template #text>プロフィール画像を変更</template>
          </NormalButton>
          <div>
            <div class="text-caption light-weight-text">画像形式: JPEG/PNG</div>
            <div class="text-caption light-weight-text">容量: 10MB以内</div>
          </div>
        </div>
      </div>
      <ValidationProvider
        ref="fileForm"
        v-slot="{ errors }"
        tag="form"
        name="プロフィール画像"
        mode="change"
        :rules="rules.avatar"
      >
        <v-file-input
          id="user-avatar"
          label="プロフィール画像"
          style="display: none"
          accept="image/jpg, image/jpeg, image/png"
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
            <SubmitButton class="mx-2" :color="'#cc3918'" :xLarge="true" @submit="uploadToS3">
              <template #text> トリミングする </template>
            </SubmitButton>
            <NormalButton class="mx-2" :xLarge="true" @click="closeTrimmingDialog">
              <template #text>キャンセル</template>
            </NormalButton>
          </v-card-actions>
        </v-sheet>
      </v-dialog>

      <ValidationObserver v-slot="{ handleSubmit }" class="pb-6" tag="form">
        <NicknameField
          :nickname="nickname"
          :rules="rules.nickname"
          @input="$emit('update:nickname', $event)"
        />
        <EmailField :email="email" :rules="rules.email" @input="$emit('update:email', $event)" />
        <div class="d-flex justify-center">
          <SubmitButton
            class="mx-2"
            :xLarge="true"
            :color="'#cc3918'"
            :loading="loading"
            @submit="handleSubmit(handleUpdateProfile)"
          >
            <template #text> 更新する </template>
          </SubmitButton>
          <NormalButton class="mx-2" :xLarge="true" @click="closeDialog">
            <template #text>戻る</template>
          </NormalButton>
        </div>
      </ValidationObserver>
      <p class="text-body2 text-center">
        パスワードを変更する場合は
        <a @click="changeDialog"> こちら </a>
      </p>
    </v-sheet>
  </v-dialog>
</template>

<script>
import Jimp from 'jimp/es';
import JimpJPEG from 'jpeg-js';
import NicknameField from '../formInputs/NicknameFiled';
import EmailField from '../formInputs/EmailField';
import SubmitButton from '../buttons/SubmitButton';
import NormalButton from '../buttons/NormalButton';

export default {
  components: {
    NicknameField,
    EmailField,
    SubmitButton,
    NormalButton,
  },
  props: {
    id: {
      type: String,
      required: true,
    },
    nickname: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
    // eslint-disable-next-line vue/prop-name-casing
    avatar_url: {
      type: String,
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
      uploadFileName: '',
    };
  },
  computed: {
    rules() {
      return {
        nickname: { required: true, isUnique: ['nickname', this.id], max: 30 },
        email: { required: true, email: true, isUnique: ['email', this.id], max: 50 },
        avatar: { size: 10000, ext: ['jpg', 'jpeg', 'png', 'gif'] },
      };
    },
  },
  methods: {
    fileUpload() {
      document.querySelector('#user-avatar').click();
    },
    handleUpdateProfile() {
      this.hideErrorMessage();
      this.$emit('updateProfile');
    },
    changeDialog() {
      this.hideErrorMessage();
      this.$emit('changeDialog');
    },
    closeDialog() {
      this.hideErrorMessage();
      this.$emit('closeDialog');
    },
    closeTrimmingDialog() {
      this.trimmingDialogDisplayed = false;
      this.$refs.fileForm.validate('');
    },
    hideErrorMessage() {
      // バリデーション失敗後だと、エラーメッセージが残ってしまう為
      this.$refs.fileForm.reset();
      this.fileErrorDisplayed = false;
    },
    async handleFileChange(file) {
      const result = await this.$refs.fileForm.validate(file);
      if (result.valid) {
        this.hideErrorMessage();
        this.fileUploading = true;
        this.uploadFileName = file.name.substring(0, file.name.lastIndexOf('.'));

        // jpegを読み込む際、メモリ不足で読む込みに失敗するのを防ぐ為
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
        this.fileErrorDisplayed = true;
      }
    },
    async uploadToS3() {
      const res = await this.$devour.request(`${this.$devour.apiUrl}/presigned_post/new`, 'GET');
      const formData = await this.createFormData(res.meta.fields);

      this.$devour.request(res.meta.url, 'POST', {}, formData).then((res) => {
        this.$emit('update:avatar_url', res.meta.url);
      });
      this.trimmingDialogDisplayed = false;
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
            // Blobが最後に読み込まれるようにする。
            // https://stackoverflow.com/questions/15234496/upload-directly-to-amazon-s3-using-ajax-returning-error-bucket-post-must-contai
            formData.append('file', blob, this.uploadFileName);
            resolve(formData);
          });
      });
    },
  },
};
</script>
