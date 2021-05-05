module Nickname
  extend ActiveSupport::Concern

  included do
    validates :nickname, length: { maximum: 30 }
  end
end
