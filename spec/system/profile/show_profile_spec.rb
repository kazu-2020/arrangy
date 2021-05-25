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
      end
    end

    it '投稿数、うまいいね数が表示されている' do
      within('#myprofile') do
        expect(page).to have_content('投稿数')
        expect(page).to have_content(user.likes_count)
        expect(page).to have_content('投稿数')
        expect(page).to have_content(user.arrangements_count)
      end
    end
  end
end
