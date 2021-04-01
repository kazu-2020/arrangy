require 'rails_helper'

RSpec.describe "投稿削除", type: :system, js: true do
  let!(:arrangement) { create(:arrangement) }

  before {
    log_in_as(arrangement.user)
    find("#arrangement-#{arrangement.id}").click
    within("#arrangement-#{arrangement.id}") { find('#arrangement-menu-icon').click }
  }

  context '「削除する」を押した場合' do
    before { within('#arrangement-menu-list') { click_on('削除する') } }

    it '削除確認用のダイアログが表示される' do
      within('#delete-confirmation') do
        expect(page).to have_content('投稿を削除する')
        expect(page).to have_button('削除する')
        expect(page).to have_button('キャンセル')
      end
    end

    context '確認用ダイアログの「削除する」をクリックした場合' do
      before { within('#delete-confirmation') { click_on '削除する' } }

      fit '「投稿を削除しました」と表示され、プロフィールページへ遷移する' do
        expect {
          find('#global-snackbar', text: '投稿を削除しました')
        }.to change {Arrangement.count}.by(-1)
        expect(current_path).to eq('/profile')
      end
    end
  end
end
