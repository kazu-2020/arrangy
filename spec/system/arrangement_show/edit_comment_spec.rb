require 'rails_helper'

RSpec.describe "コメント編集", type: :system, js: true do
  let!(:comment) { create(:comment) }

  before {
    log_in_as(comment.user)
    find("#arrangement-#{comment.arrangement.id}").click
    within("#comment-#{comment.id}") { find('.comment-menu-icon').click }
    within('.comment-menu-list') { click_on('編集する') }
  }

  it '変更前のコメントが編集フォームに表示されている' do
    within('#comment-edit-form') { expect(find('#comment-body').value).to eq(comment.body) }
  end

  describe 'フロント側のバリデーション' do
    describe '必須項目の検証' do
      context 'コメントが未入力の場合' do
        before { within('#comment-edit-form') { fill_in('コメント', with: ' ') } }

        it '「コメントする」ボタンをクリックできない' do
          within('#comment-edit-form') do
            expect(find_button('更新する', disabled: true).disabled?).to eq(true)
          end
        end
      end
    end

    describe '文字数の検証' do
      context 'コメントが1001文字の場合' do
        before { within('#comment-edit-form') { fill_in('コメント', with: 'a' * 1001) } }

        it '「コメントする」ボタンをクリックできない' do
          within('#comment-edit-form') do
            expect(find_button('更新する', disabled: true).disabled?).to eq(true)
          end
        end
      end
    end
  end

  context '適当な値を入力して、「更新する」をクリックした場合' do
    before {
      within('#comment-edit-form') do
        fill_in('コメント', with: 'コメントを更新')
        click_on('更新する')
      end
    }

    it 'コメントが更新され、「編集済み」と表示される' do
      within("#comment-#{comment.id}") do
        expect(page).to have_content('コメントを更新')
        expect(page).to have_content('(編集済み)')
      end
    end

    it '編集用のダイアログは非表示になる' do
      sleep 0.5
      expect(find('#comment-edit-form', visible: false).visible?).to eq(false)
    end
  end

  context '「キャンセル」をクリックした場合' do
    before { within('#comment-edit-form') { click_on('キャンセル') } }

    it '編集用のダイアログは非表示になる' do
      sleep 0.5
      expect(find('#comment-edit-form', visible: false).visible?).to eq(false)
    end
  end
end
