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
      find('#global-snackbar', text: 'ログインしました')
      within('#page-header') { find('#navigation-icon').click }
      within('#navigation-menu') { click_on('新規投稿') }
    }

    context '適当な値を入力した場合' do
      before {
        within('#arrangement-new-form') do
          fill_in('タイトル', with: 'a' * 30)
          fill_in('投稿内容', with: 'a' * 1_000)
          attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/sample.png", visible: false)
        end
        find('#trimming-dialog') { click_on('トリミングする') }
      }

      it '投稿詳細ページへ遷移し、「新しいアレンジ飯を投稿しました」と表示される。' do
        expect {
          within('#arrangement-new-form') { click_on('アレンジ飯を投稿する') }
          find('#global-snackbar', text: '新しいアレンジ飯を投稿しました')
        }.to change { Arrangement.count }.by(1)
        expect(current_path).to eq("/arrangements/#{encode_id(Arrangement.last.id)}")
      end
    end

    describe 'トリミング画面の検証' do
      before {
        within('#arrangement-new-form') {
          attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/sample.png", visible: false)
        }
      }

      it '写真を選択すると、トリミング画面が表示される' do
        expect(has_selector?('#trimming-dialog')).to eq(true)
      end
      it '「キャンセル」ボタンを押すとトリミング画面は閉じる' do
        find('#trimming-dialog') { click_on('キャンセル') }
        sleep 0.5
        expect(find('#trimming-dialog', visible: false).visible?).to eq(false)
      end
    end


    describe 'フロント側のバリデーション機能' do
      describe '必須項目の検証' do
        context '必須欄が未入力の場合' do
          before {
            within('#arrangement-new-form') do
              fill_in('タイトル', with: ' ')
              fill_in('投稿内容', with: ' ')
            end
          }

          it 'エラーメッセージ「<ラベル名>は必須項目です」が表示される' do
            within('#arrangement-new-form') do
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
          before { within('#arrangement-new-form') { attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/15MB.jpg", visible: false) } }

          it '画像は投稿されない' do
            within('#arrangement-new-form') do
              expect(has_selector?('#preview-image')).to eq(false)
              expect(has_button?('写真を選択')).to eq(true)
              expect(page).to have_content('サイズは10MB以内でなければなりません')
            end
          end
        end

        context '.txtファイルを選択した場合' do
          before { within('#arrangement-new-form') { attach_file('投稿写真', "#{Rails.root}/spec/fixtures/images/sample1.txt", visible: false) } }

          it '画像は投稿されない' do
            within('#arrangement-new-form') do
              expect(has_selector?('#preview-image')).to eq(false)
              expect(has_button?('写真を選択')).to eq(true)
            end
          end
        end
      end
    end
  end
end
