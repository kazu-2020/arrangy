<template>
  <v-card
    :id="`arrangement-${arrangement.id}`"
    height="100%"
    color="#eeeeee"
    :to="{ name: 'ArrangementShow', params: { id: arrangement.id } }"
    elevation="0"
  >
    <v-img v-for="(image, $imageIndex) in arrangement.images" :key="$imageIndex" :src="image">
    </v-img>
    <v-card-title class="font-weight-bold">
      {{ arrangement.title }}
    </v-card-title>
    <v-card-subtitle class="d-flex text-caption">
      {{ arrangement.created_at }}
      <v-spacer />
      <div class="mr-1">
        <v-icon small>mdi-thumb-up-outline</v-icon>
        {{ arrangement.likes_count }}
      </div>
      <div>
        <v-icon small>mdi-comment-outline</v-icon>
        {{ arrangement.comments_count }}
      </div>
    </v-card-subtitle>
    <slot name="user-information" />
  </v-card>
</template>

<script>
export default {
  props: {
    arrangement: {
      type: Object,
      required: true,
    },
  },
};
</script>
