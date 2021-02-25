<template>
  <v-container fill-height>
    <v-row class="d-flex justify-center">
      <v-col cols="12" sm="7">
        <v-card class="pa-4">
          <div class="text-h6 pt-8 px-8 text-center font-weight-black">新規投稿</div>
          <v-card-text>
            <v-text-field
              id="arrangement-title"
              v-model="arrangement.title"
              type="text"
              label="タイトル"
              clearable
            />
            <v-textarea
              id="arrangement-context"
              v-model="arrangement.context"
              label="投稿内容"
              outlined
              auto-grow
              clearable
            />
          </v-card-text>
          <v-card-actions class="d-flex justify-center">
            <v-btn @click="createArrangement"> 投稿する </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      arrangement: {
        title: '',
        context: '',
      },
    };
  },
  methods: {
    createArrangement() {
      this.$axios
        .post('arrangements', this.arrangement)
        .then(() => alert('投稿しました'))
        .catch((error) => console.log(error));
    },
  },
};
</script>
