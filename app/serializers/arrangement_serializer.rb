class ArrangementSerializer
  include JSONAPI::Serializer
  set_type :arrangement
  attributes :title, :context
  attribute :images do |object|
    object.images.map(&:url)
  end

  # relationshipと同名の属性を作る必要がある。
  # 無い場合、fieldsオプションを使用した際にrelationshipsキーが空になる。
  # 空の場合、フロントで使用しているdevourがうまくいかない!!
  # 必要な場合と不必要な場合がある
  attribute :user do |object|
    object.user_id
  end

  belongs_to :user, serializer: UserSerializer
end