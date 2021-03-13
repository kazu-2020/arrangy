import Vue from 'vue';
import devour from './devour';
import {
  ValidationObserver,
  ValidationProvider,
  extend,
  localize,
  setInteractionMode,
} from 'vee-validate';
import ja from 'vee-validate/dist/locale/ja.json';
import { required, email, min, max, regex, confirmed, ext, size } from 'vee-validate/dist/rules';

localize('ja', ja);

setInteractionMode('blur', () => {
  return { on: ['blur'] };
});
setInteractionMode('change', () => {
  return { on: ['change'] };
});

Vue.component('ValidationProvider', ValidationProvider);
Vue.component('ValidationObserver', ValidationObserver);

extend('required', required);
extend('email', {
  ...email,
  message: '有効なメールアドレスではありません',
});
extend('min', min);
extend('max', max);
extend('regex', regex);
extend('confirmed', confirmed);
extend('ext', {
  ...ext,
  message: '有効なファイル形式はではありません',
});
extend('size', {
  ...size,
  message: '10MB以内でなければなりません',
});
extend('isUnique', {
  params: ['column', 'user_id'],
  async validate(value, { column, user_id }) {
    const res = await devour.request(`${devour.apiUrl}/validations/unique`, 'GET', {
      [column]: value,
      id: user_id,
    });
    if (res.data === 'unique') {
      return true;
    } else {
      return '{_value_}は既に使われています';
    }
  },
});
