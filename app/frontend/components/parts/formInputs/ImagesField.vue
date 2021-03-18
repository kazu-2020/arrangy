<template>
  <ValidationProvider
    v-slot="{ errors }"
    ref="fileForm"
    name="投稿写真"
    mode="change"
    :rules="rules"
  >
    <v-file-input
      id="arrangement-images"
      label="投稿写真"
      color="black"
      clearable
      hint="有効なファイル形式はjpg jpeg png gifです"
      prependIcon
      prependInnerIcon="mdi-camera"
      persistentHint
      :errorMessages="errors"
      @change="handleFileChange"
    >
      <template #selection="{ text }">
        <v-chip small label color="grey lighten-1">
          {{ text }}
        </v-chip>
      </template>
    </v-file-input>
  </ValidationProvider>
</template>

<script>
import Jimp from 'jimp/es';

export default {
  props: {
    rules: {
      type: Object,
      required: true,
    },
  },
  methods: {
    async handleFileChange(value) {
      const result = await this.$refs.fileForm.validate(value);
      if (result.valid) {
        const imageURL = URL.createObjectURL(value);
        Jimp.read(imageURL)
          .then((image) => {
            image.cover(300, 300).getBase64(Jimp.MIME_PNG, (err, src) => {
              this.$emit('change', src);
              this.$emit('handlePreview', true, src);
            });
            URL.revokeObjectURL(imageURL);
          })
          .catch((error) => {
            alert('アップロードに失敗しました');
            console.log(error);
          });
      } else {
        this.$emit('change', null);
        this.$emit('handlePreview', false, null);
      }
    },
  },
};
</script>
