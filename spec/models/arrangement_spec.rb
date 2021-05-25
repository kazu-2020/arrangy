require 'rails_helper'

RSpec.describe Arrangement, type: :model do
  let(:arrangement) { build(:arrangement) }

  describe 'テストデータの検証' do
    it '有効です' do
      expect(arrangement).to be_valid
    end
  end

  describe 'presenceの検証' do
    it 'タイトルが未入力の場合、無効です' do
      arrangement.title = ''
      expect(arrangement).to be_invalid
    end
    it '投稿内容が未入力の場合、無効です' do
      arrangement.context = ''
      expect(arrangement).to be_invalid
    end
  end

end
