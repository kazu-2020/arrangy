require 'rails_helper'

RSpec.describe "退会機能", type: :system, js: true do
  let(:user) { create(:user)}

  before {
    log_in_as(user)
    access_profile
  }

  context '「退会する」を押した時' do
    before { click_on("退会する") }

    it '退会が完了し、トップページに遷移する' do
      expect(find('#global-snackbar')).to have_text('退会しました')
      expect(current_path).to eq('/')
    end
  end

end