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
  comments: {
    jsonApi: 'hasMany',
    type: 'comments',
  },
});

jsonApi.define('arrangement', {
  id: '',
  title: '',
  context: '',
  images: '',
  created_at: '',
  liked_authuser: '',
  likes_count: '',
  comments_count: '',
  user: {
    jsonApi: 'hasOne',
    type: 'user',
  },
  comments: {
    jsonApi: 'hasMany',
    type: 'comments',
  },
});

jsonApi.define('comment', {
  id: '',
  body: '',
  edited: '',
  created_at: '',
  user: {
    jsonApi: 'hasOne',
    type: 'user',
  },
  arrangement: {
    jsonApi: 'hasOne',
    type: 'arrangement',
  },
});

jsonApi.define('like', {
  id: '',
  arrangement_id: '',
  user_id: '',
  user: {
    jsonApi: 'hasOne',
    type: 'user',
  },
  arrangement: {
    jsonApi: 'hasOne',
    type: 'arrangement',
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
