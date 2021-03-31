require 'rails_helper'

RSpec.describe "コメント編集", type: :system, js: true do
  let!(:comment) { create(:comment) }

  context 'ログインしている場合' do
    before {
      log_in_as(comment.user)
      find("#arrangement-#{comment.arrangement.id}").click
    }
  end
end
