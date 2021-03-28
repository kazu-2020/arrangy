class CommentSerializer
  include JSONAPI::Serializer
  # 参考 => https://github.com/jsonapi-serializer/jsonapi-serializer/issues/157
  singleton_class.include(ActionView::Helpers::DateHelper)

  set_type :comment
  attributes :body, :created_at

  attribute :created_at do |record|
    value = time_ago_in_words(record.created_at)
    value == '1分未満' ? '今' : "#{ value }前"
  end

  belongs_to :user
  belongs_to :arrangement
end
