Arrangement.count.times do |n|
  Parameter.seed(
    :id,
    {
      id: n,
      taste: rand(5),
      spiciness: rand(5),
      sweetness: rand(5),
      satisfaction: rand(5),
      arrangement_id: n
    }
  )
end