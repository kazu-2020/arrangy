30.times do |n|
  Comment.seed(
    :id,
    { id: n, body: Faker::Lorem.sentence , arrangement_id: Arrangement.first.id, user_id: User.ids.sample }
  )
end

Arrangement.reset_counters(Arrangement.first.id, :comments)