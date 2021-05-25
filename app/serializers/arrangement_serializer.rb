class ArrangementSerializer
  include JSONAPI::Serializer
  singleton_class.include(Api::Base64Converting)

  set_type :arrangement
  set_id do |record|
    encode_id(record.id)
  end

  attributes :title, :context, :likes_count, :comments_count
  attribute :images do |record|
    record.images.map(&:url)
  end
  attribute :liked_authuser do |record, params|
    record.liked_by?(params[:current_user]) if params[:current_user]
  end
  attribute :created_at do |record|
    I18n.l(record.created_at, format: :short)
  end

  belongs_to :user
  has_many :comments
  has_one :parameter
  has_one :after_arrangement_photo
end
