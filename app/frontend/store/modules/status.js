const state = {
  status: null,
};

const getters = {
  responseStatus: (state) => state.status,
};

const mutations = {
  setStatus(state, status) {
    state.status = status;
  },
};

const actions = {
  fetchResponseStatus({ commit }, status) {
    commit('setStatus', status);
  },
};

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};
