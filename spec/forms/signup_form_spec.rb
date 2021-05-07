require 'rails_helper'

RSpec.describe SignupForm, type: :model do
  let(:params) {
    { nickname: 'mimata',
      email: 'mimata@mimata.com',
      password: 'password',
      password_confirmation: 'password'
    }
  }
  let(:signup) { SignupForm.new(params) }

  describe 'テストデータの検証' do
    it 'テストデータは有効です' do
      expect(signup).to be_valid
    end
  end

  describe '文字数の検証' do
    context 'ニックネームが31文字以上の場合' do
      invalid_nickname = SecureRandom.alphanumeric(31)
      it 'ニックネームは無効です' do
        params[:nickname] = invalid_nickname
        expect(signup).to be_invalid
      end
    end

    context 'ニックネームが30文字以下の場合' do
      valid_nickname = SecureRandom.alphanumeric(rand(1..30))
      it 'ニックネームは有効です' do
        params[:nickname] = valid_nickname
        expect(signup).to be_valid
      end
    end

    context 'アドレスが51文字以上の場合' do
      invalid_address = SecureRandom.alphanumeric(39) + '@example.com'
      it 'アドレスは無効です' do
        params[:email] = invalid_address
        expect(signup).to be_invalid
      end
    end

        context 'アドレスが50文字以下の場合' do
      valid_address = SecureRandom.alphanumeric(rand(1..38)) + '@example.com'
      it 'アドレスは有効です' do
        params[:email] = valid_address
        expect(signup).to be_valid
      end
    end

    context 'パスワードが5文字以下の場合' do
      invalid_password = SecureRandom.alphanumeric(rand(1..5))
      it 'パスワードは無効です' do
        params[:password] = params[:password_confirmation] = invalid_password
        expect(signup).to be_invalid
      end
    end

    context 'パスワードが6文字以上の場合' do
      valid_password = SecureRandom.alphanumeric(6)
      it 'パスワードは有効です' do
        params[:password] = params[:password_confirmation] = valid_password
        expect(signup).to be_valid
      end
    end
  end

  describe 'フォーマットの検証' do
    context 'アドレスが適当な場合' do
      valid_addresses = %w[signup@example.com signup@foo.COM A_US-ER@foo.bar.org foo.bar@foo.jp foo+bar@baz.com]
      it 'アドレスは有効です' do
        valid_addresses.each do |address|
          params[:email] = address
          expect(signup).to be_valid
        end
      end
    end

    context 'アドレスが不適当な場合' do
      invalid_addresses = %w[signup@example,com signup.foo.COM A_US-ER@foo. foo@bar_foo.jp foo@bar+baz.com foo@bar..com foo\ bar@baz.com]
      it 'アドレスは無効です' do
        invalid_addresses.each do |address|
          params[:email] = address
          expect(signup).to be_invalid
        end
      end
    end

    context 'パスワードが適当な場合' do
      valid_passwords = %w[password fooBAR baz1234]
      it 'パスワードは有効です' do
        valid_passwords.each do |password|
          params[:password] = params[:password_confirmation] = password
          expect(signup.valid?).to eq true
        end
      end
    end

    context 'パスワードが不適当な場合' do
      invalid_passwords = %w[ｐａｓsｗｏrd パスワード １２３４５６ foo..bar @//#bar foo\ bar]
      it 'パスワードは無効です' do
        invalid_passwords.each do |password|
          params[:password] = params[:password_confirmation] = password
          expect(signup.valid?).to eq false
        end
      end
    end
  end
end