<template>
  <v-dialog :value="isShow" width="650px" @click:outside="closeDialog">
    <v-sheet id="arrangement-edit-form" class="pa-10" color="#eeeeee" :rounded="true">
      <div class="text-center mb-5">
        <v-img class="mx-auto mb-5" :src="images[0]" width="70%" style="border-radius: 15px" />
        <div>
          <v-btn @click="actionInputFile">変更</v-btn>
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
      <ValidationObserver ref="form" v-slot="{ handleSubmit }" tag="form">
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
            :color="'#ff5252'"
            @submit="handleSubmit(handleUpdateArrangement)"
          >
            <template #text>更新</template>
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
    isShow: {
      type: Boolean,
    },
  },
  data() {
    return {
      rules: {
        images: { size: 10240, ext: ['jpg', 'jpeg', 'png', 'gif'] },
        title: { required: true, max: 30 },
        context: { required: true, max: 1000 },
      },
      fileErrorDisplayed: false,
    };
  },
  methods: {
    actionInputFile() {
      document.querySelector('#arrangement-images').click();
    },
    async handleFileChange(value) {
      const result = await this.$refs.fileForm.validate(value);
      if (result.valid) {
        this.hideErrorMessage();
        const imageURL = URL.createObjectURL(value);
        Jimp.read(imageURL)
          .then((image) => {
            image.cover(300, 300).getBase64(Jimp.MIME_PNG, (err, src) => {
              this.$emit('uploadFile', src);
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
  },
};
</script>
