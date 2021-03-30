require 'rails_helper'

RSpec.describe "ユーザーログイン", type: :system, js: true do
  let!(:user) { create(:user, email: 'example@examle.com') }

  before { visit('/login') }

  describe 'フロント側のバリデーション機能' do
    describe '必須項目の検証' do
      context '必須欄が全て未入力の場合' do
        before { within('#login-using-address'){ click_on 'メールアドレスでログイン'} }

        it 'エラーメッセージ「<ラベル名>は必須項目です」が表示される' do
          within('#login-using-address') do
            expect(page).to have_content('メールアドレスは必須項目です')
            expect(page).to have_content('パスワードは必須項目です')
          end
        end
      end
    end

    describe '文字数の検証' do
      context 'アドレスが51文字、パスワードが5文字の場合' do
        before {
          within('#login-using-address') do
            fill_in('メールアドレス', with: 'a' * 39 + '@example.com')
            fill_in('パスワード', with: 'a' * 5)
            click_on('メールアドレスでログイン')
          end
        }

        it '文字数に関するエラーメッセージが表示される' do
          within('#login-using-address') do
            expect(page).to have_content('メールアドレスは50文字以内にしてください')
            expect(page).to have_content('パスワードは6文字以上でなければなりません')
          end
        end
      end
    end

    describe 'フォーマットの検証' do
      context 'アドレスが不適当な場合' do
        invalid_addresses = %w[user@example,com USER.foo.COM A_US-ER@foo. foo@bar_foo.jp foo@bar+baz.com foo@bar..com foo\ bar@baz.com]

        it '「有効なメールアドレスではありません」と表示される' do
          invalid_addresses.each do |invalid_address|
            within('#login-using-address') do
              fill_in('メールアドレス', with: invalid_address)
              click_on('メールアドレスでログイン')
              expect(page).to have_content('有効なメールアドレスではありません')
            end
          end
        end
      end

      context 'パスワードが不適当な場合' do
        invalid_passwords = %w[ｐａｓsｗｏrd あいうえおか １２３４５６ foo..bar @//#bar foo\ bar]

        it '「パスワードのフォーマットが正しくありません」と表示される' do
          invalid_passwords.each do |invalid_password|
            within('#login-using-address') do
              fill_in('パスワード', with: invalid_password)
              click_on('メールアドレスでログイン')
              expect(page).to have_content('パスワードのフォーマットが正しくありません')
            end
          end
        end
      end
    end
  end

  context 'ログイン情報が間違っている場合' do
    before {
      within('#login-using-address') do
        fill_in('メールアドレス', with: 'foobar@foobar.com')
        fill_in('パスワード', with: 'foobar')
        click_on('メールアドレスでログイン')
      end
    }

    it '「ログインに失敗しました」と表示される' do
      expect(find('#global-snackbar')).to have_text('ログインに失敗しました')
      expect(current_path).to eq('/login')
    end
  end

  context 'ログイン情報が正しい場合' do
    before {
      within('#login-using-address') do
        fill_in('メールアドレス', with: 'example@examle.com')
        fill_in('パスワード', with: 'password')
        click_on('メールアドレスでログイン')
      end
    }

    it 'トップページへ遷移し、「ログインしました」と表示される' do
      expect(find('#global-snackbar')).to have_text('ログインしました')
      expect(current_path).to eq('/')
    end
  end
end
