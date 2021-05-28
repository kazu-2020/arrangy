require 'rails_helper'

RSpec.describe "ヘッダー", type: :system, js: true do
  before {
    visit('/')
  }

  context 'ログイン前' do
    it 'ログインボタンが表示されている' do
      within '#page-header' do
        expect(has_link?('ログイン')).to eq(true)
        find_link('ログイン').click
        expect(current_path).to eq('/login')
      end
    end
    it 'トップページへ遷移する為のロゴが表示されている' do
      within '#page-header' do
        expect(has_css?('#header-logo')).to eq(true)
        find('#header-logo').click
        expect(current_path).to eq('/')
      end
    end
    it 'アバター画像は表示されない' do
      within '#page-header' do
        expect(has_css?('#header-avatar')).to eq(false)
      end
    end
  end

  context 'ログイン後' do
    let(:user) { create(:user) }

    before { log_in_as(user) }

    it 'アバター画像が表示される' do
      within '#page-header' do
        expect(has_css?('#header-avatar')).to eq(true)
      end
    end
  end
end
