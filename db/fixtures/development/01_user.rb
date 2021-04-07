FileUtils.rm_rf("#{Rails.root}/public/uploads/user")

User.seed(
  :id,
  { id: 0, nickname: 'mimata', email: 'mimata@mimata.com', crypted_password: User.encrypt('password') }
)

1.upto(4) do |n|
  User.seed(
    :id,
    { id: n, nickname: Faker::Name.unique.first_name, email: Faker::Internet.unique.email, crypted_password: User.encrypt('password') }
  )
end
