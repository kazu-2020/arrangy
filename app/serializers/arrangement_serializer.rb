class ArrangementSerializer
  include JSONAPI::Serializer
  singleton_class.include(Api::Base64Converting)

  set_type :arrangement
  set_id do |record|
    encode_id(record.id)
  end

  attributes :title, :context
  attribute :images do |record|
    record.images.map(&:url)
  end
  attribute :liked_authuser do |record, params|
    record.liked_by?(params[:current_user]) if params[:current_user]
  end
  attribute :likes_count do |record|
    record.likes.size
  end

  belongs_to :user
  has_many :comments
end
