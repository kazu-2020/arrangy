class CommentSerializer
  include JSONAPI::Serializer
  set_type :comment
  attributes :body

  belongs_to :user
  belongs_to :arrangement
end
