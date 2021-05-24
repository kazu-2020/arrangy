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
  avatar_url: '',
  role: '',
  password: '',
  password_confirmation: '',
  arrangements_count: '',
  likes_count: '',
  created_at: '',
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
  parameter: {
    jsonApi: 'hasOne',
    type: 'parameter',
  },
  after_arrangement_photo: {
    jsonApi: 'hasOne',
    type: 'after_arrangement_photo',
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

jsonApi.define('parameter', {
  id: '',
  arrangement_id: '',
  taste: '',
  spiciness: '',
  sweetness: '',
  satisfaction: '',
  arrangement: {
    jsonApi: 'hasOne',
    type: 'arrangement',
  },
});

jsonApi.define('after_arrangement_photo', {
  id: '',
  url: '',
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
  }
  // s3へアップロードした際のurlを取得
  if (res.headers['content-type'] === 'application/xml') {
    res.data.match(/<Location>(.+)<\/Location>/);
    if (RegExp.$1) {
      res.data = { meta: { url: RegExp.$1 } };
    } else {
      return res;
    }
  }
  store.dispatch('responseState/fetchResponseState', { status: res.status, state: 'success' });
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
