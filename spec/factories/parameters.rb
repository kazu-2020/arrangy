# == Schema Information
#
# Table name: parameters
#
#  id             :bigint           not null, primary key
#  satisfaction   :integer          default(3), not null
#  spiciness      :integer          default(3), not null
#  sweetness      :integer          default(3), not null
#  taste          :integer          default(3), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  arrangement_id :bigint
#
# Indexes
#
#  index_parameters_on_arrangement_id  (arrangement_id)
#
# Foreign Keys
#
#  fk_rails_...  (arrangement_id => arrangements.id)
#
FactoryBot.define do
  factory :parameter do
    taste { 3 }
    spiciness { 3 }
    sweetness { 3 }
    satisfaction { 3 }
    arrangement
  end
end
