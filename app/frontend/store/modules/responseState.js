const state = {
  responseState: { status: '', state: '' },
};

const getters = {
  responseState: (state) => state.responseState,
};

const mutations = {
  setState(state, responseState) {
    state.responseState = { status: responseState.status, state: responseState.state };
  },
};

const actions = {
  fetchResponseState({ commit }, responseState) {
    commit('setState', responseState);
  },
};

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};
