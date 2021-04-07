<template>
  <v-dialog :value="isShow" width="650px" @click:outside="closeDialog">
    <v-sheet id="password-edit-form" class="pa-10">
      <ValidationObserver ref="form" v-slot="{ handleSubmit }" class="pb-6" tag="form">
        <PasswordField
          :password="password"
          :rules="rules.password"
          @input="$emit('update:password', $event)"
        />
        <PasswordConfirmationField
          :password="password_confirmation"
          :rules="rules.confirmation"
          @input="$emit('update:password_confirmation', $event)"
        />
        <div class="d-flex justify-center">
          <SubmitButton
            class="mx-2"
            :xLarge="true"
            :color="'#ff5252'"
            @submit="handleSubmit(handleUpdatePassword)"
          >
            <template #text> 更新する </template>
          </SubmitButton>
          <NormalButton class="m-2" :xLarge="true" @click="closeDialog">
            <template #text>戻る</template>
          </NormalButton>
        </div>
      </ValidationObserver>
      <p class="text-body2 text-center">
        プロフィールを変更する場合は
        <a @click="changeDialog"> こちら </a>
      </p>
    </v-sheet>
  </v-dialog>
</template>

<script>
import PasswordField from '../formInputs/PasswordField';
import PasswordConfirmationField from '../formInputs/PasswordConfirmationField';
import SubmitButton from '../buttons/SubmitButton';
import NormalButton from '../buttons/NormalButton';

export default {
  components: {
    PasswordField,
    PasswordConfirmationField,
    SubmitButton,
    NormalButton,
  },
  props: {
    password: {
      type: String,
      required: true,
    },
    // eslint-disable-next-line vue/prop-name-casing
    password_confirmation: {
      type: String,
      required: true,
    },
    isShow: {
      type: Boolean,
    },
  },
  computed: {
    rules() {
      return {
        password: { required: true, min: 6, regex: /^[0-9a-zA-Z]+$/i },
        confirmation: { required: true, confirmed: 'password' },
      };
    },
  },
  methods: {
    handleUpdatePassword() {
      this.$refs.form.reset();
      this.$emit('updatePassword');
    },
    changeDialog() {
      this.$refs.form.reset();
      this.$emit('changeDialog');
    },
    closeDialog() {
      this.$refs.form.reset();
      this.$emit('closeDialog');
    },
  },
};
</script>
