require 'rails_helper'

RSpec.describe "コメント削除", type: :system, js: true do
  let!(:comment) { create(:comment) }

  before {
    log_in_as(comment.user)
    find("#arrangement-#{comment.arrangement.id}").click
    within("#comment-#{comment.id}") { find('.comment-menu-icon').click }
  }

  context '「削除する」を押した場合' do
    before { within('.comment-menu-list') { click_on('削除する') } }

    it '削除確認用のダイアログが表示される' do
      within('#delete-confirmation') do
        expect(page).to have_content('コメントを削除する')
        expect(page).to have_button('削除する')
        expect(page).to have_button('キャンセル')
      end
    end

    context '確認用ダイアログの「削除する」をクリックした場合' do
      before { within('#delete-confirmation') { click_on '削除する' } }

      it '「コメントを削除しました」と表示され、コメントが削除される' do
        expect {
          find('#global-snackbar', text: 'コメントを削除しました')
        }.to change { Comment.count}.by(-1)
        expect(has_selector?("comment-#{comment.id}")).to eq(false)
      end

      # fit '確認用ダイアログは非表示になる' do
      #   expect(find('#delete-confirmation', visible: false).visible?).to eq(false)
      # end
    end

    context '確認用ダイアログの「キャンセル」をクリックした場合' do
      before { within('#delete-confirmation') { click_on 'キャンセル' } }

      it '確認用ダイアログは非表示になる' do
        sleep 0.5
        expect(find('#delete-confirmation', visible: false).visible?).to eq(false)
      end
    end
  end
end