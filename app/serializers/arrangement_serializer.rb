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
class ArrangementSerializer
  include JSONAPI::Serializer
  singleton_class.include(Api::Base64Converting)

  set_type :arrangement
  set_id do |record|
    encode_id(record.id)
  end

  attributes :title, :context, :rating, :arrange_level, :likes_count, :comments_count
  attribute :liked_authuser do |record, params|
    record.liked_by?(params[:current_user]) if params[:current_user]
  end
  attribute :created_at do |record|
    I18n.l(record.created_at, format: :short)
  end

  belongs_to :user
  has_many :comments
  has_one :after_arrangement_photo
  has_one :before_arrangement_photo
end
