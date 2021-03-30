require 'rails_helper'

RSpec.describe "ログアウト", type: :system, js: true do
  let(:user) { create(:user) }

  before {
    log_in_as(user)
    find('#header-avatar').click
  }

  it 'ヘッダーのメニューリスト内に「ログアウト」が表示されている' do
    within('#header-menu-list') { expect(page.has_button?('ログアウト')).to eq(true) }
  end

  context '「ログアウト」をクリックした時' do
    before { within('#header-menu-list') { click_on 'ログアウト'} }

    it 'ヘッダーのメニューリスト内の「ログアウト」は非表示になっている' do
      expect(page.has_no_css?('#header-avatar')).to eq(true)
    end
  end
end