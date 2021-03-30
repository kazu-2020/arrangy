require 'rails_helper'

RSpec.describe "投稿一覧", type: :system, js: true do
  describe '無限スクロール機能(条件: 投稿データが50件)' do
    before {
      create_list(:arrangement, 50)
      visit('/')
    }

    it 'スクロール前は20件分のデータが表示されている' do
      expect(all('.arrangement-summary').count).to eq 20
    end

    context '下までスクロールした場合' do
      before do
        5.times do
          sleep(1)
          execute_script('window.scroll(0,10000);')
        end
      end

      it '50件分のデータが表示されている' do
        expect(all('.arrangement-summary').count).to eq 50
      end
    end
  end

  describe '投稿表示機能' do
    let!(:arrangement) { create(:arrangement, title: 'testタイトル') }

    before { visit('/') }

    it '投稿情報が表示されている' do
      within("#arrangement-#{arrangement.id}") do
        # 画像データのテストは除く
        expect(page).to have_content('testタイトル')
        expect(page).to have_content(arrangement.user.nickname)
        result = all('img').any? do |element|
          element[:src].include?(arrangement.user.avatar.url)
        end
        expect(result).to eq(true)
      end
    end
  end
end
