require 'rails_helper'

RSpec.describe OauthForm, type: :model do
  let(:user) { build(:user) }
  let(:oauth_params) { { uid: 123456, provider: 'google' } }
  let(:oauth_form) { OauthForm.new(user: user, oauth_params: oauth_params )}

  describe 'テストデータの検証' do
    it 'テストデータは有効です' do
      expect(oauth_form).to be_valid
    end
  end

  describe '文字数の検証' do
    context 'ニックネームが31文字以上の場合' do
      invalid_nickname = SecureRandom.alphanumeric(31)
      it 'ニックネームは無効です' do
        user.nickname = invalid_nickname
        expect(oauth_form).to be_invalid
      end
    end

    context 'ニックネームが30文字以下の場合' do
      valid_nickname = SecureRandom.alphanumeric(rand(1..30))
      it 'ニックネームは有効です' do
        user.nickname = valid_nickname
        expect(oauth_form).to be_valid
      end
    end

    context 'アドレスが51文字以上の場合' do
      invalid_address = SecureRandom.alphanumeric(39) + '@example.com'
      it 'アドレスは無効です' do
        user.email = invalid_address
        expect(oauth_form).to be_invalid
      end
    end

    context 'アドレスが50文字以下の場合' do
      valid_address = SecureRandom.alphanumeric(rand(1..38)) + '@example.com'
      it 'アドレスは有効です' do
        user.email = valid_address
        expect(oauth_form).to be_valid
      end
    end
  end
end