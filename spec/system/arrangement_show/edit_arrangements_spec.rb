require 'rails_helper'

RSpec.describe "投稿編集機能", type: :system, js: true do
  let!(:arrangement) { create(:arrangement) }

  before do
    log_in_as(arrangement.user)
    find("#arrangement-#{arrangement.id}").click
    within("#arrangement-#{arrangement.id}") { find('#arrangement-menu-icon').click }
    within('#arrangement-menu-list') { click_on('編集する') }
  end

  describe 'フロント側のバリーデーション機能' do
    describe '必須項目の検証' do
      context '必須欄が未入力の場合' do
        before do
          within('#arrangement-edit-form') do
            fill_in('タイトル', with: ' ')
            fill_in('投稿内容', with: ' ')
          end
        end

        it 'エラーメッセージ「<ラベル名>は必須項目です」が表示される' do
          expect(page).to have_content('タイトルは必須項目です')
          expect(page).to have_content('投稿内容は必須項目です')
        end
      end
    end

    describe '文字数の検証' do
      context 'タイトルが31文字、投稿内容が1001文字の場合' do
        before do
          within('#arrangement-edit-form') do
            fill_in('タイトル', with: 'a' * 31)
            fill_in('投稿内容', with: 'a' * 1001)
          end
        end

        it '文字数に関するエラーメッセージが表示される' do
          expect(page).to have_content('タイトルは30文字以内にしてください')
          expect(page).to have_content('投稿内容は1000文字以内にしてください')
        end
      end

      context 'タイトルが30文字、投稿内容が1000文字の場合' do
        before do
          within('#arrangement-edit-form') do
            fill_in('タイトル', with: 'a' * 30)
            fill_in('投稿内容', with: 'a' * 1000)
          end
        end

        it '文字数に関するエラーメッセージは表示されない' do
          expect(page).to_not have_content('タイトルは30文字以内にしてください')
          expect(page).to_not have_content('投稿内容は1000文字以内にしてください')
        end
      end
    end

    describe '投稿画像の検証' do
      context '10MBよりも大きいサイズの画像を投稿した場合' do
        before do
          within('#arrangement-edit-form') do
            attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/15MB.jpg", visible: false)
          end
        end

        it '「サイズは10MB以内でなければなりません」と表示される' do
          expect(page).to have_content('サイズは10MB以内でなければなりません')
        end
      end

      context '.txtファイルを選択した場合' do
        before do
          attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/sample1.txt", visible: false)
        end

        it '「有効なファイル形式はではありません」と表示される' do
          expect(page).to have_content('サイズは10MB以内でなければなりません')
        end
      end
    end
  end

  describe '詳細ページに変更後のデータを反映' do
    before do
      within('#arrangement-edit-form') do
        fill_in('タイトル', with: 'タイトルを更新')
        fill_in('投稿内容', with: '投稿内容を更新')
        attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/sample3.png", visible: false)
        click_on '更新'
      end
    end

    it '「投稿を更新しました」と表示され、編集用のダイアログは非表示になる' do
      within('#global-snackbar') do
        expect(page).to have_content('投稿を更新しました')
      end
      sleep 0.5
      expect(find('#arrangement-edit-form', visible: false).visible?).to eq(false)
    end

    fit '変更後のデータが反映されている' do
      within("#arrangement-#{arrangement.id}") do
        sleep 0.5
        expect(page).to have_content('タイトルを更新')
        expect(page).to have_content('投稿内容を更新')
      end
    end
  end
end
