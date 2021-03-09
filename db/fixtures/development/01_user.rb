User.seed(
  :id,
  { id: 1, nickname: 'mimata', email: 'mimata@mimata.com', crypted_password: User.encrypt('password') }
)

2.upto(5) do |n|
  User.seed(
    :id,
    { id: n, nickname: Faker::Name.unique.first_name, email: Faker::Internet.unique.email, crypted_password: User.encrypt('password') }
  )
end
