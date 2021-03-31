FactoryBot.define do
  factory :user do
    sequence(:nickname) { |n| "test_user#{n}" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }

    trait :with_arrangements do
      transient do
        count { 5 }
      end

      after(:build) do |user, evaluator|
        user.arrangements << create_list(:arrangement, evaluator.count)
      end
    end
  end
end
