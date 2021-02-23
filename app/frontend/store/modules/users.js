import axios from '../../plugins/axios';
import router from '../../router/index';

const state = {
  authUser: null,
};

const getters = {
  authUser: (state) => state.authUser,
};

const mutations = {
  setAuthUser(state, user) {
    state.authUser = user;
  },
};

const actions = {
  loginUser({ commit }, user) {
    axios
      .post('sessions', user)
      .then((res) => {
        commit('updateAuthUser', res.data);
        router.push({ name: 'TopPage' });
        alert('ログインに成功しました');
      })
      .catch(() => alert('ログインに失敗しました'));
  },
};

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};
