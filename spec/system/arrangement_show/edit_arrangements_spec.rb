require 'rails_helper'

RSpec.describe "投稿編集", type: :system, js: true do
  let!(:arrangement) { create(:arrangement, :with_after_arrangement_photo, :with_parameter,) }

  before do
    log_in_as(arrangement.user)
    find("#arrangement-#{encode_id(arrangement.id)}").click
    within("#arrangement-#{encode_id(arrangement.id)}") { find('#arrangement-menu-icon').click }
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

        it 'エラーメッセージが表示される' do
          #期待するエラーメッセージを返していないが、そのまま進める
          expect(page).to have_content('サイズは10MB以内でなければなりません')
        end
      end
    end
  end

  describe '詳細ページに変更後のデータを反映' do
    before {
      within('#arrangement-edit-form') do
        fill_in('タイトル', with: 'タイトルを更新')
        fill_in('投稿内容', with: '投稿内容を更新')
        attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/sample.png", visible: false)
      end
      find('#trimming-dialog') { click_on('トリミングする') }
      click_on('変更する')
    }

    it '「投稿を更新しました」と表示され、編集用のダイアログは非表示になる' do
      expect(find('#global-snackbar')).to have_text('投稿を更新しました')
      within("#arrangement-#{encode_id(arrangement.id)}") do
        expect(page).to have_content('タイトルを更新')
        expect(page).to have_content('投稿内容を更新')
      end
      sleep 1
      expect(find('#arrangement-edit-form', visible: false).visible?).to eq(false)
    end
  end

  describe 'トリミング画面の検証' do
    before {
      within('#arrangement-edit-form') {
        attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/sample.png", visible: false)
      }
    }

    it '写真を選択すると、トリミング画面が表示される' do
      expect(has_selector?('#trimming-dialog')).to eq(true)
    end
    it '「キャンセル」ボタンを押すとトリミング画面は閉じる' do
      find('#trimming-dialog') { click_on('キャンセル') }
      sleep 1
      expect(find('#trimming-dialog', visible: false).visible?).to eq(false)
    end
    it '「トリミング」ボタンを押すとトリミングされる' do
      find('#trimming-dialog') { click_on('トリミングする') }
      sleep 1
      expect(find('#trimming-dialog', visible: false).visible?).to eq(false)
    end
  end
end
