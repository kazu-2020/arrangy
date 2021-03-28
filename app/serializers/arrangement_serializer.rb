class ArrangementSerializer
  include JSONAPI::Serializer
  set_type :arrangement
  attributes :title, :context
  attribute :images do |object|
    object.images.map(&:url)
  end


  belongs_to :user
  has_many :comments
end
