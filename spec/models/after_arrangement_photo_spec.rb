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
require 'rails_helper'

RSpec.describe AfterArrangementPhoto, type: :model do
  let(:photo) { build(:after_arrangement_photo) }

  describe 'テストデータの検証' do
    it 'テストデータは有効です' do
      expect(photo).to be_valid
    end
  end

  describe 'presenceの検証' do
    it 'urlが未入力場合、無効です' do
      photo.url = ''
      expect(photo).to be_invalid
    end
  end
end
