require 'rails_helper'

RSpec.describe Photo, type: :model do
  let(:photo) { build(:photo) }

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
