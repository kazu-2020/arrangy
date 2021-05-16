class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @nickname = user&.nickname
    @url = "/reset_password/edit?token=#{user&.reset_password_token}"
    mail(to: user&.email, subject: 'パスワード再設定の案内')
  end
end
