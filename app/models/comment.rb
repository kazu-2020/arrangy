# table informatioin
# table name  comments
#
# id                 bigint       not null, primary key
# user_id            bigint       foreign key
# arrangement_id     bigint       foreign key
# body               text         not null
# created_at         datetime     not null
# updated_at         datetime     not null
#
# Index
#   index_comments_on_arrangement_id
#   index_comments_on_user_id

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :arrangement

  validates :body, presence: true, length: { maximum: 1_000 }

  scope :for_arrangement, ->(arrangement_id) { where(arrangement_id: arrangement_id) }
  scope :sorted_by_new, -> { order(created_at: :desc) }
end
