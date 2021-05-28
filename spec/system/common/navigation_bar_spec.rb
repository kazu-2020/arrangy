require 'rails_helper'

RSpec.describe "ナビゲーションバー", type: :system, js: true do
  context 'ログイン前' do
    before {
      visit('/')
      within '#page-header' do
        find('#navigation-icon').click
      end
    }

    it '「ホーム」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('ホーム')).to eq(true)
        click_link('ホーム')
        sleep 1
        expect(current_path).to eq('/')
      end
    end
    it '「新規投稿」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('新規投稿')).to eq(true)
      end
    end
    it '「利用規約」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('利用規約')).to eq(true)
        click_link('利用規約')
        sleep 1
        expect(current_path).to eq('/terms')
      end
    end
    it '「プライバシーポリシー」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('プライバシーポリシー')).to eq(true)
        click_link('プライバシーポリシー')
        sleep 1
        expect(current_path).to eq('/policy')
      end
    end
    it '「お問い合せ」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('お問い合せ')).to eq(true)
        click_link('お問い合せ')
        sleep 1
        expect(current_path).to eq('/contact')
      end
    end
    it '「Arragyとは」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('Arrangyとは')).to eq(true)
        click_link('Arrangyとは')
        sleep 1
        expect(current_path).to eq('/about')
      end
    end
    it '「マイページ」リンクは非表示になっている' do
      within '#navigation-menu' do
        expect(has_link?('マイページ')).to eq(false)
      end
    end
    it '「お気に入り一覧」リンクは非表示になっている' do
      within '#navigation-menu' do
        expect(has_link?('お気に入り一覧')).to eq(false)
      end
    end
    it '「ログアウト」ボタンは非表示になっている' do
      within '#navigation-menu' do
        expect(has_button?('ログアウト')).to eq(false)
      end
    end
  end

  let(:user) { create(:user) }

  context 'ログイン後' do
    before {
      log_in_as(user)
      sleep 1
      within '#page-header' do
        find('#navigation-icon').click
      end
    }

    it '「ホーム」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('ホーム')).to eq(true)
        click_link('ホーム')
        expect(current_path).to eq('/')
      end
    end
    it '「新規投稿」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('新規投稿')).to eq(true)
      end
    end
    it '「利用規約」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('利用規約')).to eq(true)
        click_link('利用規約')
        sleep 1
        expect(current_path).to eq('/terms')
      end
    end
    it '「プライバシーポリシー」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('プライバシーポリシー')).to eq(true)
        click_link('プライバシーポリシー')
        sleep 1
        expect(current_path).to eq('/policy')
      end
    end
    it '「お問い合せ」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('お問い合せ')).to eq(true)
        click_link('お問い合せ')
        sleep 1
        expect(current_path).to eq('/contact')
      end
    end
    it '「Arragyとは」リンクが表示されている' do
      within '#navigation-menu' do
        expect(has_link?('Arrangyとは')).to eq(true)
        click_link('Arrangyとは')
        sleep 1
        expect(current_path).to eq('/about')
      end
    end
    it '「マイページ」リンクは表示になっている' do
      within '#navigation-menu' do
        expect(has_link?('マイページ')).to eq(true)
        click_link('マイページ').click
        sleep 1
        expect(current_path).to eq('/profile/')
      end
    end
    it '「お気に入り一覧」リンクは表示になっている' do
      within '#navigation-menu' do
        expect(has_link?('お気に入り一覧')).to eq(true)
        click_link('お気に入り一覧').click
        sleep 1
        expect(current_path).to eq('/profile/favorites')
      end
    end
    it '「ログアウト」ボタンは非表示になっている' do
      within '#navigation-menu' do
        expect(has_button?('ログアウト')).to eq(true)
      end
    end
  end
end