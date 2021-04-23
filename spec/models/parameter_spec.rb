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

  describe '整数値の検証' do
    it '美味さが少数値の場合、無効です' do
      parameter.taste = 2.5
      expect(parameter).to be_invalid
    end
    it '辛さが少数値の場合、無効です' do
      parameter.spiciness = 3.5
      expect(parameter).to be_invalid
    end
    it '甘さが少数値の場合、無効です' do
      parameter.sweetness = 1.5
      expect(parameter).to be_invalid
    end
    it '食べ応えが少数値の場合、無効です' do
      parameter.satisfaction = 4.5
      expect(parameter).to be_invalid
    end
  end

  describe '最小値の検証' do
    it '美味さがマイナス値の場合、無効です' do
      parameter.taste = -1
      expect(parameter).to be_invalid
    end
    it '辛さがマイナス値の場合、無効です' do
      parameter.spiciness = -0.1
      expect(parameter).to be_invalid
    end
    it '甘さがマイナス値の場合、無効です' do
      parameter.sweetness = -2
      expect(parameter).to be_invalid
    end
    it '食べ応えがマイナス値の場合、無効です' do
      parameter.satisfaction = -3
      expect(parameter).to be_invalid
    end
    it '美味さが0の場合、有効です' do
      parameter.taste = 0
      expect(parameter).to be_valid
    end
    it '辛さが0の場合、有効です' do
      parameter.spiciness = 0
      expect(parameter).to be_valid
    end
    it '甘さが0の場合、有効です' do
      parameter.sweetness = 0
      expect(parameter).to be_valid
    end
    it '食べ応えが0の場合、有効です' do
      parameter.satisfaction = 0
      expect(parameter).to be_valid
    end
  end

  describe '最大値の検証' do
    it '美味さの値が5より大きい場合、無効です' do
      parameter.taste = 6
      expect(parameter).to be_invalid
    end
    it '辛さの値が5より大きい場合、無効です' do
      parameter.spiciness = 7
      expect(parameter).to be_invalid
    end
    it '甘さの値が5より大きい場合、無効です' do
      parameter.sweetness = 8
      expect(parameter).to be_invalid
    end
    it '食べ応えの値が5より大きい場合、無効です' do
      parameter.satisfaction = 9
      expect(parameter).to be_invalid
    end
    it '美味さの値が5の場合、有効です' do
      parameter.taste = 5
      expect(parameter).to be_valid
    end
    it '辛さの値が5の場合、有効です' do
      parameter.spiciness = 5
      expect(parameter).to be_valid
    end
    it '甘さの値が5の場合、有効です' do
      parameter.sweetness =5
      expect(parameter).to be_valid
    end
    it '食べ応えの値が5の場合、有効です' do
      parameter.satisfaction = 5
      expect(parameter).to be_valid
    end
  end
end
