require 'rails_helper'

RSpec.describe ArrangementForm, type: :model do
  let(:arrangement_params) {
    {
      title: 'テスト投稿タイトル',
      context: 'テスト投稿内容',
      rating: '3'
    }
  }
  let(:after_arrangement_photo_params) { { url: '/images/development/sample_for_photo.png' } }
  let(:before_arrangement_photo_params) { { url: '/images/development/sample_for_photo.png' } }
  let(:arrangement) { create(:user).arrangements.build  }
  let(:arrangement_form) {
    ArrangementForm.new(arrangement: arrangement,
                        arrangement_params: arrangement_params,
                        after_arrangement_photo_params: after_arrangement_photo_params,
                        before_arrangement_photo_params: before_arrangement_photo_params,
                       )
  }

  describe 'テストデータの検証' do
    it 'テストデータは有効です' do
      expect(arrangement_form).to be_valid
    end
  end

  describe '最小値の検証' do
    it '評価(rating)が1の場合、有効です' do
      arrangement_params[:rating] = 1
      expect(arrangement_form).to be_valid
    end
    it '評価(rating)が0の場合、無効です' do
      arrangement_params[:rating] = 0
      expect(arrangement_form).to be_invalid
    end
  end

  describe '最大値の検証' do
    it '評価(rating)が5の場合、有効です' do
      arrangement_params[:rating] = 5
      expect(arrangement_form).to be_valid
    end
    it '評価(rating)が6の場合、無効です' do
      arrangement_params[:rating] = 6
      expect(arrangement_form).to be_invalid
    end
  end

  describe '文字数の検証' do
    context 'タイトルが31文字以上の場合' do
      invalid_title = 'a' * 31
      it 'タイトルは無効です' do
        arrangement_params[:title] = invalid_title
        expect(arrangement_form).to be_invalid
      end
    end

    context 'タイトルが30文字以下の場合' do
      valid_title = 'a' * 30
      it 'タイトルは有効です' do
        arrangement_params[:title] = valid_title
        expect(arrangement_form).to be_valid
      end
    end

    context '投稿内容が1001文字以上の場合' do
      invalid_context = 'a' * 1_001
      it '投稿内容は無効です' do
        arrangement_params[:context] = invalid_context
        expect(arrangement_form).to be_invalid
      end
    end

    context '投稿内容が1000文字以下の場合' do
      valid_context = 'a' * 1_000
      it '投稿内容は有効です' do
        arrangement_params[:context] = valid_context
        expect(arrangement_form).to be_valid
      end
    end
  end
end