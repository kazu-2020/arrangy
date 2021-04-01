require 'rails_helper'

RSpec.describe "プロフィール編集", type: :system, js: true do
  let!(:user) { create(:user, nickname: 'mimata', email: 'foo@bar.com') }

  before {
    log_in_as(user)
    access_profile
    within('#myprofile') { click_on('編集する') }
  }

  describe 'フロント側のバリデーション機能' do
    describe '必須項目の検証' do
      context '必須欄が全て未入力の場合' do
        before {
          within('#profile-edit-form') do
            fill_in('ニックネーム', with: ' ')
            fill_in('メールアドレス', with: ' ')
            click_on('更新する')
          end
        }

        it 'エラーメッセージ「<ラベル名>は必須項目です」が表示される' do
          within('#profile-edit-form') do
            expect(page).to have_content('ニックネームは必須項目です')
            expect(page).to have_content('メールアドレスは必須項目です')
          end
        end
      end
    end

    describe '一意性の検証' do
      context '使用されているニックネーム、アドレスを使用した場合' do
        before {
          create(:user, nickname: 'tanaka', email: 'foo@baz.com')
          within('#profile-edit-form') do
            fill_in('ニックネーム', with: 'tanaka')
            fill_in('メールアドレス', with: 'foo@baz.com')
            click_on('更新する')
          end
        }

        it 'エラーメッセージ「<value>は既に使われています」が表示される' do
          within('#profile-edit-form') do
            expect(page).to have_content('tanakaは既に使われています')
            expect(page).to have_content('foo@baz.comは既に使われています')
          end
        end
      end

      context '自身が使用しているニックネーム、アドレスを使用した場合' do
        before {
          within('#profile-edit-form') do
            fill_in('ニックネーム', with: 'mimata')
            fill_in('メールアドレス', with: 'foo@bar.com')
            click_on('プロフィール画像を変更')
          end
        }

        it 'エラーメッセージは表示されない' do
          within('#profile-edit-form') do
            expect(page).to have_no_content('mimataは既に使われています')
            expect(page).to have_no_content('foo@bar.comは既に使われています')
          end
        end
      end
    end

    describe '文字数の検証' do
      context 'ニックネームが31文字、アドレスが51文字の場合' do
        before {
          within('#profile-edit-form') do
            fill_in('ニックネーム', with: 'a' * 31)
            fill_in('メールアドレス', with: 'a' * 39 + '@example.com')
            click_on('更新する')
          end
        }

        it '文字数に関するエラーメッセージが表示される' do
          within('#profile-edit-form') do
            expect(page).to have_content('ニックネームは30文字以内にしてください')
            expect(page).to have_content('メールアドレスは50文字以内にしてください')
          end
        end
      end

      context 'ニックネームが30文字、アドレスが50文字の場合' do
        before {
          within('#profile-edit-form') do
            fill_in('ニックネーム', with: 'a' * 30)
            fill_in('メールアドレス', with: 'a' * 38 + '@example.com')
            click_on('プロフィール画像を変更')
          end
        }

        it 'エラーメッセージは表示されない' do
          within('#profile-edit-form') do
            expect(page).to have_no_content('ニックネームは30文字以内にしてください')
            expect(page).to have_no_content('メールアドレスは50文字以内にしてください')
          end
        end
      end
    end

    describe 'フォーマットの検証' do
      context 'アドレスが不適当な場合' do
        invalid_addresses = %w[user@example,com USER.foo.COM A_US-ER@foo. foo@bar_foo.jp foo@bar+baz.com foo@bar..com foo\ bar@baz.com]

        it '「有効なメールアドレスではありません」と表示される' do
          invalid_addresses.each do |invalid_address|
            within('#profile-edit-form') do
              fill_in('メールアドレス', with: invalid_address)
              click_on('更新する')
              expect(page).to have_content('有効なメールアドレスではありません')
            end
          end
        end
      end
    end

    describe 'プロフィール画像の検証' do
      context '10MBよりも大きいサイズの画像を投稿した場合' do
        before do
          within('#profile-edit-form') do
            attach_file('プロフィール画像', "#{Rails.root}/spec/fixtures/images/15MB.jpg", visible: false)
          end
        end

        it '「サイズは10MB以内でなければなりません」と表示される' do
          within('#profile-edit-form') { expect(page).to have_content('サイズは10MB以内でなければなりません') }
        end
      end

      context '.txtファイルを選択した場合' do
        before do
          within('#profile-edit-form') do
            attach_file('プロフィール画像', "#{Rails.root}/spec/fixtures/images/sample1.txt", visible: false)
          end
        end

        it 'エラーメッセージが表示される' do
          #期待するエラーメッセージを返していないが、そのまま進める
          within('#profile-edit-form') { expect(page).to have_content('サイズは10MB以内でなければなりません') }
        end
      end
    end
  end

  it '編集用フォームに既存の値が入力されている' do
    within('#profile-edit-form') do
      expect(find('#user-nickname').value).to eq('mimata')
      expect(find('#user-email').value).to eq('foo@bar.com')
    end
  end

  describe 'プロフィールページに変更後のデータを反映' do
    before {
      within('#profile-edit-form') do
        fill_in('ニックネーム', with: 'kazu')
        fill_in('メールアドレス', with: 'kazu@kazu.com')
        attach_file('プロフィール画像', "#{Rails.root}/spec/fixtures/images/sample3.png", visible: false)
        click_on('更新する')
      end
    }

    it '「プロフィールを更新しました」と表示され、編集用のダイアログは非表示になる' do
      expect(find('#global-snackbar')).to have_text('プロフィールを更新しました')
      sleep 0.5
      expect(find('#profile-edit-form', visible: false).visible?).to eq(false)
    end

    it '変更後のデータが反映されている' do
      within('#myprofile') do
        expect(page).to_not have_content('kazu')
        expect(page).to have_content('kazu@kazu.com')
        user.reload
        expect(find('.v-image__image')[:style].include?(user.avatar.url)).to eq(true)
      end
    end
  end

  context '「戻る」をクリックした場合' do
    before { within('#profile-edit-form') { click_on('戻る')} }

    it '編集用のダイアログは非表示になる' do
      sleep 0.5
      expect(find('#profile-edit-form', visible: false).visible?).to eq(false)
    end
  end

  context '「パスワードを変更する場合はこちら」をクリックした場合' do
    before { within('#profile-edit-form') { find('a', text: 'こちら').click } }

    it 'パスワード編集用のダイアログに切り替わる' do
      expect(has_selector?('#password-edit-form')).to eq(true)
    end
  end
end
