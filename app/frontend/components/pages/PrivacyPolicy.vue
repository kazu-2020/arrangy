<template>
  <PrivacyPolicyBody />
</template>

<script>
import PrivacyPolicyBody from '../parts/base/PrivacyPolicyBody';
export default {
  components: {
    PrivacyPolicyBody,
  },
  head: {
    title() {
      return {
        inner: 'プライバシーポリシー',
        separator: '|',
        complement: 'Arrangy(アレンジー)',
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
  },
};
</script>
