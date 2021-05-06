require 'rails_helper'

RSpec.describe UpdatePasswordForm, type: :model do
  let(:params) { { password: 'password', password_confirmation: 'password' }}
  let(:password_form) { UpdatePasswordForm.new(params: params) }

  describe 'テストデータの検証' do
    it 'テストデータは有効です' do
      expect(password_form).to be_valid
    end
  end

  describe '文字数の検証' do
    context 'パスワードが5文字以下の場合' do
      invalid_password = SecureRandom.alphanumeric(rand(1..5))
      it 'パスワードは無効です' do
        params[:password] = params[:password_confirmation] = invalid_password
        expect(password_form).to be_invalid
      end
    end

    context 'パスワードが6文字以上の場合' do
      valid_password = SecureRandom.alphanumeric(6)
      it 'パスワードは有効です' do
        params[:password] = params[:password_confirmation] = valid_password
        expect(password_form).to be_valid
      end
    end
  end

  describe 'フォーマットの検証' do
    context 'パスワードが適当な場合' do
      valid_passwords = %w[password fooBAR baz1234]
      it 'パスワードは有効です' do
        valid_passwords.each do |password|
          params[:password] = params[:password_confirmation] = password
          expect(password_form).to be_valid
        end
      end
    end

    context 'パスワードが不適当な場合' do
      invalid_passwords = %w[ｐａｓsｗｏrd パスワード １２３４５６ foo..bar @//#bar foo\ bar]
      it 'パスワードは無効です' do
        invalid_passwords.each do |password|
          params[:password] = params[:password_confirmation] = password
          expect(password_form).to be_invalid
        end
      end
    end
  end
end