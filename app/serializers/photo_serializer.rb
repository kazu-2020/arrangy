class PhotoSerializer
  include JSONAPI::Serializer
  attributes :url

  belongs_to :arrangement
end
