<template>
  <v-dialog :value="isShow" width="650px" @click:outside="closeDialog">
    <v-sheet class="pa-10">
      <div class="text-center mb-5">
        <v-avatar class="or-avatar mb-5" size="200">
          <img :src="avatar" />
        </v-avatar>
        <div>
          <v-btn @click="actionInputFile">プロフィール画像を変更</v-btn>
        </div>
      </div>
      <ValidationProvider
        ref="fileForm"
        v-slot="{ errors }"
        name="プロフィール画像"
        mode="change"
        :rules="formRules.avatar"
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
      <ValidationObserver v-slot="{ handleSubmit }">
        <ValidationProvider
          v-slot="{ errors }"
          name="ニックネーム"
          mode="blur"
          :rules="formRules.nickname"
        >
          <v-text-field
            id="user-nickname"
            label="ニックネーム"
            type="text"
            :errorMessages="errors"
            :value="nickname"
            @input="$emit('update:nickname', $event)"
          />
        </ValidationProvider>
        <ValidationProvider
          v-slot="{ errors }"
          name="メールアドレス"
          mode="blur"
          :rules="formRules.email"
        >
          <v-text-field
            id="user-email"
            class="mb-6"
            label="メールアドレス"
            type="email"
            :errorMessages="errors"
            :value="email"
            @input="$emit('update:email', $event)"
          />
        </ValidationProvider>
        <div class="d-flex justify-center">
          <v-btn
            class="mx-4"
            xLarge
            style="color: white"
            color="red accent-2"
            @click="handleSubmit(handleUpdateUser)"
          >
            更新する
          </v-btn>
          <v-btn class="mx-4" xLarge @click="closeDialog">戻る</v-btn>
        </div>
      </ValidationObserver>
    </v-sheet>
  </v-dialog>
</template>

<script>
import Jimp from 'jimp/es';

export default {
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
      formRules: {
        nickname: { required: true, isUnique: ['nickname', this.id], max: 10 },
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
    handleUpdateUser() {
      this.hideErrorMessage();
      this.$emit('updateUser');
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
