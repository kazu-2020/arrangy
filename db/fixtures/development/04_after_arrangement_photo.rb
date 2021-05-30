Arrangement.ids.each do |n|
  AfterArrangementPhoto.seed(
    :id,
    {
      id: n,
      url: '/images/development/sample_for_photo.png',
      arrangement_id: n
    }
  )
end