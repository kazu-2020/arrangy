import JsonApi from 'devour-client';
import { csrfToken } from 'rails-ujs';

const jsonApi = new JsonApi({
  apiUrl: '/api',
});

jsonApi.headers['X-CSRF-TOKEN'] = csrfToken();
jsonApi.headers['CONTENT-TYPE'] = 'application/json';

jsonApi.define('user', {
  nickname: '',
  email: '',
  password: '',
  password_confirmation: '',
  arrangements: {
    jsonApi: 'hasMany',
    type: 'arrangements',
  },
});

jsonApi.define('arrangement', {
  title: '',
  context: '',
  images: [],
  user: {
    jsonApi: 'hasOne',
    type: 'user',
  },
});

export default jsonApi;
