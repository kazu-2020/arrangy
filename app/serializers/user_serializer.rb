class UserSerializer
  include JSONAPI::Serializer
  set_type :user
  attributes :nickname, :email, :likes_count, :arrangements_count

  attribute :avatar do |object|
    object.avatar.url
  end

  has_many :arrangements
  has_many :comments
end
