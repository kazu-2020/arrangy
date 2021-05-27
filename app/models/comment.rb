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
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :arrangement, counter_cache: true

  validates :body, presence: true, length: { maximum: 1_000 }

  scope :for_arrangement, ->(arrangement_id) { where(arrangement_id: arrangement_id) }
  scope :sorted_by_new, -> { order(created_at: :desc) }
end
