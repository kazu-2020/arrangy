require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'テストデータの検証' do
    it 'テストデータは有効です' do
      expect(user).to be_valid
    end
  end

  describe 'presenceの検証' do
    it 'ニックネームが未入力場合、無効です' do
      user.nickname = ''
      expect(user).to be_invalid
    end
    it 'アドレスが未入力の場合、無効です' do
      user.email = ''
      expect(user).to be_invalid
    end
    it 'パスワードが未入力の場合、無効です' do
      user.password = ''
      expect(user).to be_invalid
    end
  end

  describe '一意性の検証' do
    let(:created_user) { create(:user, email: 'foo@bar.com') }
    it 'ニックネームは既に値が使用されている場合、無効です' do
      user.nickname = created_user.nickname
      expect(user).to be_invalid
    end
    it 'アドレスは既に値が使用されている場合、無効です' do
      user.email = created_user.email
      expect(user).to be_invalid
    end

    it 'アドレスは大文字、小文字を区別しない' do
      user.email = created_user.email.upcase
      expect(user).to be_invalid
    end
  end

  describe '文字数の検証' do
    context 'ニックネームが31文字以上の場合' do
      invalid_nickname = SecureRandom.alphanumeric(31)
      it 'ニックネームは無効です' do
        user.nickname = invalid_nickname
        expect(user).to be_invalid
      end
    end

    context 'ニックネームが30文字以下の場合' do
      valid_nickname = SecureRandom.alphanumeric(rand(1..30))
      it 'ニックネームは有効です' do
        user.nickname = valid_nickname
        expect(user).to be_valid
      end
    end

    context 'アドレスが51文字以上の場合' do
      invalid_address = SecureRandom.alphanumeric(39) + '@example.com'
      it 'アドレスは無効です' do
        user.email = invalid_address
        expect(user).to be_invalid
      end
    end

    context 'アドレスが50文字以下の場合' do
      valid_address = SecureRandom.alphanumeric(rand(1..38)) + '@example.com'
      it 'アドレスは有効です' do
        user.email = valid_address
        expect(user).to be_valid
      end
    end

    context 'パスワードが5文字以下の場合' do
      invalid_password = SecureRandom.alphanumeric(rand(1..5))
      it 'パスワードは無効です' do
        user.password = invalid_password
        user.password_confirmation = invalid_password
        expect(user).to be_invalid
      end
    end

    context 'パスワードが6文字以上の場合' do
      valid_password = SecureRandom.alphanumeric(6)
      it 'パスワードは有効です' do
        user.password = valid_password
        user.password_confirmation = valid_password
        expect(user).to be_valid
      end
    end
  end

  describe 'フォーマットの検証' do
    context 'アドレスが適当な場合' do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org foo.bar@foo.jp foo+bar@baz.com]
      it 'アドレスは有効です' do
        valid_addresses.each do |address|
          user.email = address
          expect(user).to be_valid
        end
      end
    end

    context 'アドレスが不適当な場合' do
      invalid_addresses = %w[user@example,com USER.foo.COM A_US-ER@foo. foo@bar_foo.jp foo@bar+baz.com foo@bar..com foo\ bar@baz.com]
      it 'アドレスは無効です' do
        invalid_addresses.each do |address|
          user.email = address
          expect(user).to be_invalid
        end
      end
    end

    context 'パスワードが適当な場合' do
      valid_passwords = %w[password fooBAR baz1234]
      it 'パスワードは有効です' do
        valid_passwords.each do |password|
          user.password = password
          user.password_confirmation = password
          expect(user.valid?).to eq true
        end
      end
    end

    context 'パスワードが不適当な場合' do
      invalid_passwords = %w[ｐａｓsｗｏrd パスワード １２３４５６ foo..bar @//#bar foo\ bar]
      it 'パスワードは無効です' do
        invalid_passwords.each do |password|
          user.password = password
          user.password_confirmation = password
          expect(user.valid?).to eq false
        end
      end
    end
  end

  describe 'メールアドレスを小文字に変換して保存する' do
    test_email = "FOO@EXAMPLE.COM"
    it "小文字に変換されている" do
      user.email = test_email
      user.save
      expect(User.last.email).to eq test_email.downcase
    end
  end
end
