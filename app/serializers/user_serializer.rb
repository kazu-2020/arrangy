class UserSerializer
  include JSONAPI::Serializer
  set_type :user
  attributes :nickname, :email
  has_many :arrangements
end
