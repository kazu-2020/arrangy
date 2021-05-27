# == Schema Information
#
# Table name: before_arrangement_photos
#
#  id             :bigint           not null, primary key
#  url            :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  arrangement_id :bigint           not null
#
# Indexes
#
#  index_before_arrangement_photos_on_arrangement_id  (arrangement_id)
#
# Foreign Keys
#
#  fk_rails_...  (arrangement_id => arrangements.id)
#
FactoryBot.define do
  factory :before_arrangement_photo do
    url { "MyString" }
    arrangement { nil }
  end
end
