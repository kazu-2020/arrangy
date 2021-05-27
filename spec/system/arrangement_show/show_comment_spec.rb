require 'rails_helper'

RSpec.describe "コメント詳細", type: :system, js: true do
  let(:arrangement) { build(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo, :with_parameter) }
  let!(:self_comment) { create(:comment, :set_user, body: 'これはテストです', nickname: 'mimata', arrangement: arrangement) }
  let!(:nonself_comment) { create(:comment, arrangement: self_comment.arrangement) }

  context '投稿詳細ページへアクセスした時' do
    before {
      visit('/')
      find("#arrangement-#{encode_id(self_comment.arrangement.id)}").click
    }

    it '自分のコメントが表示されている' do
      within("#comment-#{self_comment.id}") do
        expect(page).to have_content('これはテストです')
        expect(page).to have_content('mimata')
        expect(page).to have_content('今')
      end
    end
  end

  describe 'メニューリスト表示' do
    context 'ログインしていない場合' do
      before {
        visit('/')
        find("#arrangement-#{encode_id(self_comment.arrangement.id)}").click
      }

      it 'メニューリストは表示されない' do
        within("#comment-#{self_comment.id}") do
          expect(has_selector?('.comment-menu-icon', visible: false)).to eq(false)
        end
      end
    end

    context 'ログインしている場合' do
      before {
        log_in_as(self_comment.user)
        find("#arrangement-#{encode_id(self_comment.arrangement.id)}").click
      }

      it '自分のコメントにはメニューリストが表示されている' do
        within("#comment-#{self_comment.id}") do
          expect(has_selector?('.comment-menu-icon', visible: false)).to eq(true)
        end
      end

      it '他人のコメントにはメニューリストが表示されない' do
        within("#comment-#{nonself_comment.id}") do
          expect(has_selector?('.comment-menu-icon', visible: false)).to eq(false)
        end
      end
    end
  end
end