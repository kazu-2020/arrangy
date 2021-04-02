# table informatioin
# table name  likes
#
# id                 bigint       not null, primary key
# user_id            bigint       not null, foreign key
# arrangement_id     bigint       not null, foreign key
# created_at         datetime     not null
# updated_at         datetime     not null
#
# Index
#   index_likes_on_arrangement_id
#   index_likes_on_user_id

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :arrangement

  validates :arrangement_id, uniqueness: { scope: :user_id }
end
