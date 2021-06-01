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
      <v-row v-if="pagy.pageCounts > 1">
        <v-col cols="12">
          <v-pagination
            id="top-pagination"
            v-model="pagy.currentPage"
            :length="pagy.pageCounts"
            circle
            color="#cc3918"
          />
        </v-col>
      </v-row>

      <v-row class="pb-10">
        <v-col v-for="(arrangement, $index) in arrangements" :key="$index" cols="12" sm="4" md="4">
          <ArrangementSummary
            :arrangement="arrangement"
            :twitterShareUrl="twitterShareUrl(arrangement.id)"
            :raitingLarge="true"
          >
            <template slot="user-information">
              <v-card-text>
                <v-row>
                  <v-col cols="auto">
                    <v-avatar size="25">
                      <v-img
                        :id="`arrangement-avatar${arrangement.id}`"
                        :src="arrangement.user.avatar_url"
                      />
                    </v-avatar>
                  </v-col>
                  <v-col cols="10" md="9">
                    <div class="text-subtitle-1 font-weight-black text-truncate">
                      {{ arrangement.user.nickname }}
                    </div>
                  </v-col>
                </v-row>
              </v-card-text>
            </template>
          </ArrangementSummary>
        </v-col>
      </v-row>

      <v-row v-if="pagy.pageCounts > 1">
        <v-col cols="12">
          <v-pagination
            id="bottom-pagination"
            v-model="pagy.currentPage"
            :length="pagy.pageCounts"
            circle
            color="#cc3918"
          />
        </v-col>
      </v-row>

      <!-- 新規投稿者案内用ダイアログ -->
      <WelcomeDialog :dialog="welcomeDialogDisplayed" @close-dialog="closeWelcomeDialog" />
    </v-container>
  </div>
</template>

<script>
import devour from '../../plugins/devour';
import store from '../../store/index';

import ArrangementSummary from '../parts/cards/ArrangementSummary';
import WelcomeDialog from '../parts/dialogs/WelcomeDialog';

export default {
  components: {
    ArrangementSummary,
    WelcomeDialog,
  },
  beforeRouteEnter(to, from, next) {
    const query = new URLSearchParams(location.search);
    const page = query.has('page') ? Number(query.get('page')) : 1;

    devour.findAll('arrangement', { page: page }).then((res) => {
      next((self) => {
        self.arrangements = res.data;
        self.pagy.currentPage = res.meta.pagy.page;
        self.pagy.pageCounts = res.meta.pagy.pages;
      });
    });
    store.dispatch('users/fetchAuthUser');
  },
  data() {
    return {
      arrangements: [],
      welcomeDialogDisplayed: false,
      pagy: {
        pageCounts: 1,
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
          id: 'og-url',
        },
        {
          property: 'og:title',
          content:
            'Arrangy(アレンジー) | コンビニ商品や外食店の料理を使用したアレンジ飯の共有サービス',
          id: 'og-title',
        },
        {
          property: 'og:description',
          content: this.siteDescription,
          id: 'og-description',
        },
        {
          property: 'og:image',
          content: 'https://arrangy.jp/images/og-image.png',
          id: 'og-image',
        },
      ];
    },
  },
  computed: {
    siteDescription() {
      return 'Arrangy(アレンジー)はアレンジ飯の共有サービスです。コンビニ商品や外食店の料理を使用したアレンジ飯を「知りたい」「共有したい」という方達は、是非覗いてみてください!!';
    },
    twitterShareUrl() {
      return function (id) {
        const url = `https://arrangy.jp/arrangements/${id}`;
        return `https://twitter.com/share?text=こちらは人気のアレンジ飯です。皆さんも実際に作って食べてみてください。%0a他のアレンジ飯が気になる方は是非、Arrangy(アレンジー)にお越し下さい。&url=${url}&hashtags=Arrangy,アレンジ飯`;
      };
    },
  },
  watch: {
    'pagy.currentPage': function (newValue) {
      const url = new URL(location);
      url.searchParams.set('page', newValue);
      window.history.pushState({}, '', url);
      this.fetchArrangements(newValue);
    },
  },
  created() {
    if (location.search.includes('registration=true')) {
      this.handleShowWelcomeDialog();
    }
  },
  updated() {
    const position = sessionStorage.getItem('position');
    if (position) {
      this.$nextTick(() => {
        window.scrollTo(0, position);
        sessionStorage.removeItem('position');
      });
    }
  },
  methods: {
    closeWelcomeDialog() {
      this.handleShowWelcomeDialog();
    },
    handleShowWelcomeDialog() {
      this.welcomeDialogDisplayed = !this.welcomeDialogDisplayed;
    },
    fetchArrangements(page) {
      this.$devour.findAll('arrangement', { page: page }).then((res) => {
        this.arrangements = res.data;
        this.pagy.currentPage = res.meta.pagy.page;
        this.pagy.pageCounts = res.meta.pagy.pages;
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
