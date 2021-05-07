<template>
  <div>
    <v-footer fixed height="60" color="grey lighten-5">
      <v-row justify="center" noGutters>
        <v-btn text rounded :to="{ name: 'ServiceDescription' }">Arrangyとは</v-btn>
        <v-btn text rounded :to="{ name: 'TermsPage' }">利用規約</v-btn>
        <v-btn text rounded :to="{ name: 'PrivacyPolicy' }">プライバシーポリシー</v-btn>
        <v-btn text rounded :to="{ name: 'ContactPage' }">お問い合わせ</v-btn>
      </v-row>
    </v-footer>
  </div>
</template>

<script>
export default {};
</script>
