<template>
  <div>
    <v-container fluid class="pt-0 px-0">
      <v-row noGutters class="d-flex justify-center" style="background-color: #cc3918">
        <v-col cols="auto">
          <v-img src="/images/toppage-logo.png"> </v-img>
        </v-col>
        <v-col cols="auto">
          <v-card-text
            class="text-subtitle-1 font-weight-bold pt-10 text-md-center px-3"
            style="color: white"
          >
            コンビニ商品や外食店の料理を使用した<br class="br-sp" />アレンジ飯を共有するサービスです
          </v-card-text>
          <v-card-actions class="d-flex justify-center">
            <v-btn
              xLarge
              rounded
              outlined
              class="btn"
              style="color: white"
              :to="{ name: 'ArrangementNew' }"
            >
              <div class="font-weight-bold">早速、投稿してみる</div>
            </v-btn>
          </v-card-actions>
        </v-col>
      </v-row>
    </v-container>
    <v-container>
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
      <!-- 新規投稿者案内用ダイアログ -->
      <WelcomeDialog :dialog="welcomeDialogDisplayed" @close-dialog="closeWelcomeDialog" />
    </v-container>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import WelcomeDialog from '../parts/dialogs/WelcomeDialog';
import ArrangementSummary from '../parts/cards/ArrangementSummary';

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
  head: {
    title() {
      return {
        inner: 'Arrangy(アレンジー)',
        separator: '|',
        complement: 'コンビニ商品や外食店の料理を使用したアレンジ飯の共有サービス',
      };
    },
    meta() {
      return [
        {
          name: 'description',
          content: this.siteDescription,
        },
        {
          property: 'og:url',
          content: 'https://arrangy.jp',
        },
        {
          property: 'og:title',
          content:
            'Arrangy(アレンジー) | コンビニ商品や外食店の料理を使用したアレンジ飯の共有サービス',
        },
        {
          property: 'og:description',
          content: this.siteDescription,
        },
        {
          property: 'og:image',
          content: '/images/og-image.png',
        },
      ];
    },
  },
  computed: {
    ...mapGetters('users', ['authUser']),
    siteDescription() {
      return 'Arrangy(アレンジー)はアレンジ飯の共有サービスです。コンビニ商品や外食店の料理を使用したアレンジ飯を「知りたい」「共有したい」という方達は、是非覗いてみてください!!';
    },
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
      this.$devour.findAll('arrangement', { page: this.pagy.currentPage }).then((res) => {
        this.arrangements.push(...res.data);
        this.pagy.currentPage += 1;
        if (res.meta.pagy.pages !== 1) {
          this.pagy.isActioned = true;
        }
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

<style scoped>
.btn {
  border: 2.5px solid;
}
</style>
