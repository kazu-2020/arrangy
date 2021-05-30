# == Schema Information
#
# Table name: arrangements
#
#  id             :bigint           not null, primary key
#  arrange_level  :integer          default(0), not null
#  comments_count :bigint           default(0)
#  context        :text             not null
#  likes_count    :bigint           default(0)
#  rating         :integer          not null
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint
#
# Indexes
#
#  index_arrangements_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Arrangement < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_one  :after_arrangement_photo, dependent: :destroy
  has_one  :before_arrangement_photo, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user

  enum arrange_level: { row: 0, high: 1 }

  with_options presence: true do
    validates :title
    validates :context
    validates :rating
    validates :arrange_level
  end

  scope :sorted_by_new, -> { order(created_at: :desc) }

  def liked_by?(user)
    likes.pluck(:user_id).include?(user.id)
  end
end
