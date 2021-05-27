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
class ParameterSerializer
  include JSONAPI::Serializer

  set_type :parameter
  attributes :taste, :spiciness, :sweetness, :satisfaction

  belongs_to :arrangement
end
