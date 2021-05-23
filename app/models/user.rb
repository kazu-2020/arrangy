# table information
# table name users
#
# id                               bigint       not null, primary key
# nickname                         string       not null
# email                            string       not null
# avatar                           string
# crypted_password"                string
# salt                             string
# arrangements_count               bigint       default 0
# likes_count                      bigint       default 0
# role                             integer      default 0
# reset_password_token             string
# reset_password_token_eqpires_at  string
# reset_password_email_sent_at     datetime
# created_at                       datetime     not null
# updated_at"                      datetime     not null
#
# Index
#   index_users_on_email
#   index_users_on_nickname

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
