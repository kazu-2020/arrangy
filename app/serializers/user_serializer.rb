class UserSerializer
  include JSONAPI::Serializer
  set_type :users
  attributes :nickname, :email
end
