<template>
  <v-sheet :id="`arrangement-${arrangement.id}`" height="100%" color="#eeeeee">
    <v-img v-for="(image, $imageIndex) in arrangement.images" :key="$imageIndex" :src="image" />
    <v-card-title class="mb-4">
      <h4 class="text-subtitle-1 font-weight-bold">{{ arrangement.title }}</h4>
    </v-card-title>
    <v-card-subtitle class="d-flex">
      <v-avatar size="25" class="mr-4">
        <img :src="user.avatar" />
      </v-avatar>
      <h4 class="text-subtitle-1">
        {{ user.nickname }}
      </h4>
    </v-card-subtitle>
  </v-sheet>
</template>

<script>
export default {
  props: {
    arrangement: {
      type: Object,
      required: true,
    },
    user: {
      type: Object,
      required: true,
    },
  },
};
</script>
