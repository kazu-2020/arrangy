<template>
  <v-dialog :value="is_show" width="650px" @click:outside="$emit('closeDialog')">
    <v-sheet class="pa-10">
      <ValidationObserver v-slot="{ handleSubmit }">
        <div class="text-center">
          <v-avatar class="mb-5" size="200">
            <img :src="avatar" />
          </v-avatar>
        </div>
        <FilePond
          ref="pond"
          credits
          allow-image-preview="false"
          max-file-size="10MB"
          image-resize-target-width="300"
          image-resize-target-height="300"
          image-resize-mode="cover"
          image-transform-output-mime-type="image/png"
          label-max-file-size
          file-validate-type-label-expected-types
          :label-idle="avatarFile.label"
          :label-max-file-size-exceeded="avatarFile.errorMessages.size"
          :label-file-type-not-allowed="avatarFile.errorMessages.type"
          :accepted-file-types="avatarFile.type"
          :onpreparefile="onpreparefile"
        />
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
            :error-messages="errors"
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
            :error-messages="errors"
            :value="email"
            @input="$emit('update:email', $event)"
          />
        </ValidationProvider>
        <div class="d-flex justify-center">
          <v-btn
            class="mx-4"
            x-large
            style="color: white"
            color="red accent-2"
            @click="handleSubmit(handleUpdateUser)"
          >
            更新する
          </v-btn>
          <v-btn class="mx-4" x-large @click="$emit('closeDialog')">戻る</v-btn>
        </div>
      </ValidationObserver>
    </v-sheet>
  </v-dialog>
</template>

<script>
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
    is_show: {
      type: Boolean,
    },
  },
  data() {
    return {
      avatarFile: {
        label: 'プロフィール画像を選択してください',
        type: 'image/jpg, image/jpeg, image/png, image/gif',
        errorMessages: {
          size: 'ファイルサイズは最大10MBです',
          type: 'jpg png gifを使用できます',
        },
      },
      formRules: {
        nickname: { required: true, isUnique: ['nickname', this.id], max: 10 },
        email: { required: true, email: true, isUnique: ['email', this.id], max: 50 },
      },
    };
  },
  methods: {
    onpreparefile(file, output) {
      const reader = new FileReader();
      reader.readAsDataURL(output);
      reader.onload = () => {
        this.$emit('update:avatar', reader.result);
      };
    },
    handleUpdateUser() {
      this.$emit('updateUser');
    },
  },
};
</script>
