require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { build(:comment) }

  describe 'テストデータの検証' do
    it '有効です' do
      expect(comment).to be_valid
    end
  end

  describe 'presenceの検証' do
    it 'コメントが未入力の場合、無効です' do
      comment.body = ''
      expect(comment).to be_invalid
    end
  end

  describe '文字数の検証' do
    context 'コメントが1001文字以下の場合' do
      invalid_body = 'a' * 1_001
      it 'コメントは無効です' do
        comment.body = invalid_body
        expect(comment).to be_invalid
      end
    end

    context 'コメントが1000文字以下の場合' do
      valid_body = 'a' * 1_000
      it 'コメントは有効です' do
        comment.body = valid_body
        expect(comment).to be_valid
      end
    end
  end
end
