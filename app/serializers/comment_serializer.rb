# == Schema Information
#
# Table name: comments
#
#  id             :bigint           not null, primary key
#  body           :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  arrangement_id :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_comments_on_arrangement_id  (arrangement_id)
#  index_comments_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (arrangement_id => arrangements.id)
#  fk_rails_...  (user_id => users.id)
#
class CommentSerializer
  include JSONAPI::Serializer
  # 参考 => https://github.com/jsonapi-serializer/jsonapi-serializer/issues/157
  singleton_class.include(ActionView::Helpers::DateHelper)

  set_type :comment
  attributes :body, :created_at

  attribute :created_at do |record|
    value = time_ago_in_words(record.created_at)
    value == '1分未満' ? '今' : "#{value}前"
  end

  attribute :edited do |record|
    record.created_at != record.updated_at
  end

  belongs_to :user
  belongs_to :arrangement
end
