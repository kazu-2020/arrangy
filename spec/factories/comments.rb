FactoryBot.define do
  factory :comment do
    body { "MyText" }
    user { nil }
    arrangement { nil }
  end
end
