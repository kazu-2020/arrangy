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
#  remember_me_token               :string
#  remember_me_token_expires_at    :datetime
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
#  index_users_on_email              (email) UNIQUE
#  index_users_on_nickname           (nickname) UNIQUE
#  index_users_on_remember_me_token  (remember_me_token)
#
class UserSerializer
  include JSONAPI::Serializer
  set_type :user
  attributes :nickname, :email, :avatar_url, :role, :likes_count, :arrangements_count

  attribute :created_at do |record|
    I18n.l(record.created_at, format: :short)
  end

  has_many :arrangements
  has_many :comments
end
