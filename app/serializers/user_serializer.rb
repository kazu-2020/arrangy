class UserSerializer
  include JSONAPI::Serializer
  set_type :user
  attributes :nickname, :email, :role, :likes_count, :arrangements_count

  attribute :avatar do |object|
    object.avatar.url
  end
  attribute :created_at do |record|
    I18n.l(record.created_at, format: :short)
  end

  has_many :arrangements
  has_many :comments
end
