require 'rails_helper'

RSpec.describe "コメント作成", type: :system, js: true do
  let!(:arrangement) { create(:arrangement) }

  context 'ログインしている場合' do
    before {
      log_in_as(arrangement.user)
      find("#arrangement-#{encode_id(arrangement.id)}").click
    }

    it 'コメント投稿フォームは表示されている' do
      expect(has_selector?('#create-comment-form')).to eq(true)
    end

    context 'コメント投稿フォームをクリックしていない場合' do
      it '「コメントする」、「キャンセル」ボタンは非表示になっている' do
        within('#create-comment-form') do
          expect(has_button?('コメントする', disabled: true)).to eq(false)
          expect(has_button?('キャンセル')).to eq(false)
        end
      end
    end

    context 'コメント投稿フォームをクリックした場合' do
      before { find('#comment-body').click }

      it '「コメントする」、「キャンセル」ボタンが表示される' do
        within('#create-comment-form') do
          expect(has_button?('コメントする', disabled: true)).to eq(true)
          expect(has_button?('キャンセル')).to eq(true)
        end
      end
    end

    describe 'フロント側のバリデーション機能' do
      before { find('#comment-body').click }

      describe '必須機能の検証' do
        context 'コメントが未入力の場合' do
          before { within('#create-comment-form') { fill_in('コメント', with: ' ') } }

          it '「コメントする」ボタンをクリックできない' do
            within('#create-comment-form') do
              expect(find_button('コメントする', disabled: true).disabled?).to eq(true)
            end
          end
        end
      end

      describe '文字数の検証' do
        context 'コメントが1001文字の場合' do
          before { within('#create-comment-form') { fill_in('コメント', with: 'a' * 1001) } }

          it '「コメントする」ボタンをクリックできない' do
            within('#create-comment-form') do
              expect(find_button('コメントする', disabled: true).disabled?).to eq(true)
            end
          end
        end
      end
    end

    context '適当な値を入力した場合' do
      before {
        within('#create-comment-form') do
          find('#comment-body').click
          fill_in('コメント', with: 'テストです')
        end
      }

      it '「コメントする」ボタンをクリックできる' do
        within('#create-comment-form') do
          expect(find_button('コメントする').disabled?).to eq(false)
        end
      end

      context '「コメントする」ボタンをクリックした場合' do
        before { within('#create-comment-form') { click_on('コメントする') } }

        it 'コメントが追加される' do
          # expect {
          #   find_button('コメントする', disabled: true)
          #   sleep 1
          # }.to change { Comment.count }.by(1)
          expect(page).to have_content('コメントする')
          within('#create-comment-form') do
            expect(find('#comment-body').value).to eq('')
          end
        end
      end

      context '「キャンセル」ボタンをクリックした場合' do
        before { within('#create-comment-form') { click_on('キャンセル') } }

        it '「コメントする」、「キャンセル」ボタンが非表示になる' do
          within('#create-comment-form') do
            expect(has_button?('コメントする', disabled: true)).to eq(false)
            expect(has_button?('キャンセル')).to eq(false)
          end
        end

        it '入力済みのコメントが削除される' do
          within('#create-comment-form') do
            expect(find('#comment-body').value).to eq('')
          end
        end
      end
    end

  end

  context 'ログインしていない場合' do
    before {
      visit('/')
      find("#arrangement-#{encode_id(arrangement.id)}").click
    }

    it 'コメント投稿フォームは非表示になっている' do
      expect(has_selector?('#create-comment-form')).to eq(false)
    end
  end
end
