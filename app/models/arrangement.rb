# table information
# table name arrangements
#
# id                 bigint               not null, primary key
# user_id            bigint               foreign key
# title              string               not null
# context            text                 not null
# likes_count        bigint               default 0
# comments_count     bigint               default 0
# created_at         datetime             not null
# updated_at         datetime             not null
#
# Index
#   index_arrangements_on_user_id

class Arrangement < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_one  :parameter, dependent: :destroy
  has_one  :after_arrangement_photo, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user

  with_options presence: true do
    validates :title
    validates :context
  end

  scope :sorted_by_new, -> { order(created_at: :desc) }

  def liked_by?(user)
    likes.pluck(:user_id).include?(user.id)
  end
end
