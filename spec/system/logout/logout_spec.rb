require 'rails_helper'

RSpec.describe "UserLogouts", type: :system, js: true do
  let(:user) { create(:user) }

  before do
    log_in_as(user)
    find('#header-avatar').click
  end

  it 'ヘッダーのメニューリスト内に「ログアウト」が表示されている' do
    within('#header-menu-list') do
      expect(page).to have_content('ログアウト')
      expect(page.has_css?('#header-logout-button')).to eq(true)
    end
  end

  context '「ログアウト」をクリックした時' do
    before { within('#header-menu-list') { find('#header-logout-button').click } }

    it 'ヘッダーのメニューリスト内の「ログアウト」は非表示になっている' do
      expect(page).to have_no_content('ログアウト')
      expect(page.has_no_css?('#header-logout-button')).to eq(true)
    end
  end
end