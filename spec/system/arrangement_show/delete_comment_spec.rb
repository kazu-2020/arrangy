require 'rails_helper'

RSpec.describe "コメント削除", type: :system, js: true do
  let(:arrangement) { build(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo)}
  let!(:comment) { create(:comment, arrangement: arrangement) }

  before {
    log_in_as(comment.user)
    find("#arrangement-#{encode_id(comment.arrangement.id)}").click
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
      before {
        within('#delete-confirmation') do
          click_on '削除する'
        end
      }

      it '「コメントを削除しました」と表示され、コメントが削除される' do
        find('#global-snackbar', text: 'コメントを削除しました')
        expect(page).to_not have_content(comment.body)
        expect(has_selector?("comment-#{comment.id}")).to eq(false)
      end

    end

    context '確認用ダイアログの「キャンセル」をクリックした場合' do
      before {
        within('#delete-confirmation') do
          click_on 'キャンセル'
          sleep 1
        end
      }

      it '確認用ダイアログは非表示になる' do
        expect(find('#delete-confirmation', visible: false).visible?).to eq(false)
      end
    end
  end
end