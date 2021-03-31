require 'rails_helper'

RSpec.describe "投稿作成", type: :system, js: true do
  let(:user) { create(:user) }

  context 'ログインせずに新規投稿ページへアクセスした場合' do
    before { visit('/arrangements/new') }

    it 'ログインページへ遷移する' do
      expect(page).to have_content('ログイン')
      expect(current_path).to eq('/login')
    end
  end

  context 'ログインしている場合' do
    before {
      log_in_as(user)
      within('#page-header') { click_on('新規投稿') }
    }

    context '適当な値を入力した場合' do
      before {
        within('#arrangement-new-form') do
          attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/sample2.png", visible: false)
          fill_in('タイトル', with: 'a' * 30)
          fill_in('投稿内容', with: 'a' * 1_000)
        end
      }

      it '投稿詳細ページへ遷移し、「新しいアレンジ飯を投稿しました」と表示される。' do
        expect {
          click_on('投稿する')
          find('#global-snackbar', text: '新しいアレンジ飯を投稿しました')
        }.to change { Arrangement.count }.by(1)
        expect(current_path).to eq("/arrangements/#{Arrangement.last.id}")
      end
    end

    describe 'フロント側のバリデーション機能' do
      describe '必須項目の検証' do
        context '必須欄が未入力の場合' do
          before { within('#arrangement-new-form') { click_on('投稿する') } }

          it 'エラーメッセージ「<ラベル名>は必須項目です」が表示される' do
            within('#arrangement-new-form') do
              expect(page).to have_content('投稿写真は必須項目です')
              expect(page).to have_content('タイトルは必須項目です')
              expect(page).to have_content('投稿内容は必須項目です')
            end
          end
        end
      end

      describe '文字数の検証' do
        context 'タイトルが31文字、投稿内容が1001文字の場合' do
          before do
            within('#arrangement-new-form') do
              fill_in('タイトル', with: 'a' * 31)
              fill_in('投稿内容', with: 'a' * 1_001)
              click_on('投稿する')
            end
          end

          it '文字数に関するエラーメッセージが表示される' do
            within('#arrangement-new-form') do
              expect(page).to have_content('タイトルは30文字以内にしてください')
              expect(page).to have_content('投稿内容は1000文字以内にしてください')
            end
          end
        end
      end

      describe '投稿画像の検証' do
        context '10MBよりも大きいサイズの画像を投稿した場合' do
          before do
            within('#arrangement-new-form') do
              attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/15MB.jpg", visible: false)
              click_on('投稿する')
            end
          end

          it '「サイズは10MB以内でなければなりません」と表示される' do
            within('#arrangement-new-form') { expect(page).to have_content('サイズは10MB以内でなければなりません') }
          end
        end

        context '.txtファイルを選択した場合' do
          before do
            within('#arrangement-new-form') do
              attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/sample1.txt", visible: false)
              click_on('投稿する')
            end
          end

          it '「有効なファイル形式はではありません」と表示される' do
            within('#arrangement-new-form') { expect(page).to have_content('有効なファイル形式はではありません') }
          end
        end
      end
    end
  end
end
