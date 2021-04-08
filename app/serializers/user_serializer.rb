class UserSerializer
  include JSONAPI::Serializer
  set_type :user
  attributes :nickname, :email

  attribute :avatar do |object|
    object.avatar.url
  end

  has_many :arrangements
  has_many :comments

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.hour
end
