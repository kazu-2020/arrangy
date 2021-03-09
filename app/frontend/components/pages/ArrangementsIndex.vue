<template>
  <v-container>
    <WelcomeDialog
      :dialog="isVisiableWelcomeDialog"
      @close-dialog="isVisiableWelcomeDialog = false"
    />
    <v-row>
      <v-col v-for="(arrangement, $index) in arrangements" :key="$index" cols="12" sm="4" md="4">
        <v-card height="100%">
          <v-img
            v-for="(image, $imageIndex) in arrangement.images"
            :key="$imageIndex"
            :src="image.url"
            height="300"
          />
          <v-card-title class="d-flex flex-nowrap">
            <v-avatar size="25" color="indigo" class="mx-3" />
            <div class="text-subtitle-1 text-nowrap">{{ arrangement.title }}</div>
          </v-card-title>
          <v-spacer />
          <v-card-subtitle>
            <div class="text-subtitle-1">
              {{ arrangement.user.nickname }}
            </div>
          </v-card-subtitle>
        </v-card>
      </v-col>
      <infinite-loading
        v-if="pagy.isActioned"
        direction="bottom"
        spinner="circles"
        @infinite="infiniteHandler"
      >
        <div slot="no-more" />
      </infinite-loading>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import WelcomeDialog from '../parts/WelcomeDialog.vue';
export default {
  components: {
    WelcomeDialog,
  },
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
      arrangements: [],
      isVisiableWelcomeDialog: false,
      pagy: {
        currentPage: 1,
        isActioned: false,
      },
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
      this.$devour.findAll('arrangement', { page: this.pagy.currentPage }).then((res) => {
        this.arrangements.push(...res.data);
        this.pagy.currentPage += 1;
        this.pagy.isActioned = true;
      });
    },
    infiniteHandler($state) {
      this.$devour.findAll('arrangement', { page: this.pagy.currentPage }).then((res) => {
        if (this.pagy.currentPage < res.meta.pagy.pages) {
          this.pagy.currentPage += 1;
          this.arrangements.push(...res.data);
          $state.loaded();
        } else {
          this.arrangements.push(...res.data);
          $state.complete();
        }
      });
    },
  },
};
</script>
