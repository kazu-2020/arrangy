FactoryBot.define do
  factory :arrangement do
    title { "テスト投稿" }
    context { "これはテスト投稿です" }
    images { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/images/sample1.jpg")] }
    user

    trait :with_comment do
      after(:build) do |arrangement|
        arrangement.comments << create(:comment)
      end
    end
  end
end
