require 'rails_helper'

RSpec.describe "自身の投稿一覧", type: :system, js: true do

  describe 'ページネーション機能' do
    context '50件投稿している場合' do
      let!(:user) { create(:user, :with_arrangements, count: 50) }

      before {
        log_in_as(user)
        sleep 1
        access_profile
      }

      it '15件分のデータが表示されている' do
        expect(has_selector?('.arrangement-summary')).to eq(true)
        expect(all('.arrangement-summary').count).to eq(15)
      end

      context '最後のページへ切り替えた時' do
        before {
          within '#top-pagination' do
            click_button('4')
          end
        }

        it '5件分のデータが表示されている' do
          expect(has_selector?('.arrangement-summary')).to eq(true)
          expect(all('.arrangement-summary').count).to eq(5)
        end
      end
    end

    context '投稿が10件の場合' do
      let!(:user) { create(:user, :with_arrangements, count: 10) }

      before {
        log_in_as(user)
        sleep 1
        access_profile
      }

      it 'ページネーションは表示されない' do
          expect(has_selector?('.top-pagination')).to eq(false)
      end
    end

    context '投稿がない場合' do
      let!(:user) { create(:user) }

      before {
        log_in_as(user)
        sleep 1
        access_profile
      }

      it '「現在、投稿はありません」と表示される' do
        expect(page).to have_content('現在、投稿はありません')
      end
    end
  end

  describe '投稿表示機能' do
    describe 'タイトル、投稿日時表示' do
      let!(:arrangement) { create(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo, title: 'testタイトル') }

      before {
        log_in_as(arrangement.user)
        sleep 1
        access_profile
      }

      it '表示されている' do
        within("#arrangement-#{encode_id(arrangement.id)}") do
          # 投稿画像のテストは除く
          expect(page).to have_content('testタイトル')
          expect(page).to have_content(I18n.l(arrangement.created_at, format: :short))
        end
      end
    end

    describe 'コメント数表示' do
      let!(:arrangement) { create(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo, :with_comments, count: 10) }

      before {
        log_in_as(arrangement.user)
        sleep 1
        access_profile
      }

      it '表示されている' do
        within("#arrangement-#{encode_id(arrangement.id)}") do
          expect(page).to have_content(10)
        end
      end
    end

    describe 'いいね数表示' do
      let!(:arrangement) { create(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo, :with_likes, count: 10) }

      before {
        log_in_as(arrangement.user)
        sleep 1
        access_profile
      }

      it '表示されている' do
        within("#arrangement-#{encode_id(arrangement.id)}") do
          expect(page).to have_content(10)
        end
      end
    end

    describe '編集/削除を選択できるメニューリスト表示' do
      let!(:arrangement) { create(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo, title: 'testタイトル') }

      before {
        log_in_as(arrangement.user)
        sleep 1
        access_profile
      }

      it '表示されている' do
        expect(has_selector?('#arrangement-menu-icon')).to eq(true)
      end
    end
  end

  context '投稿をクリックした場合' do
    let!(:arrangement) { create(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo) }

    before {
      log_in_as(arrangement.user)
      sleep 1
      access_profile
      first('.arrangement-summary').click
      sleep 1
    }

    it '投稿詳細ページへ遷移する' do
      expect(current_path).to eq("/arrangements/#{encode_id(arrangement.id)}")
    end
  end

  context '「お気に入り一覧」をクリックした場合' do
    let!(:user) { create(:user) }

    before {
      log_in_as(user)
      sleep 1
      access_profile
      click_on 'お気に入り一覧'
    }

    it 'お気に入り一覧が表示される' do
      expect(current_path).to eq('/profile/favorites')
    end
  end
end
