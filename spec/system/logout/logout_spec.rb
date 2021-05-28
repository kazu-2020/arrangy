require 'rails_helper'

RSpec.describe "ログアウト", type: :system, js: true do
  let(:user) { create(:user) }

  before {
    log_in_as(user)
    sleep 1
  }

  context '「ログアウト」をクリックした時' do
    before {
      within('#page-header') do
        find('#navigation-icon').click
      end
      within('#navigation-menu') do
        click_on 'ログアウト'
      end
    }

    it 'ログアウトする' do
      find('#global-snackbar', text: 'ログアウトしました')
      within('#navigation-menu') do
        expect(has_button?('ログアウト')).to eq(false)
      end
    end
  end
end