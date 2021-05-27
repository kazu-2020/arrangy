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
class BeforeArrangementPhoto < ApplicationRecord
  belongs_to :arrangement
end
