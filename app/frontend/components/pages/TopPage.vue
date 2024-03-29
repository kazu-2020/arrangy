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

    <v-container fluid class="pt-0 px-0" style="background-color: #fafafa">
      <v-row>
        <v-col cols="12">
          <swiper v-if="newArrangements.length" ref="mySwiper" :options="swiperOptions">
            <swiper-slide
              v-for="(arrangement, $index) in newArrangements"
              :key="$index"
              class="pb-2"
              style="position: relative"
            >
              <v-hover v-slot="{ hover }">
                <v-card
                  :to="{ name: 'ArrangementShow', params: { id: arrangement.id } }"
                  :class="{ 'on-hover': hover }"
                  :elevation="hover ? 8 : 2"
                  color="#fafafa"
                >
                  <div style="position: relative">
                    <img
                      :src="arrangement.after_arrangement_photo.url"
                      height="100%"
                      width="100%"
                    />

                    <template v-if="arrangement.arrange_level === 1">
                      <v-avatar
                        color="red"
                        class="font-weight-bold"
                        style="position: absolute; top: 0; left: 0; color: #ffef02"
                        size="52"
                      >
                        激変
                      </v-avatar>
                    </template>
                    <template v-else>
                      <v-avatar
                        color="#009FE8"
                        class="font-weight-bold"
                        style="position: absolute; top: 0; left: 0; color: #ffef02"
                        size="52"
                      >
                        <span>ちょい足し</span>
                      </v-avatar>
                    </template>

                    <img
                      :src="arrangement.before_arrangement_photo.url"
                      width="25%"
                      style="position: absolute; bottom: 5px; right: 0"
                    />
                  </div>

                  <v-card-title class="d-flex justify-end pa-0">
                    <v-rating
                      dense
                      small
                      color="orange"
                      readonly
                      backgroundColor="orange ligh"
                      :length="5"
                      :value="arrangement.rating"
                    />
                  </v-card-title>

                  <v-card-title
                    class="pt-0 font-weight-bold text-truncate d-inline-block"
                    style="width: 80%"
                  >
                    {{ arrangement.title }}
                  </v-card-title>
                </v-card>
              </v-hover>
            </swiper-slide>
            <div slot="button-prev" class="swiper-button-prev swiper-navigation" />
            <div slot="button-next" class="swiper-button-next swiper-navigation" />
          </swiper>
        </v-col>
      </v-row>
      <v-row class="d-flex justify-center pb-5">
        <v-col
          cols="auto"
          class="text-center text-subtitle-1 font-weight-bold"
          style="background-color: #cc3918; color: white; border-radius: 30px"
        >
          新しく投稿されたアレンジ飯を<br class="br-sp" />確認してみよう！
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
            :twitterShareUrl="twitterShareUrl(arrangement)"
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
            circle
            color="#cc3918"
            :length="pagy.pageCounts"
            @input="scrollToTop"
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

    Promise.all([
      devour.findAll('arrangement', { page: page }),
      devour.request(`${devour.apiUrl}/arrangements/new_postings`),
    ]).then((resolve) => {
      next((self) => {
        self.arrangements = resolve[0].data;
        self.pagy.currentPage = resolve[0].meta.pagy.page;
        self.pagy.pageCounts = resolve[0].meta.pagy.pages;
        self.newArrangements = resolve[1].data;
      });
    });
    store.dispatch('users/fetchAuthUser');
  },
  data() {
    return {
      arrangements: [],
      newArrangements: [],
      welcomeDialogDisplayed: false,
      pagy: {
        pageCounts: 1,
        currentPage: 1,
        isActioned: false,
      },
      swiperOptions: {
        loop: true,
        centeredSlides: true,
        autoplay: {
          delay: 2500,
          disableOnInteraction: false,
        },
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev',
        },
        breakpoints: {
          320: {
            slidesPerView: 2,
            spaceBetween: 20,
          },
          650: {
            slidesPerView: 3,
            spaceBetween: 20,
          },
          960: {
            slidesPerView: 5,
            spaceBetween: 20,
          },
        },
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
      return function (arrangement) {
        const url = `https://arrangy.jp/arrangements/${arrangement.id}`;
        return `https://twitter.com/share?text=今回、紹介するアレンジ飯は「${arrangement.title}」です。皆さんも実際に作って食べてみてください。%0a他のアレンジ飯が気になる方は是非、Arrangy(アレンジー)にお越し下さい。&url=${url}&hashtags=Arrangy,アレンジ飯`;
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
      this.welcomeDialogDisplayed = true;
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
      this.welcomeDialogDisplayed = false;
    },
    fetchArrangements(page) {
      this.$devour.findAll('arrangement', { page: page }).then((res) => {
        this.arrangements = res.data;
        this.pagy.currentPage = res.meta.pagy.page;
        this.pagy.pageCounts = res.meta.pagy.pages;
      });
    },
    scrollToTop() {
      const element = document.querySelector('#top-pagination');
      element.scrollIntoView({ behavior: 'auto', block: 'center', inline: 'nearest' });
    },
  },
};
</script>

<style scoped>
.btn {
  border: 2.5px solid;
}
.swiper-navigation {
  color: #cc3918;
  background-color: rgb(238, 238, 238, 0.8);
  border-radius: 100%;
  width: 50px;
  height: 50px;
}
</style>
