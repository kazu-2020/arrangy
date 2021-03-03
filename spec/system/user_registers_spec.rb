require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system, js: true do
  context 'ユーザー情報に不備がある場合' do
    before do
      visit '/register'
      click_on 'メールアドレスで登録'
    end
    it '新規登録に失敗する' do
      expect(page).to have_content 'ニックネームは必須項目です'
    end
  end
end
