FactoryBot.define do
  factory :comment do
    body { "これはテスト投稿です" }
    user
    arrangement
  end
end
