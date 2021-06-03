require 'rails_helper'

RSpec.describe "退会機能", type: :system, js: true do
  let(:user) { create(:user)}

  before {
    log_in_as(user)
    sleep 1
    access_profile
  }

  context '「退会する」を押した時' do
    before { click_on("退会する") }

    it '退会確認用のダイアログが表示される' do within('#delete-confirmation') do
        expect(page).to have_content('Arrangyを退会する')
        expect(page).to have_button('削除する')
        expect(page).to have_button('キャンセル')
      end
    end

    context '確認用ダイアログの「削除する」をクリックした場合' do
      before {
        within('#delete-confirmation') do
          click_button('削除する')
        end
      }

      it '「退会しました」と表示され、トップページへ遷移する' do
        expect(find('#global-snackbar')).to have_text('退会しました')
        sleep 1
        expect(current_path).to eq('/')
      end
    end
  end
end