class ArrangementSerializer
  include JSONAPI::Serializer
  set_type :arrangement
  attributes :title, :context, :images
  belongs_to :user
end
