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
      accept="image/jpg, image/jpeg, image/png, image/gif"
      color="black"
      clearable
      hint="有効なファイル形式はjpg jpeg png gifです"
      prependIcon
      prependInnerIcon="mdi-camera"
      persistentHint
      :errorMessages="errors"
      @change="$emit('uploadFile', $event)"
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
export default {
  props: {
    rules: {
      type: Object,
      required: true,
    },
  },
};
</script>
