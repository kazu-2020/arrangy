<template>
  <v-container fluid class="d-flex justify-sm-center">
    <v-row>
      <v-col v-for="arrangement in arrangements" :key="arrangement.id" cols="12" md="3">
        <v-card>
          <template v-for="image in arrangement.images">
            <v-img :key="image.id" :src="image.url" />
          </template>
          <v-card-title>
            <v-avatar size="36" color="indigo" class="mx-3" />
            <div>{{ arrangement.title }}</div>
          </v-card-title>
          <v-spacer />
          <v-card-subtitle>
            <div class="text-subtitle-1">{{ arrangement.user.nickname }}</div>
          </v-card-subtitle>
        </v-card>
      </v-col>
      {{ arrangements }}
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
export default {
  beforeRouteEnter(to, from, next) {
    if (from.name === 'UserRegister')
      next((self) => {
        self.fetchAuthUser().then((authUser) => {
          if (authUser) return (self.isVisiableWelcomeDialog = true);
        });
      });
    else next();
  },
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
      this.$devour.define('arrangement', {
        title: '',
        context: '',
        images: [],
        user: {
          jsonApi: 'hasOne',
          type: 'user',
        },
      });

      this.$devour.define('user', {
        nickname: '',
        email: '',
      });

      this.$devour.findAll('arrangement').then((res) => (this.arrangements = res.data));
    },
  },
};
</script>
