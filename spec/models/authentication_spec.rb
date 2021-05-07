require 'rails_helper'

RSpec.describe Authentication, type: :model do
  let(:authentication) { build(:authentication) }

  describe 'テストデータの検証' do
    it '有効です' do
      expect(authentication).to be_valid
    end
  end

  describe 'presenceの検証' do
    it 'uidが未入力の場合、無効です' do
      authentication.uid = ''
      expect(authentication).to be_invalid
    end
    it 'providerが未入力の場合、無効です' do
      authentication.provider = ''
      expect(authentication).to be_invalid
    end
  end
end
