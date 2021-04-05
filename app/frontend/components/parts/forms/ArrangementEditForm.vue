<template>
  <v-dialog :value="isShow" width="650px" @click:outside="closeDialog">
    <v-sheet id="arrangement-edit-form" class="pa-10" color="#eeeeee" :rounded="true">
      <div class="text-center mb-5">
        <v-img class="mx-auto mb-5" :src="images ? images[0] : ''" width="70%" />
        <div>
          <NormalButton @click="actionInputFile">
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
            :color="'#ff5252'"
            :disabled="invalid"
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
  },
  data() {
    return {
      fileErrorDisplayed: false,
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
