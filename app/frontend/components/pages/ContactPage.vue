<template>
  <v-container>
    <v-row class="pt-5 pt-md-16 mb-3">
      <v-col>
        <div class="mb-5 text-h4 font-weight-bold">お問い合わせ</div>
      </v-col>
    </v-row>
    <v-row class="d-flex justify-center text-center">
      <v-col cols="12" md="7">
        <ValidationObserver
          id="contact-form"
          ref="contactForm"
          v-slot="{ handleSubmit }"
          tag="form"
        >
          <ValidationProvider v-slot="{ errors }" name="カテゴリー" :rules="rules.category">
            <v-combobox
              v-model="contact.category"
              class="mb-3"
              label="カテゴリー"
              :items="items"
              itemColor="#eeeeee"
              backgroundColor="#eeeeee"
              outlined
              dense
              color="black"
              :errorMessages="errors"
            />
          </ValidationProvider>
          <ValidationProvider v-slot="{ errors }" name="お問合せ内容" :rules="rules.body">
            <v-textarea
              id="contact-body"
              v-model="contact.body"
              class="mb-3"
              label="お問い合わせ内容"
              outlined
              autoGrow
              counter="1000"
              color="black"
              :errorMessages="errors"
            />
          </ValidationProvider>
          <SubmitButton :xLarge="true" :color="'#cc3918'" @submit="handleSubmit(createContactMail)">
            <template #text>送信する</template>
          </SubmitButton>
        </ValidationObserver>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions } from 'vuex';
import SubmitButton from '../parts/buttons/SubmitButton';

export default {
  components: {
    SubmitButton,
  },
  data() {
    return {
      contact: {
        category: 'バグ、不具合について',
        body: '',
      },
    };
  },
  head: {
    title() {
      return {
        inner: 'お問い合わせ',
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
    items() {
      return ['バグ、不具合について', '機能追加の提案について', 'その他の問い合わせ'];
    },
    rules() {
      return {
        category: {
          required: true,
          oneOf: ['バグ、不具合について', '機能追加の提案について', 'その他の問い合わせ'],
        },
        body: { required: true, max: 1000 },
      };
    },
    siteDescription() {
      return 'Arrangy(アレンジー)はアレンジ飯の共有サービスです。コンビニ商品や外食店の料理を使用したアレンジ飯を「知りたい」「共有したい」という方達は、是非覗いてみてください!!';
    },
  },
  methods: {
    ...mapActions('snackbars', ['fetchSnackbarData']),
    createContactMail() {
      this.$devour.request(`${this.$devour.apiUrl}/contacts`, 'POST', {}, this.contact).then(() => {
        this.fetchSnackbarData({
          msg: 'お問い合わせを確認しました',
          color: 'success',
          isShow: true,
        });
        this.contact.body = '';
        this.$refs.contactForm.reset();
      });
    },
  },
};
</script>

<style></style>
