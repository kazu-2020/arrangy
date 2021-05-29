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
import {
  required,
  email,
  min,
  max,
  regex,
  confirmed,
  ext,
  size,
  oneOf,
  max_value,
  min_value,
} from 'vee-validate/dist/rules';

localize('ja', ja);

setInteractionMode('blur', () => {
  return { on: ['blur'] };
});
setInteractionMode('change', () => {
  return { on: ['change'] };
});
setInteractionMode('input', () => {
  return { on: ['input'] };
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
extend('oneOf', oneOf);
extend('max_value', max_value);
extend('min_value', min_value);
extend('ext', {
  ...ext,
  message: '有効なファイル形式はではありません',
});
extend('size', {
  ...size,
  message: 'サイズは10MB以内でなければなりません',
});
extend('isUnique', {
  params: ['column', 'user_id'],
  async validate(value, { column, user_id }) {
    const res = await devour.request(`${devour.apiUrl}/validation/uniqueness`, 'GET', {
      [column]: value,
      id: user_id,
    });
    if (res.meta === 'unique') {
      return true;
    } else {
      return '{_value_}は既に使われています';
    }
  },
});
