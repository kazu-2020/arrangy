<template>
  <div>
    <p>トップページです</p>
    <div v-if="!!authUser">
      ログインしています
      <p>{{ authUser }}</p>
      <template v-for="arrangement in arrangements">
        <div :key="arrangement.id">
          <p>{{ arrangement }}</p>
          data:image/gif;base64,
          <img :src="arrangement.images[0].url" />
        </div>
      </template>
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
export default {
  data() {
    return {
      arrangements: '',
    };
  },
  computed: {
    ...mapGetters('users', ['authUser']),
  },
  created() {
    this.fetchAuthUser();
    this.fetchArrangements();
  },
  methods: {
    ...mapActions('users', ['fetchAuthUser']),
    fetchArrangements() {
      this.$axios.get('arrangements').then((res) => (this.arrangements = res.data));
    },
  },
};
</script>
