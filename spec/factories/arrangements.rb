FactoryBot.define do
  factory :arrangement do
    title { "テスト投稿" }
    context { "これはテスト投稿です" }
    images { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/images/img1.jpg")] }
    user
  end
end
