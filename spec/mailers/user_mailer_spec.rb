require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "パスワード再設定メール" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.reset_password_email(user) }

    before { user.generate_reset_password_token! }

    it "ヘッダー、ボディ情報が正しいこと" do
      expect(mail.subject).to eq('パスワード再設定の案内')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
      url = "/reset_password/edit?token=#{user.reset_password_token}"
      expect(mail.body.include?(url)).to eq(true)
    end
  end
end
