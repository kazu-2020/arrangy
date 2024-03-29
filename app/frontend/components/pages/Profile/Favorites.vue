<template>
  <v-container v-if="isCreated">
    <v-row v-if="pagy.pageCounts > 1">
      <v-col cols="12">
        <v-pagination
          id="top-pagination"
          v-model="pagy.currentPage"
          circle
          color="#cc3918"
          :length="pagy.pageCounts"
        />
      </v-col>
    </v-row>

    <v-row v-if="arrangements.length">
      <v-col v-for="(arrangement, $index) in arrangements" :key="$index" cols="12" sm="4">
        <ArrangementSummary
          :arrangement="arrangement"
          :twitterShareUrl="twitterShareUrl(arrangement)"
        >
          <template slot="user-information">
            <v-card-text>
              <v-row>
                <v-col cols="auto">
                  <v-avatar size="25">
                    <v-img :src="arrangement.user.avatar_url" />
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
    </v-row>
    <v-row v-else>
      <v-col cols="12" class="font-weight-bold text-center">
        現在、お気に入りのアレンジ飯はありません。
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
  </v-container>
</template>

<script>
import ArrangementSummary from '../../parts/cards/ArrangementSummary';

export default {
  components: {
    ArrangementSummary,
  },
  data() {
    return {
      arrangements: [],
      pagy: {
        currentPage: 1,
        pageCounts: 1,
      },
      isCreated: false,
    };
  },
  computed: {
    twitterShareUrl() {
      return function (arrangement) {
        const url = `https://arrangy.jp/arrangements/${arrangement.id}`;
        return `https://twitter.com/share?text=今回、紹介するアレンジ飯は「${arrangement.title}」です。皆さんも実際に作って食べてみてください。%0a他のアレンジ飯が気になる方は是非、Arrangy(アレンジー)にお越し下さい。&url=${url}&hashtags=Arrangy,アレンジ飯`;
      };
    },
  },
  watch: {
    'pagy.currentPage': function (newValue) {
      this.fetchArrangements(newValue);
    },
  },
  created() {
    this.fetchArrangements();
  },
  methods: {
    fetchArrangements(page) {
      this.$devour
        .request(`${this.$devour.apiUrl}/arrangements/favorites`, 'GET', {
          page: page,
        })
        .then((res) => {
          this.arrangements = res.data;
          this.isCreated = true;
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
