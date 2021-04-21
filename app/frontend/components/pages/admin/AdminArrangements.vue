<template>
  <v-container>
    <v-row class="pt-5">
      <v-col>
        <v-data-table
          :headers="table.headers"
          :items="arrangements"
          hideDefaultFooter
          :itemsPerPage="20"
        >
        </v-data-table>
        <v-pagination
          v-model="pagy.currentPage"
          :length="pagy.pageCount"
          @input="fetchArrangements"
        />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      arrangements: [],
      pagy: {
        currentPage: 1,
        pageCount: null,
      },
    };
  },
  computed: {
    table() {
      return {
        headers: [
          {
            text: 'タイトル',
            align: 'start',
            value: 'title',
          },
          { text: '投稿日', value: 'created_at' },
          { text: 'いいね数', value: 'likes_count' },
          { text: 'コメント数', value: 'comments_count' },
          { text: '投稿者', value: 'user.nickname' },
        ],
      };
    },
  },
  created() {
    this.fetchArrangements();
  },
  methods: {
    fetchArrangements() {
      this.$devour
        .request(`${this.$devour.apiUrl}/admin/arrangements`, 'GET', {
          page: this.pagy.currentPage,
        })
        .then((res) => {
          this.arrangements = res.data;
          const pagy = res.meta.pagy;
          this.pagy.pageCount = pagy.pages;
        });
    },
  },
};
</script>
