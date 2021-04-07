require 'rails_helper'

RSpec.describe "プロフィール詳細", type: :system, js: true do
  let!(:user) { create(:user, nickname: 'mimata', email: 'foo@bar.com') }

  context 'ログイン前' do
    context 'プロフィールページにアクセスした場合' do
      before { visit('/profile') }

      it 'ログイン画面に遷移する' do
        expect(page).to have_content('ログイン')
        expect(current_path).to eq('/login')
      end
    end
  end

  context 'ログイン後' do
    before {
      log_in_as(user)
      access_profile
    }

    it 'ニックネーム、アドレス、アバター画像が表示されている' do
      within('#myprofile') do
        expect(page).to have_content('mimata')
        expect(page).to have_content('foo@bar.com')
        expect(find('.v-image__image')[:style].include?(user.avatar.url)).to eq(true)
      end
    end
  end
end
