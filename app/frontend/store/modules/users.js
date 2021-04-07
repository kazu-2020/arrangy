import devour from '../../plugins/devour';

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
  async registerUser({ commit }, user) {
    try {
      const userResponse = await devour.create('user', user);
      commit('setAuthUser', userResponse.data);
      return userResponse.data;
    } catch (err) {
      console.log(err);
      return null;
    }
  },
  async loginUser({ commit }, user) {
    try {
      const userResponse = await devour.request(`${devour.apiUrl}/auth_user`, 'POST', {}, user);
      commit('setAuthUser', userResponse.data);
      return userResponse.data;
    } catch (err) {
      console.log(err);
      return null;
    }
  },
  async logoutUser({ commit }) {
    try {
      const res = await devour.request(`${devour.apiUrl}/auth_user`, 'DELETE');
      commit('setAuthUser', null);
      return res;
    } catch (err) {
      console.log(err);
      return null;
    }
  },
  async updateAuthUser({ commit }, user) {
    try {
      const userResponse = await devour.request(
        `${devour.apiUrl}/auth_user`,
        'PATCH',
        {},
        { user: user }
      );
      commit('setAuthUser', userResponse.data);
      return userResponse.data;
    } catch (err) {
      console.log(err);
      return null;
    }
  },
  async fetchAuthUser({ commit, state }) {
    if (state.authUser) return state.authUser;
    const userResponse = await devour.request(`${devour.apiUrl}/auth_user`, 'GET');
    if (!userResponse.data) return null;
    commit('setAuthUser', userResponse.data);
    return userResponse.data;
  },
};

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};
