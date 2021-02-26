<template>
  <div>
    <p>トップページです</p>
    <div v-if="!!authUser">
      ログインしています
      <p>{{ authUser }}</p>
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
export default {
  data() {
    return {};
  },
  computed: {
    ...mapGetters('users', ['authUser']),
  },
  created() {
    this.fetchAuthUser();
  },
  methods: {
    ...mapActions('users', ['fetchAuthUser']),
  },
};
</script>
