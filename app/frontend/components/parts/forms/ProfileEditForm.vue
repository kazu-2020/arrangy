<template>
  <v-dialog :value="isShow" width="650px" @click:outside="closeDialog">
    <v-sheet id="profile-edit-form" class="pa-10">
      <div class="text-center mb-5">
        <v-avatar class="or-avatar mb-5" size="200">
          <img :src="avatar" />
        </v-avatar>
        <div>
          <NormalButton @click="actionInputFile">
            <template #text>プロフィール画像を変更</template>
          </NormalButton>
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
          style="display: none"
          accept="image/jpg, image/jpeg, image/png, image/gif"
          @change="handleAvatarChange"
        />
        <v-alert :value="fileErrorDisplayed" type="error" dense outlined :icon="false">
          {{ errors[0] }}
        </v-alert>
      </ValidationProvider>
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
            :color="'#ff5252'"
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
    avatar: {
      type: String,
      required: true,
    },
    isShow: {
      type: Boolean,
    },
  },
  data() {
    return {
      rules: {
        nickname: { required: true, isUnique: ['nickname', this.id], max: 30 },
        email: { required: true, email: true, isUnique: ['email', this.id], max: 50 },
        avatar: { size: 10000, ext: ['jpg', 'jpeg', 'png', 'gif'] },
      },
      fileErrorDisplayed: false,
    };
  },
  methods: {
    actionInputFile() {
      document.querySelector('#user-avatar').click();
    },
    async handleAvatarChange(value) {
      const result = await this.$refs.fileForm.validate(value);
      if (result.valid) {
        this.hideErrorMessage();
        const imageURL = URL.createObjectURL(value);
        Jimp.read(imageURL)
          .then((image) => {
            image.cover(300, 300).getBase64(Jimp.MIME_PNG, (err, src) => {
              this.$emit('update:avatar', src);
            });
            URL.revokeObjectURL(imageURL);
          })
          .catch((error) => {
            alert('アップロードに失敗しました');
            console.log(error);
          });
      } else {
        this.fileErrorDisplayed = true;
      }
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
    hideErrorMessage() {
      // バリデーション失敗後だと、エラーメッセージが残ってしまう為
      this.$refs.fileForm.reset();
      this.fileErrorDisplayed = false;
    },
  },
};
</script>
