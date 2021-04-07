# table information
# table name arrangements
#
# id                 bigint               not null, primary key
# user_id            bigint               foreign key
# title              string               not null
# context            text                 not null
# images             json                 not null
# likes_count        bigint               default 0
# comments_count     bigint               default 0
# created_at         datetime             not null
# updated_at         datetime             not null
#
# Index
#   index_arrangements_on_user_id

class Arrangement < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user

  mount_uploaders :images, ImageUploader

  validates :title, presence: true, length: { maximum: 30 }
  validates :context, presence: true, length: { maximum: 1000 }
  validates :images, presence: true

  scope :sorted_by_new, -> { order(created_at: :desc) }

  def liked_by?(user)
    likes.pluck(:user_id).include?(user.id)
  end
end
