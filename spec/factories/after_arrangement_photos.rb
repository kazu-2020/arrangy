# == Schema Information
#
# Table name: after_arrangement_photos
#
#  id             :bigint           not null, primary key
#  url            :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  arrangement_id :bigint
#
# Indexes
#
#  index_after_arrangement_photos_on_arrangement_id  (arrangement_id)
#
# Foreign Keys
#
#  fk_rails_...  (arrangement_id => arrangements.id)
#
FactoryBot.define do
  factory :after_arrangement_photo do
    url { '/images/development/sample_for_photo.png' }
    arrangement
  end
end
