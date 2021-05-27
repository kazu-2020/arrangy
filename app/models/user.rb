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
class User < ApplicationRecord
  has_many :arrangements, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_many :comments,     dependent: :destroy
  has_many :likes, -> { order(created_at: :desc) }, inverse_of: 'user', dependent: :destroy
  has_many :liking_arrangements, through: :likes, source: :arrangement

  before_save :change_email_to_lowercase

  authenticates_with_sorcery!

  enum role: { general: 0, admin: 1 }

  attr_accessor :password, :password_confirmation

  validates :nickname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  def like(arrangement)
    liking_arrangements << arrangement
  end

  def unlike(arrangement)
    liking_arrangements.delete(arrangement)
  end

  private

  def change_email_to_lowercase
    self.email = email.downcase
  end
end
