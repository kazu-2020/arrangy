# 前回のシード画像を削除
FileUtils.rm_rf("#{Rails.root}/public/uploads/arrangement")

50.times do |n|
  Arrangement.seed(
    :id,
    { id: n, title: Faker::Food.dish , context: Faker::Food.description, images: [File.open("#{Rails.root}/db/fixtures/images/img1.jpg")], user_id: User.ids.sample }
  )
end
