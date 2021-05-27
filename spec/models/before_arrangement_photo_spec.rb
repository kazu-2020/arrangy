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
require 'rails_helper'

RSpec.describe BeforeArrangementPhoto, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
