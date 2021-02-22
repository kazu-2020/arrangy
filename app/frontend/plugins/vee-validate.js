import Vue from 'vue'
import axios from './axios'
import { ValidationObserver, ValidationProvider, extend, localize, setInteractionMode } from 'vee-validate'
import ja from 'vee-validate/dist/locale/ja.json'
import { required, email, min, max, regex, confirmed } from 'vee-validate/dist/rules'

localize('ja', ja)
setInteractionMode('blur', () => { return { on: ['blur'] }});

Vue.component('ValidationProvider', ValidationProvider);
Vue.component('ValidationObserver', ValidationObserver);

extend('required', required);
extend('email', email);
extend('min', min);
extend('max', max);
extend('regex', regex);
extend('confirmed', confirmed)

extend('isUnique',
  {
    params: ['column'],
    async validate(value, { column }) {
      let response = await axios.get('validations/unique', { params: { [column]: value }})
      return response.data === "unique"
    },
    message: '{_value_}は既に使われています',
  }
);
