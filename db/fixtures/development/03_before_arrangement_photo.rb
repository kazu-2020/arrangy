Arrangement.ids.each do |n|
  BeforeArrangementPhoto.seed(
    :id,
    {
      id: n,
      url: '/images/development/sample_for_photo.png',
      arrangement_id: n
    }
  )
end