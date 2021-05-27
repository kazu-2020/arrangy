# == Schema Information
#
# Table name: likes
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  arrangement_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_likes_on_user_id_and_arrangement_id  (user_id,arrangement_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (arrangement_id => arrangements.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :like do
    user { nil }
    arrangement { nil }
  end
end
