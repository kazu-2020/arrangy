# == Schema Information
#
# Table name: authentications
#
#  id         :bigint           not null, primary key
#  provider   :string           not null
#  uid        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_authentications_on_provider_and_uid  (provider,uid)
#  index_authentications_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
