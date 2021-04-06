<template>
  <v-container>
    <WelcomeDialog :dialog="welcomeDialogDisplayed" @close-dialog="closeWelcomeDialog" />
    <v-row>
      <v-col v-for="(arrangement, $index) in arrangements" :key="$index" cols="12" sm="4" md="4">
        <ArrangementSummary :arrangement="arrangement">
          <template slot="user-information">
            <v-card-text>
              <v-row>
                <v-col cols="auto">
                  <v-avatar size="25">
                    <v-img
                      :id="`arrangement-avatar${arrangement.id}`"
                      :src="arrangement.user.avatar"
                    />
                  </v-avatar>
                </v-col>
                <v-col cols="auto">
                  <div class="text-subtitle-1 font-weight-black">
                    {{ arrangement.user.nickname }}
                  </div>
                </v-col>
              </v-row>
            </v-card-text>
          </template>
        </ArrangementSummary>
      </v-col>
      <infinite-loading
        v-if="pagy.isActioned"
        direction="bottom"
        spinner="circles"
        @infinite="infiniteHandler"
      >
        <div slot="no-more" />
        <div slot="no-results" />
      </infinite-loading>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import WelcomeDialog from '../../parts/dialogs/WelcomeDialog.vue';
import ArrangementSummary from '../../parts/cards/ArrangementSummary';

export default {
  components: {
    WelcomeDialog,
    ArrangementSummary,
  },
  beforeRouteEnter(to, from, next) {
    if (from.name === 'UserRegister')
      next((self) => {
        self.fetchAuthUser().then((authUser) => {
          if (authUser) {
            self.handleShowWelcomeDialog();
          }
        });
      });
    else next();
  },
  data() {
    return {
      arrangements: [],
      welcomeDialogDisplayed: false,
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
    closeWelcomeDialog() {
      this.handleShowWelcomeDialog();
    },
    handleShowWelcomeDialog() {
      this.welcomeDialogDisplayed = !this.welcomeDialogDisplayed;
    },
    fetchArrangements() {
      this.$devour
        .findAll('arrangement', { page: this.pagy.currentPage })
        .then((res) => {
          this.arrangements.push(...res.data);
          this.pagy.currentPage += 1;
          this.pagy.isActioned = true;
        })
        .catch((err) => console.log(err));
    },
    infiniteHandler($state) {
      this.$devour
        .findAll('arrangement', { page: this.pagy.currentPage })
        .then((res) => {
          if (this.pagy.currentPage < res.meta.pagy.pages) {
            this.pagy.currentPage += 1;
            this.arrangements.push(...res.data);
            $state.loaded();
          } else {
            this.arrangements.push(...res.data);
            $state.complete();
          }
        })
        .catch((err) => console.log(err));
    },
  },
};
</script>
