require 'rails_helper'

RSpec.describe "自身の投稿一覧", type: :system, js: true do

  describe '無限スクロール機能' do
    context '50件投稿している場合' do
      let!(:user) { create(:user, :with_arrangements, count: 50) }

      before {
        log_in_as(user)
        visit_profile
      }

      it 'スクロール前は20件分のデータが表示されている' do
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
        visit_profile
      }

      it '「現在、投稿はありません」と表示される' do
        expect(page).to have_content('現在、投稿はありません')
      end
    end
  end

  context '投稿をクリックした場合' do
    let!(:arrangement) { create(:arrangement) }

    before {
      log_in_as(arrangement.user)
      visit_profile
      first('.arrangement-summary').click
    }

    it '投稿詳細ページへ遷移する' do
      expect(current_path).to eq("/arrangements/#{arrangement.id}")
    end
  end
end
