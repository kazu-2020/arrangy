require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system, js: true do
  before { visit('/register') }

  describe 'フロント側のバリーデーション機能' do
    describe '必須項目の検証' do
      context '必須欄が全て未入力の場合' do
        before { within('#register-using-address') { click_on('メールアドレスで登録') } }

        it 'エラーメッセージ「<ラベル名>は必須項目です」が表示される' do
          within('#register-using-address') do
            expect(page).to have_content('ニックネームは必須項目です')
            expect(page).to have_content('メールアドレスは必須項目です')
            expect(page).to have_content('パスワードは必須項目です')
            expect(page).to have_content('パスワード(確認用)は必須項目です')
          end
        end
      end
    end

    describe '一意性の検証' do
      context '使用されているニックネーム、アドレスを使用した場合' do
        before {
          create(:user, nickname: 'mimata', email: 'mimata@mimata.com')
          within('#register-using-address') do
            fill_in('ニックネーム', with: 'mimata')
            fill_in('メールアドレス', with: 'MIMATA@mimata.com')
            click_on('メールアドレスで登録')
          end
        }

        it 'エラーメッセージ「<value>は既に使われています」が表示される' do
          within('#register-using-address') do
            expect(page).to have_content('mimataは既に使われています')
            expect(page).to have_content('MIMATA@mimata.comは既に使われています')
          end
        end
      end
    end

    describe '文字数の検証' do
      context 'ニックネームが31文字、アドレスが51文字、パスワードが5文字の場合' do
        before {
          within('#register-using-address') do
            fill_in('ニックネーム', with: 'a' * 31)
            fill_in('メールアドレス', with: 'a' * 39 + '@example.com')
            fill_in('パスワード', with: 'a' * 5)
            fill_in('パスワード(確認用)', with: 'a' * 5)
            click_on('メールアドレスで登録')
          end
        }

        it '文字数に関するエラーメッセージが表示される' do
          within('#register-using-address') do
            expect(page).to have_content('ニックネームは30文字以内にしてください')
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
            within('#register-using-address') do
              fill_in('メールアドレス', with: invalid_address)
              click_on('メールアドレスで登録')
              expect(page).to have_content('有効なメールアドレスではありません')
            end
          end
        end
      end

      context 'パスワードが不適当な場合' do
        invalid_passwords = %w[ｐａｓsｗｏrd あいうえおか １２３４５６ foo..bar @//#bar foo\ bar]

        it '「パスワードのフォーマットが正しくありません」と表示される' do
          invalid_passwords.each do |invalid_password|
            within('#register-using-address') do
              fill_in('パスワード', with: invalid_password)
              click_on('メールアドレスで登録')
              expect(page).to have_content('パスワードのフォーマットが正しくありません')
            end
          end
        end
      end
    end

    describe '確認用(パスワード)の検証' do
      context 'パスワード、パスワード(確認用)の入力値が異なる場合' do
        before do
          within('#register-using-address') do
            fill_in('パスワード', with: 'a' * 10)
            fill_in('パスワード(確認用)', with: 'b' * 10)
            click_on('メールアドレスで登録')
          end
        end

        it '「パスワード(確認用)が一致しません」と表示される' do
          within('#register-using-address') do
            expect(page).to have_content('パスワード(確認用)が一致しません')
          end
        end
      end
    end
  end

  context '適当な値を入力している場合' do
    before {
      within('#register-using-address') do
        fill_in 'ニックネーム', with: 'mimata'
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード(確認用)', with: 'password'
      end
    }

    it '新規登録後に「投稿ページへ」ボタンが表示され、クリックすると投稿ページへ遷移する' do
      expect {
        click_on 'メールアドレスで登録'
        find('#welcome-dialog')
      }.to change { User.count }.by(1)
      within '#welcome-dialog' do
        expect(current_path).to eq '/'
        expect(page).to have_link '投稿ページへ', href: '/arrangements/new'
        click_on '投稿ページへ'
      end
      expect(current_path).to eq '/arrangements/new'
    end
    it '新規登録後に「あとで」ボタンが表示され、クリックするとダイアログが閉じる' do
      click_on 'メールアドレスで登録'
      within '#welcome-dialog' do
        expect(page).to have_button 'あとで'
        click_on 'あとで'
      end
      sleep 0.5
      expect(find('#welcome-dialog', visible: false).visible?).to eq false
    end
  end
end
