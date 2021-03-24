module UserLogin
  def log_in_as(user)
    visit '/login'
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_on 'メールアドレスでログイン'
  end
end