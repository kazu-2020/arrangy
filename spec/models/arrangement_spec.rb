require 'rails_helper'

RSpec.describe Arrangement, type: :model do
  let(:arrangement) { build(:arrangement) }

  describe 'テストデータの検証' do
    it '有効です' do
      expect(arrangement).to be_valid
    end
  end

  describe 'presenceの検証' do
    it 'タイトルが未入力の場合、無効です' do
      arrangement.title = ''
      expect(arrangement).to be_invalid
    end
    it '投稿内容が未入力の場合、無効です' do
      arrangement.context = ''
      expect(arrangement).to be_invalid
    end
    it '投稿画像が未設定の場合、無効です' do
      arrangement.images = []
      expect(arrangement).to be_invalid
    end
  end

  describe '文字数の検証' do
    context 'タイトルが31文字以上の場合' do
      invalid_title = 'a' * 31
      it 'タイトルは無効です' do
        arrangement.title = invalid_title
        expect(arrangement).to be_invalid
      end
    end

    context 'タイトルが30文字以下の場合' do
      valid_title = 'a' * 30
      it 'タイトルは有効です' do
        arrangement.title = valid_title
        expect(arrangement).to be_valid
      end
    end

    context '投稿内容が1001文字以上の場合' do
      invalid_context = 'a' * 1_001
      it '投稿内容は無効です' do
        arrangement.context = invalid_context
        expect(arrangement).to be_invalid
      end
    end

    context '投稿内容が1000文字以下の場合' do
      valid_context = 'a' * 1_000
      it '投稿内容は有効です' do
        arrangement.context = valid_context
        expect(arrangement).to be_valid
      end
    end
  end
end
