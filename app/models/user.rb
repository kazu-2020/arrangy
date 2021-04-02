# table information
# table name users
#
# id                               bigint       not null, primary key
# nickname                         string       not null
# email                            string       not null
# avatar                           string
# crypted_password"                string
# salt                             string
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
  has_many :comments,     dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liking_arrangements, through: :likes, source: :arrangement

  before_save :change_email_to_lowercase

  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  VALID_EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  VALID_PASSWORD_FORMAT = /\A\w+\z/i.freeze

  with_options if: :change_or_create_password do
    validates :password, length: { minimum: 6 }, format: { with: VALID_PASSWORD_FORMAT }
    validates :password, confirmation: true
    validates :password_confirmation, presence: true
  end

  validates :nickname, presence: true, uniqueness: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    length: { maximum: 50 }, format: { with: VALID_EMAIL_FORMAT }

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

  def change_or_create_password
    new_record? || changes[:crypted_password]
  end
end
