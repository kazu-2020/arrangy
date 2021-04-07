require 'rails_helper'

RSpec.describe "自身の投稿一覧", type: :system, js: true do

  describe '無限スクロール機能' do
    context '50件投稿している場合' do
      let!(:user) { create(:user, :with_arrangements, count: 50) }

      before {
        log_in_as(user)
        access_profile
      }

      it 'スクロール前は20件分のデータが表示されている' do
        expect(has_selector?('.arrangement-summary')).to eq(true)
        expect(all('.arrangement-summary').count).to eq(20)
      end

      context '下までスクロールした場合' do
        before do
          5.times do
            sleep(1)
            execute_script('window.scroll(0,10000);')
          end
        end

        it '50件分のデータが表示されている' do
          expect(all('.arrangement-summary').count).to eq(50)
        end
      end
    end

    context '投稿がない場合' do
      let!(:user) { create(:user) }

      before {
        log_in_as(user)
        access_profile
      }

      it '「現在、投稿はありません」と表示される' do
        expect(page).to have_content('現在、投稿はありません')
      end
    end
  end

  describe '投稿表示機能' do
    describe 'タイトル、投稿日時表示' do
      let!(:arrangement) { create(:arrangement, title: 'testタイトル') }

      before {
        log_in_as(arrangement.user)
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
      let!(:arrangement) { create(:arrangement, :with_comments, count: 10) }

      before {
        log_in_as(arrangement.user)
        access_profile
      }

      it '表示されている' do
        within("#arrangement-#{encode_id(arrangement.id)}") do
          expect(page).to have_content(10)
        end
      end
    end

    describe 'いいね数表示' do
      let!(:arrangement) { create(:arrangement, :with_likes, count: 10) }

      before {
        log_in_as(arrangement.user)
        access_profile
      }

      it '表示されている' do
        within("#arrangement-#{encode_id(arrangement.id)}") do
          expect(page).to have_content(10)
        end
      end
    end

    describe '編集/削除を選択できるメニューリスト表示' do
      let!(:arrangement) { create(:arrangement, title: 'testタイトル') }

      before {
        log_in_as(arrangement.user)
        access_profile
      }

      it '表示されている' do
        expect(has_selector?('#arrangement-menu-icon')).to eq(true)
      end
    end
  end

  context '投稿をクリックした場合' do
    let!(:arrangement) { create(:arrangement) }

    before {
      log_in_as(arrangement.user)
      access_profile
      first('.arrangement-summary').click
    }

    it '投稿詳細ページへ遷移する' do
      expect(current_path).to eq("/arrangements/#{encode_id(arrangement.id)}")
    end
  end

  context '「お気に入り一覧」をクリックした場合' do
    let!(:user) { create(:user) }

    before {
      log_in_as(user)
      access_profile
      click_on 'お気に入り一覧'
    }

    it 'お気に入り一覧が表示される' do
      expect(current_path).to eq('/profile/favorites')
    end
  end
end
