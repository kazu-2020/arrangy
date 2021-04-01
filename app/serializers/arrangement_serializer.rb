class ArrangementSerializer
  include JSONAPI::Serializer
  set_type :arrangement
  set_id do |record|
    Base64.encode64(record.id.to_s)
  end
  attributes :title, :context
  attribute :images do |object|
    object.images.map(&:url)
  end

  belongs_to :user
  has_many :comments
end
