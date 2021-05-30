30.times do |n|
  Arrangement.seed(
    :id,
    {
      id: n,
      title: Faker::Food.dish,
      context: Faker::Food.description,
      rating: rand(1..5),
      user_id: User.first.id
    }
  )
end

31.upto(60) do |n|
  Arrangement.seed(
    :id,
    {
      id: n,
      title: Faker::Food.dish,
      context: Faker::Food.description,
      rating: rand(1..5),
      user_id: User.ids.sample
    }
  )
end