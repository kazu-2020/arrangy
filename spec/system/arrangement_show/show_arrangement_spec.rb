require 'rails_helper'

RSpec.describe '投稿詳細', type: :system, js: true do
  let!(:self_arrangement) { create(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo) }

  context 'ログイン前' do
    context '自分が投稿したページへアクセスした時' do
      before { visit("/arrangements/#{encode_id(self_arrangement.id)}") }

      it '投稿した内容、投稿したユーザーの情報が表示されている' do
        within("#arrangement-#{encode_id(self_arrangement.id)}") do
          expect(page).to have_content(self_arrangement.title)
          expect(page).to have_content(self_arrangement.context)
          expect(page).to have_content(self_arrangement.user.nickname)
        end
      end
      it 'メニューリストは非表示になっている' do
        within("#arrangement-#{encode_id(self_arrangement.id)}") do
          expect(page.has_css?('#arrangement-menu-icon')).to eq(false)
        end
      end
    end
  end

  context 'ログイン後' do
    context '自分の投稿ページへアクセスした時' do
      before do
        log_in_as(self_arrangement.user)
        find("#arrangement-#{encode_id(self_arrangement.id)}").click
      end

      it '投稿した内容、投稿したユーザーの情報が表示されている' do
        within("#arrangement-#{encode_id(self_arrangement.id)}") do
          expect(page).to have_content(self_arrangement.title)
          expect(page).to have_content(self_arrangement.context)
          expect(page).to have_content(self_arrangement.user.nickname)
        end
      end
      it 'メニューリストが表示されている' do
        within("#arrangement-#{encode_id(self_arrangement.id)}") do
          expect(page.has_css?('#arrangement-menu-icon')).to eq(true)
        end
      end
    end

    context '他人の投稿ページへアクセスした時' do
      let!(:unself_arrangement) { create(:arrangement, :with_after_arrangement_photo, :with_before_arrangement_photo) }

      before { visit("/arrangements/#{encode_id(unself_arrangement.id)}")}

      it 'メニューリストは非表示になっている' do
        within("#arrangement-#{encode_id(unself_arrangement.id)}") do
          expect(page.has_css?('#arrangement-menu-icon')).to eq(false)
        end
      end
    end
  end
end
