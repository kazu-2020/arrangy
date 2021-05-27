require 'rails_helper'

RSpec.describe "投稿一覧", type: :system, js: true do
  # describe '無限スクロール機能(条件: 投稿データが50件)' do
  #   let!(:arrangements) { create_list(:arrangement, 50, :with_after_arrangement_photo, :with_parameter) }

  #   before { visit('/') }

  #   fit 'スクロール前は20件分のデータが表示されている' do
  #     expect(all('.arrangement-summary').count).to eq(20)
  #   end

  #   context '下までスクロールした場合' do
  #     before do
  #       5.times do
  #         sleep 1
  #         execute_script('window.scroll(0,10000);')
  #       end
  #     end

  #     it '50件分のデータが表示されている' do
  #       expect(all('.arrangement-summary').count).to eq(50)
  #     end
  #   end
  # end

  describe '投稿表示機能' do
    describe 'タイトル、投稿日時、ユーザー情報表示' do
      let!(:arrangement) { create(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo, :with_parameter, title: 'testタイトル') }

      before { visit('/') }

      it '表示されている' do
        within("#arrangement-#{encode_id(arrangement.id)}") do
          # 画像のテストは除く
          expect(page).to have_content('testタイトル')
          expect(page).to have_content(I18n.l(arrangement.created_at, format: :short))
          expect(page).to have_content(arrangement.user.nickname)
        end
      end
    end

    describe 'コメント数表示' do
      let!(:arrangement) { create(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo, :with_parameter, :with_comments, count: 10) }

      before { visit('/') }

      it '表示されている' do
        within("#arrangement-#{encode_id(arrangement.id)}") do
          expect(page).to have_content(10)
        end
      end
    end

    describe 'いいね数表示' do
      let!(:arrangement) { create(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo, :with_parameter, :with_likes, count: 10) }

      before { visit('/') }

      it '表示されている' do
        within("#arrangement-#{encode_id(arrangement.id)}") do
          expect(page).to have_content(10)
        end
      end
    end
  end
end
