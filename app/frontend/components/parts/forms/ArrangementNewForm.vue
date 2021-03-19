<template>
  <div>
    <v-img v-show="isPreview" class="mb-5" :src="previewImage" contain height="300" />
    <ValidationObserver v-slot="{ handleSubmit }">
      <v-card-text>
        <ImagesField
          ref="avatar"
          :rules="rules.images"
          @change="$emit('uploadFile', $event)"
          @uploadFile="handleFileChange"
        />
        <TitleField :title="title" :rules="rules.title" @input="$emit('update:title', $event)" />
        <ContextField
          :context="context"
          :rules="rules.context"
          @input="$emit('update:context', $event)"
        />
      </v-card-text>
      <v-card-actions class="d-flex justify-center">
        <v-btn
          style="color: white"
          color="#ff5252"
          xLarge
          :loading="isLoading"
          :disabled="isLoading"
          @click="handleSubmit(handleCreateArrangement)"
        >
          <v-icon class="mr-1">mdi-send</v-icon>
          投稿する
        </v-btn>
      </v-card-actions>
    </ValidationObserver>
  </div>
</template>

<script>
import Jimp from 'jimp/es';
import TitleField from '../formInputs/TitleField';
import ContextField from '../formInputs/ContextField';
import ImagesField from '../formInputs/ImagesField';

export default {
  components: {
    TitleField,
    ContextField,
    ImagesField,
  },
  props: {
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
    isLoading: {
      type: Boolean,
    },
  },
  data() {
    return {
      rules: {
        images: { required: true, ext: ['jpg', 'jpeg', 'png', 'gif'], size: 10240 },
        title: { required: true, max: 30 },
        context: { required: true, max: 1000 },
      },
      previewImage: '',
      isPreview: false,
    };
  },
  methods: {
    handleCreateArrangement() {
      this.$emit('createArrangement');
    },
    async handleFileChange(value) {
      const result = await this.$refs.avatar.$refs.fileForm.validate(value);
      if (result.valid) {
        const imageURL = URL.createObjectURL(value);
        Jimp.read(imageURL)
          .then((image) => {
            image.cover(300, 300).getBase64(Jimp.MIME_PNG, (err, src) => {
              this.$emit('uploadFile', src);
              this.previewImage = src;
              this.isPreview = true;
            });
            URL.revokeObjectURL(imageURL);
          })
          .catch((error) => {
            alert('アップロードに失敗しました');
            console.log(error);
          });
      } else {
        this.previewImage = '';
        this.isPreview = false;
      }
    },
  },
};
</script>
