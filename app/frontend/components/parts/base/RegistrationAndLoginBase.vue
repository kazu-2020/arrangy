<template>
  <v-container>
    <v-row class="mb-10">
      <v-col class="pt-10">
        <div class="text-h4 mb-4 font-weight-black">
          <slot name="main1-title" />
        </div>
        <div class="text-body-1 font-weight-medium">
          <slot name="main1-context" />
        </div>
      </v-col>
    </v-row>

    <v-row class="pb-5">
      <v-col cols="12" sm="5" md="5" lg="5" xl="5">
        <v-card>
          <div class="text-h6 pt-8 px-8 text-center font-weight-black">
            <slot name="main2-title" />
          </div>
          <slot name="main2-context" />
        </v-card>
      </v-col>

      <v-col class="d-flex justify-center align-center" cols="12" sm="2" md="2" lg="2" xl="2">
        <p>または</p>
      </v-col>

      <v-col cols="12" sm="5" md="5" lg="5" xl="5">
        <v-card height="100%">
          <div class="text-h6 pt-8 px-8 mb-4 text-center font-weight-black">
            <slot name="main3-title" />
          </div>
          <v-card-actions class="d-flex flex-column">
            <slot name="main3-context" />
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {};
</script>
