<template>
  <div>
    <p>トップページです</p>
    <p v-if="!!authUser">ログインしています</p>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
export default {
  data() {
    return {};
  },
  created() {
    this.fetchAuthUser();
  },
  computed: {
    ...mapGetters('users', ['authUser']),
  },
  methods: {
    ...mapActions('users', ['fetchAuthUser']),
  },
};
</script>
