import JsonApi from 'devour-client';
import { csrfToken } from 'rails-ujs';

const jsonApi = new JsonApi({
  apiUrl: '/api',
});

jsonApi.headers['X-CSRF-TOKEN'] = csrfToken();
jsonApi.headers['CONTENT-TYPE'] = 'application/json';

jsonApi.define('user', {
  id: '',
  nickname: '',
  email: '',
  avatar: '',
  password: '',
  password_confirmation: '',
  arrangements: {
    jsonApi: 'hasMany',
    type: 'arrangements',
  },
});

jsonApi.define('arrangement', {
  id: '',
  title: '',
  context: '',
  images: [],
  user: {
    jsonApi: 'hasOne',
    type: 'user',
  },
});

const requestMiddleware = {
  req: (payload) => {
    if (['POST', 'PATCH'].includes(payload.req.method)) {
      // devourのcreate,updateメソッドを使う場合
      if (payload.req.model) {
        const data = payload.req.data.data.attributes;
        payload.req.data = { ...data };
      } else {
        // requestメソッドを使う場合
        const data = payload.req.data.data;
        payload.req.data = data;
      }
    }
    return payload;
  },
};

jsonApi.insertMiddlewareBefore('axios-request', requestMiddleware);

export default jsonApi;
