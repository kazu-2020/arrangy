require 'rails_helper'

RSpec.describe "パスワード編集", type: :system, js: true do
  let!(:user) { create(:user) }

  before {
    log_in_as(user)
    access_profile
    within('#myprofile') { find('a', text: 'こちら').click }
  }

  describe 'フロント側のバリデーション機能' do
    describe '必須項目の検証' do
      context '必須欄が全て未入力の場合' do
        before { within('#password-edit-form') { click_on('更新する') } }

        it 'エラーメッセージ「<ラベル名>は必須項目です」が表示される' do
          within('#password-edit-form') do
            expect(page).to have_content('パスワードは必須項目です')
            expect(page).to have_content('パスワード(確認用)は必須項目です')
          end
        end
      end
    end

    describe '文字数の検証' do
      context 'パスワードが5文字の場合' do
        before {
          within('#password-edit-form') do
            fill_in('パスワード', with: 'a' * 5)
            fill_in('パスワード(確認用)', with: 'a' * 5)
            click_on('更新する')
          end
        }

        it '文字数に関するエラーメッセージが表示される' do
          within('#password-edit-form') do
            expect(page).to have_content('パスワードは6文字以上でなければなりません')
          end
        end
      end
    end

    describe 'フォーマットの検証' do
      context 'パスワードが不適当な場合' do
        invalid_passwords = %w[ｐａｓsｗｏrd あいうえおか １２３４５６ foo..bar @//#bar foo\ bar]

        it '「パスワードのフォーマットが正しくありません」と表示される' do
          invalid_passwords.each do |invalid_password|
            within('#password-edit-form') do
              fill_in('パスワード', with: invalid_password)
              click_on('更新する')
              expect(page).to have_content('パスワードのフォーマットが正しくありません')
            end
          end
        end
      end
    end

    describe '確認用(パスワード)の検証' do
      context 'パスワード、パスワード(確認用)の入力値が異なる場合' do
        before {
          within('#password-edit-form') do
            fill_in('パスワード', with: 'a' * 10)
            fill_in('パスワード(確認用)', with: 'b' * 10)
            click_on('更新する')
          end
        }

        it '「パスワード(確認用)が一致しません」と表示される' do
          within('#password-edit-form') do
            expect(page).to have_content('パスワード(確認用)が一致しません')
          end
        end
      end
    end
  end

  context '適当な値を入力した場合' do
    before {
      within('#password-edit-form') do
        fill_in('パスワード', with: 'foobar')
        fill_in('パスワード(確認用)', with: 'foobar')
        click_on('更新する')
      end
    }

    it '「パスワードを更新しました」と表示され、編集用のダイアログは非表示になる' do
      expect(find('#global-snackbar')).to have_text('パスワードを更新しました')
      sleep 0.5
      expect(find('#password-edit-form', visible: false).visible?).to eq(false)
    end
  end

  context '「戻る」をクリックした場合' do
    before { within('#password-edit-form') { click_on('戻る')} }

    it '編集用のダイアログは非表示になる' do
      sleep 0.5
      expect(find('#password-edit-form', visible: false).visible?).to eq(false)
    end
  end

  context '「プロフィールを変更する場合はこちら」をクリックした場合' do
    before { within('#password-edit-form') { find('a', text: 'こちら').click } }

    it 'プロフィール編集用のダイアログに切り替わる' do
      expect(has_selector?('#profile-edit-form')).to eq(true)
    end
  end
end
