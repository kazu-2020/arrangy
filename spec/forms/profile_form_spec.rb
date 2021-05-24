require 'rails_helper'

RSpec.describe ProfileForm, type: :model do
  let(:params) {
    {
      nickname: 'mimata',
      email: 'mimata@mimata.com',
      avatar_url: '/images/development/sample_for_photo.png'

    }
  }
  let(:profile) { ProfileForm.new(params: params) }

  describe 'テストデータの検証' do
    it 'テストデータは有効です' do
      expect(profile).to be_valid
    end
  end

  describe 'presenceの検証' do
    context 'プロフィール画像が未設定の場合' do
      it '登録に失敗する' do
        params[:avatar_url] = ''
        expect(profile).to be_invalid
      end
    end
  end

  describe '文字数の検証' do
    context 'ニックネームが31文字以上の場合' do
      invalid_nickname = SecureRandom.alphanumeric(31)
      it 'ニックネームは無効です' do
        params[:nickname] = invalid_nickname
        expect(profile).to be_invalid
      end
    end

    context 'ニックネームが30文字以下の場合' do
      valid_nickname = SecureRandom.alphanumeric(rand(1..30))
      it 'ニックネームは有効です' do
        params[:nickname] = valid_nickname
        expect(profile).to be_valid
      end
    end

    context 'アドレスが51文字以上の場合' do
      invalid_address = SecureRandom.alphanumeric(39) + '@example.com'
      it 'アドレスは無効です' do
        params[:email] = invalid_address
        expect(profile).to be_invalid
      end
    end

        context 'アドレスが50文字以下の場合' do
      valid_address = SecureRandom.alphanumeric(rand(1..38)) + '@example.com'
      it 'アドレスは有効です' do
        params[:email] = valid_address
        expect(profile).to be_valid
      end
    end
  end

  describe 'フォーマットの検証' do
    context 'アドレスが適当な場合' do
      valid_addresses = %w[profile@example.com profile@foo.COM A_US-ER@foo.bar.org foo.bar@foo.jp foo+bar@baz.com]
      it 'アドレスは有効です' do
        valid_addresses.each do |address|
          params[:email] = address
          expect(profile).to be_valid
        end
      end
    end

    context 'アドレスが不適当な場合' do
      invalid_addresses = %w[profile@example,com profile.foo.COM A_US-ER@foo. foo@bar_foo.jp foo@bar+baz.com foo@bar..com foo\ bar@baz.com]
      it 'アドレスは無効です' do
        invalid_addresses.each do |address|
          params[:email] = address
          expect(profile).to be_invalid
        end
      end
    end
  end
end