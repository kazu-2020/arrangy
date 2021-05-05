module CryptedPassword
  extend ActiveSupport::Concern

  VALID_PASSWORD_FORMAT = /\A\w+\z/i.freeze

  included do
    validates :password, presence: true, confirmation: true, length: { minimum: 6 },
                         format: { with: VALID_PASSWORD_FORMAT }
    validates :password_confirmation, presence: true
  end
end
