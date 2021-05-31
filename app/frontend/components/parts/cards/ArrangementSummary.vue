<template>
  <v-sheet color="#eeeeee">
    <v-card
      :id="`arrangement-${arrangement.id}`"
      class="arrangement-summary"
      height="100%"
      color="#eeeeee"
      :to="{ name: 'ArrangementShow', params: { id: arrangement.id } }"
      elevation="0"
    >
      <v-img
        :src="arrangement.after_arrangement_photo.url"
        lazySrc="/images/dummy.png"
        style="positon: relative"
      >
        <template v-if="arrangement.arrange_level === 1">
          <v-avatar
            color="red"
            class="font-weight-bold"
            style="position: absolute; top: 0; left: 0; color: #ffef02"
            size="52"
          >
            激変
          </v-avatar>
        </template>
        <template v-else>
          <v-avatar
            color="#009FE8"
            class="font-weight-bold"
            style="position: absolute; top: 0; left: 0; color: #ffef02"
            size="52"
          >
            <span>ちょい足し</span>
          </v-avatar>
        </template>

        <v-img
          :src="arrangement.before_arrangement_photo.url"
          width="25%"
          style="position: absolute; bottom: 0; right: 0"
        />

        <template #placeholder>
          <v-row class="fill-height ma-0" align="center" justify="center">
            <VueLoading type="spiningDubbles" color="#4CAF50" />
          </v-row>
        </template>
      </v-img>

      <v-card-title class="d-flex justify-end pa-0">
        <v-rating
          dense
          small
          color="orange"
          readonly
          backgroundColor="orange ligh"
          :length="5"
          :value="arrangement.rating"
        />
      </v-card-title>

      <v-card-title class="pt-0 font-weight-bold text-truncate d-inline-block" style="width: 100%">
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
      <slot name="arrangement-parameter" />
    </v-card>
    <div class="text-end">
      <v-btn color="#1DA1F2" style="color: white" small :value="true" :href="twitterShareUrl">
        <v-icon class="mr-1"> mdi-twitter </v-icon>
        シェアする
      </v-btn>
    </div>
  </v-sheet>
</template>

<script>
export default {
  props: {
    arrangement: {
      type: Object,
      required: true,
    },
    twitterShareUrl: {
      type: String,
      default: '',
    },
    raitingLarge: {
      type: Boolean,
      default: false,
    },
  },
};
</script>
