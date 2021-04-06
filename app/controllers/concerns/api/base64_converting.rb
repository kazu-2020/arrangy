module Api
  module Base64Converting
    extend ActiveSupport::Concern

    def encode_id(id)
      Base64.urlsafe_encode64(id.to_s, padding: false)
    end

    def decode_id(id)
      Base64.urlsafe_decode64(id.to_s)
    end
  end
end
