module Api
  module Base64Converting
    extend ActiveSupport::Concern
    SALT = 'Arrangey'.freeze

    def encode_id(id)
      Base64.urlsafe_encode64(id.to_s + SALT, padding: false)
    end

    def decode_id(id)
      Base64.urlsafe_decode64(id.to_s).delete(SALT)
    end
  end
end
