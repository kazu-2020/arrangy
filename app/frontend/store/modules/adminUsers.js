import devour from '../../plugins/devour';

const state = {
  adminUser: null,
};

const getters = {
  adminUser: (state) => state.adminUser,
};

const mutations = {
  setAdminUser(state, user) {
    state.adminUser = user;
  },
};

const actions = {
  async loginAdmin({ commit }, user) {
    try {
      const userResponse = await devour.request(
        `${devour.apiUrl}/admin/auth_user`,
        'POST',
        {},
        user
      );
      commit('setAdminUser', userResponse.data);
      return userResponse.data;
    } catch (err) {
      return null;
    }
  },
  async logoutAdmin({ commit }) {
    try {
      const res = await devour.request(`${devour.apiUrl}/admin/auth_user`, 'DELETE');
      commit('setAdminUser', null);
      return res;
    } catch (err) {
      return null;
    }
  },
  async fetchAdminUser({ commit, state }) {
    if (state.adminUser) return state.adminUser;
    const userResponse = await devour.request(`${devour.apiUrl}/admin/auth_user`, 'GET');
    if (!userResponse.data) return null;
    commit('setAdminUser', userResponse.data);
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
