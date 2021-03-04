const state = {
  data: { msg: '', color: '', isShow: false },
};

const getters = {
  snackbarData: (state) => state.data,
};

const mutations = {
  setData(state, data) {
    state.data = { msg: data.msg, color: data.color, isShow: data.isShow };
  },
};

const actions = {
  fetchSnackbarData({ commit }, data) {
    commit('setData', data);
  },
};

export default {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};
