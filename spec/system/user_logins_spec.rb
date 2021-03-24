require 'rails_helper'

RSpec.describe "ユーザーログイン", type: :system, js: true do
  let(:user) { create(:user, email: 'example@examle.com') }

  before do
    user
    visit '/login'
  end

  describe 'フロント側のバリデーション機能' do
    describe '必須項目の検証' do
      context '必須欄が全て未入力の場合' do
        before { click_on 'メールアドレスでログイン' }
        it 'エラーメッセージ「<ラベル名>は必須項目です」が表示される' do
          aggregate_failures do
            expect(page).to have_content 'メールアドレスは必須項目です'
            expect(page).to have_content 'パスワードは必須項目です'
          end
        end
      end
    end

    describe '文字数の検証' do
      context 'アドレスが51文字、パスワードが5文字の場合' do
        before do
          fill_in 'メールアドレス', with: 'a' * 39 + '@example.com'
          fill_in 'パスワード', with: 'a' * 5
          click_on 'メールアドレスでログイン'
        end
        it '文字数に関するエラーメッセージが表示される' do
          aggregate_failures do
            expect(page).to have_content 'メールアドレスは50文字以内にしてください'
            expect(page).to have_content 'パスワードは6文字以上でなければなりません'
          end
        end
      end
    end

    describe 'フォーマットの検証' do
      context 'アドレスが不適当な場合' do
        invalid_addresses = %w[user@example,com USER.foo.COM A_US-ER@foo. foo@bar_foo.jp foo@bar+baz.com foo@bar..com foo\ bar@baz.com]
        it '「有効なメールアドレスではありません」と表示される' do
          invalid_addresses.each do |invalid_address|
            fill_in 'メールアドレス', with: invalid_address
            click_on 'メールアドレスでログイン'
            expect(page).to have_content '有効なメールアドレスではありません'
          end
        end
      end

      context 'パスワードが不適当な場合' do
        invalid_passwords = %w[ｐａｓsｗｏrd あいうえおか １２３４５６ foo..bar @//#bar foo\ bar]
        it '「パスワードのフォーマットが正しくありません」と表示される' do
          invalid_passwords.each do |invalid_password|
            fill_in 'パスワード', with: invalid_password
            click_on 'メールアドレスでログイン'
            expect(page).to have_content 'パスワードのフォーマットが正しくありません'
          end
        end
      end
    end
  end

  context 'ログイン情報が間違っている場合' do
    before do
      fill_in 'メールアドレス', with: 'foobar@foobar.com'
      fill_in 'パスワード', with: 'foobar'
      click_on 'メールアドレスでログイン'
    end
    it '「ログインに失敗しました」と表示される' do
      within '#global-snackbar' do
        expect(page).to have_content 'ログインに失敗しました'
      end
      expect(current_path).to eq '/login'
    end
  end

  context 'ログイン情報が正しい場合' do
    before do
      fill_in 'メールアドレス', with: 'example@examle.com'
      fill_in 'パスワード', with: 'password'
      click_on 'メールアドレスでログイン'
    end
    it 'トップページへ遷移し、「ログインしました」と表示される' do
      within '#global-snackbar' do
        expect(page).to have_content 'ログインしました'
      end
      expect(current_path).to eq '/'
    end
    it 'ヘッダーのログインボタンが非表示になっている' do
      sleep 0.5
      expect(page).to have_no_link 'ログイン'
    end
  end

  describe 'ログインページへの導線確認' do
    context 'ヘッダーの「ログイン」をクリックした時' do
      before do
        click_on 'ログイン'
      end
      it 'ログインページへ遷移する' do
        expect(current_path).to eq '/login'
      end
    end

    context '新規登録ページにある「既にアカウントをお持ちの方はこちらから。」をクリックした時' do
      before {
        visit '/register'
        click_on 'こちら'
      }
      it 'ログインページへ遷移する' do
        expect(current_path).to eq '/login'
      end
    end
  end
end
