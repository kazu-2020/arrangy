User.seed(
  :id,
  {
    id: 0,
    nickname: 'mimata',
    email: 'mimata@example.com',
    avatar_url: '/images/development/sample_avatar.png',
    crypted_password: User.encrypt('password'),
    role: 1
  }
)

1.upto(4) do |n|
  User.seed(
    :id,
    {
      id: n,
      nickname: Faker::Name.unique.first_name,
      email: Faker::Internet.unique.email,
      crypted_password: User.encrypt('password')
    }
  )
end
