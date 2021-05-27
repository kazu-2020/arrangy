# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  arrangements_count              :bigint           default(0)
#  avatar_url                      :string           default("/images/default_avatar.png")
#  crypted_password                :string
#  email                           :string           not null
#  likes_count                     :bigint           default(0)
#  nickname                        :string           not null
#  reset_password_email_sent_at    :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  role                            :integer          default("general")
#  salt                            :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_nickname  (nickname) UNIQUE
#
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

  describe 'メールアドレスを小文字に変換して保存する' do
    test_email = "FOO@EXAMPLE.COM"
    it "小文字に変換されている" do
      user.email = test_email
      user.save
      expect(User.last.email).to eq test_email.downcase
    end
  end
end
