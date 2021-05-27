# == Schema Information
#
# Table name: arrangements
#
#  id             :bigint           not null, primary key
#  comments_count :bigint           default(0)
#  context        :text             not null
#  likes_count    :bigint           default(0)
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint
#
# Indexes
#
#  index_arrangements_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
