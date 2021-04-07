<template>
  <v-row v-if="isCreated">
    <template v-if="arrangements.length">
      <v-col v-for="(arrangement, $index) in arrangements" :key="$index" cols="12" sm="4">
        <ArrangementSummary :arrangement="arrangement">
          <template slot="user-information">
            <v-card-text>
              <v-row>
                <v-col cols="auto">
                  <v-avatar size="25">
                    <v-img :src="arrangement.user.avatar" />
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
        @infinite="infinitieHandler"
      >
        <div slot="no-more" />
        <div slot="no-results" />
      </infinite-loading>
    </template>
    <template v-else>
      <div class="mx-auto">現在、お気に入りのアレンジ飯はありません</div>
    </template>
  </v-row>
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
        isActioned: false,
      },
      isCreated: false,
    };
  },
  created() {
    this.fetchArrangements();
  },
  methods: {
    fetchArrangements() {
      this.$devour
        .request(`${this.$devour.apiUrl}/arrangements/favorites`, 'GET', {
          page: this.pagy.currentPage,
        })
        .then((res) => {
          this.arrangements.push(...res.data);
          this.isCreated = true;
          this.pagy.currentPage += 1;
          if (res.meta.pagy.pages !== 1) {
            this.pagy.isActioned = true;
          }
        })
        .catch((err) => console.log(err));
    },
    infinitieHandler($state) {
      this.$devour
        .request(`${this.$devour.apiUrl}/arrangements/favorites`, 'GET', {
          page: this.pagy.currentPage,
        })
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
