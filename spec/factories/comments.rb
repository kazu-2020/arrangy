FactoryBot.define do
  factory :comment do
    body { "これはテストコメントです" }
    user
    arrangement

    trait :set_user do
      transient do
        sequence(:nickname) { |n| "test_user#{n}" }
        sequence(:email) { |n| "example#{n}@example.com" }
      end

      after(:build) do |comment, evaluator|
        comment.user = create(:user, nickname: evaluator.nickname, email: evaluator.email)
      end
    end
  end
end
