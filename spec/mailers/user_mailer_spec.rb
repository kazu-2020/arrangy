require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "パスワード再設定メール" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.reset_password_email(user) }

    before { user.generate_reset_password_token! }

    it "ヘッダー情報が正しいこと" do
      expect(mail.subject).to eq('パスワード再設定の案内')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['no_replay@arrangy.com'])
    end
  end
end
