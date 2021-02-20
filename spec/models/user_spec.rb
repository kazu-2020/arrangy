require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'メールアドレスの検証' do
    let(:user) { build(:user) }

    context 'アドレスが適当な場合' do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org foo.bar@foo.jp foo+bar@baz.com]
      it 'フォーマットバリデーションを通過する' do
        valid_addresses.each do |address|
          user.email = address
          expect(user).to be_valid
        end
      end
    end

    context 'アドレスが不適当な場合' do
      invalid_addresses = %w[user@example,com USER.foo.COM A_US-ER@foo. foo@bar_foo.jp foo@bar+baz.com foo@bar..com foo\ bar@baz.com]
      it 'フォーマットバリデーションを通過しない' do
        invalid_addresses.each do |address|
          user.email = address
          expect(user).to be_invalid
        end
      end
    end
  end

  describe 'メールアドレスを小文字に変換して保存する' do
    let(:user) { build(:user) }
    TEST_EMAIL = "FOO@EXAMPLE.COM"
    it "小文字に変換されている" do
      user.email = TEST_EMAIL
      user.save
      expect(User.last.email).to eq TEST_EMAIL.downcase
    end
  end
end
