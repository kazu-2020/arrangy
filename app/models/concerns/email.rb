module Email
  extend ActiveSupport::Concern

  VALID_EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  included do
    validates :email, length: { maximum: 50 }, format: { with: VALID_EMAIL_FORMAT }
  end
end
