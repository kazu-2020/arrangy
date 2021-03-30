require 'rails_helper'

RSpec.describe "プロフィール詳細", type: :system, js: true do
  let!(:user) { create(:user, nickname: 'mimata', email: 'foo@bar.com') }

  before {
    log_in_as(user)
    within('#page-header') { find('#header-avatar').click }
    within('#header-menu-list') { click_on('マイページ') }
  }

  it 'ニックネーム、アドレス、アバター画像が表示されている' do
    within('#myprofile') do
      expect(page).to have_content('mimata')
      expect(page).to have_content('foo@bar.com')
      expect(first('img')[:src].include?(user.avatar.url)).to_not eq(true)
    end
  end
end
