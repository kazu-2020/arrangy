<template>
  <div>
    <v-footer fixed height="60" color="grey lighten-5">
      <v-row justify="center" noGutters>
        <v-btn v-for="link in links" :key="link" color="black" text rounded class="my-2">
          {{ link }}
        </v-btn>
      </v-row>
    </v-footer>
  </div>
</template>

<script>
export default {
  data() {
    return {
      links: ['Arrangyについて', '利用規約', 'お問い合わせ'],
    };
  },
};
</script>
