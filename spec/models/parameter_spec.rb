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
require 'rails_helper'

RSpec.describe Parameter, type: :model do
  let(:parameter) { build(:parameter) }

  describe 'テストデータの検証' do
    it 'テストデータは有効です' do
      expect(parameter).to be_valid
    end
  end

  describe 'presenceの検証' do
    it '美味さが未入力の場合、無効です' do
      parameter.taste = ''
      expect(parameter).to be_invalid
    end
    it '辛さが未入力の場合、無効です' do
      parameter.spiciness = ''
      expect(parameter).to be_invalid
    end
    it '甘さが未入力の場合、無効です' do
      parameter.sweetness = ''
      expect(parameter).to be_invalid
    end
    it '食べ応えが未入力の場合、無効です' do
      parameter.satisfaction = ''
      expect(parameter).to be_invalid
    end
  end

end
