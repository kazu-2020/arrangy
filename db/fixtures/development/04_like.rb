User.ids.count.times do |n|
  Like.seed(
    :id,
    { id: n, arrangement_id: Arrangement.first.id, user_id: n }
  )
end

Arrangement.reset_counters(Arrangement.first.id, :likes)