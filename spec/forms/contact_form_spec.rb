require 'rails_helper'

RSpec.describe Arrangement, type: :model do
  let(:contact_form) { build(:contact_form) }

  describe 'テストデータの検証' do
    it '有効です' do
      expect(contact_form).to be_valid
    end
  end

  describe 'presenceの検証' do
    it 'カテゴリーが未入力の場合、無効です' do
      contact_form.category = ''
      expect(contact_form).to be_invalid
    end
    it '問い合わせ内容が未入力の場合、無効です' do
      contact_form.body = ''
      expect(contact_form).to be_invalid
    end
  end

  describe '文字数の検証' do
    context '問い合わせ内容が1001文字以上の場合' do
      invalid_body = 'a' * 1_001

      it '問い合わせ内容は無効です' do
        contact_form.body = invalid_body
        expect(contact_form).to be_invalid
      end
    end

    context '問い合わせ内容が1000文字以上の場合' do
      valid_body = 'a' * 1_000

      it '問い合わせ内容は有効です' do
        contact_form.body = valid_body
        expect(contact_form).to be_valid
      end
    end
  end

  describe 'カテゴリーの検証' do
    context 'カテゴリーが適当な場合' do
      valid_categories = %w[バグ、不具合について 機能追加の提案について その他の問い合わせ]

      it 'カテゴリーは有効です' do
        valid_categories.each do |category|
          contact_form.category = category
          expect(contact_form).to be_valid
        end
      end
    end

    context 'カテゴリーが不適当な場合' do
      invalid_categories = %w[バグ、不具合について!! 機能追加の提案について?? その他の問い合わせだよ]

      it 'カテゴリーは無効です' do
        invalid_categories.each do |category|
          contact_form.category = category
          expect(contact_form).to be_invalid
        end
      end
    end
  end
end