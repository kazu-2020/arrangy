import JsonApi from 'devour-client';
import store from '../store/index';
import { csrfToken } from 'rails-ujs';

const jsonApi = new JsonApi({
  apiUrl: '/api',
  fll: 'bar',
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
  name: 'payload-formating',
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

jsonApi.axios.interceptors.response.use(function (res) {
  if (document.querySelector('meta[name="csrf-token"]')) {
    document.querySelector('meta[name="csrf-token"]').content = res.headers['x-csrf-token'];
    store.dispatch('responseState/fetchResponseState', { status: res.status, state: 'success' });
  }
  return res;
});

const errorMiddleware = {
  name: 'error-handling',
  error: (payload) => {
    console.log(payload.response.data);
    store.dispatch('responseState/fetchResponseState', {
      status: payload.response.status,
      state: 'error',
    });
  },
};

jsonApi.insertMiddlewareBefore('axios-request', requestMiddleware);
jsonApi.replaceMiddleware('errors', errorMiddleware);

export default jsonApi;
