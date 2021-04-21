<template>
  <v-container>
    <v-row class="pt-5">
      <v-col>
        <v-data-table :headers="table.headers" :items="users" hideDefaultFooter :itemsPerPage="20">
        </v-data-table>
        <v-pagination v-model="pagy.currentPage" :length="pagy.pageCount" @input="fetchUsers" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      users: [],
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
            text: '投稿者名',
            align: 'start',
            value: 'nickname',
          },
          {
            text: 'アドレス',
            value: 'email',
          },
          {
            text: '権限',
            value: 'role',
          },
          {
            text: '登録日',
            value: 'created_at',
          },
        ],
      };
    },
  },
  created() {
    this.fetchUsers();
  },
  methods: {
    fetchUsers() {
      this.$devour
        .request(`${this.$devour.apiUrl}/admin/users`, 'GET', { pagy: this.pagy.currentPage })
        .then((res) => {
          console.log(res.data);
          this.users = res.data;
          const pagy = res.meta.pagy;
          this.pagy.pageCount = pagy.pages;
        });
    },
  },
};
</script>
