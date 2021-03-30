require 'rails_helper'

RSpec.describe '投稿詳細機能', type: :system, js: true do
  let!(:self_arrangement) { create(:arrangement) }

  context 'ログイン前' do
    context '自分が投稿したページへアクセスした時' do
      before { visit("/arrangements/#{self_arrangement.id}") }

      it '投稿した内容、投稿したユーザーの情報が表示されている' do
        within("#arrangement-#{self_arrangement.id}") do
          expect(page).to have_content(self_arrangement.title)
          expect(page).to have_content(self_arrangement.context)
          expect(page).to have_content(self_arrangement.user.nickname)
          result = all('img').any? do |element|
            element[:src].include?(self_arrangement.user.avatar.url)
          end
          expect(result).to eq(true)
        end
      end
      it 'メニューリストは非表示になっている' do
        within("#arrangement-#{self_arrangement.id}") do
          expect(page.has_css?('#arrangement-menu-icon')).to eq(false)
        end
      end
    end
  end

  context 'ログイン後' do
    context '自分の投稿ページへアクセスした時' do
      before do
        log_in_as(self_arrangement.user)
        visit("/arrangements/#{self_arrangement.id}")
      end

      it '投稿した内容、投稿したユーザーの情報が表示されている' do
        within("#arrangement-#{self_arrangement.id}") do
          expect(page).to have_content(self_arrangement.title)
          expect(page).to have_content(self_arrangement.context)
          expect(page).to have_content(self_arrangement.user.nickname)
          result = all('img').any? do |element|
            element[:src].include?(self_arrangement.user.avatar.url)
          end
          expect(result).to eq(true)
        end
      end
      it 'メニューリストが表示されている' do
        within("#arrangement-#{self_arrangement.id}") do
          expect(page.has_css?('#arrangement-menu-icon')).to eq(true)
        end
      end
    end

    context '他人の投稿ページへアクセスした時' do
      let!(:unself_arrangement) { create(:arrangement) }

      before { visit("/arrangements/#{unself_arrangement.id}")}

      it 'メニューリストは非表示になっている' do
        within("#arrangement-#{unself_arrangement.id}") do
          expect(page.has_css?('#arrangement-menu-icon')).to eq(false)
        end
      end
    end
  end
end
