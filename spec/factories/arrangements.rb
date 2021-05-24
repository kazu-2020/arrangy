FactoryBot.define do
  factory :arrangement do
    title { "テスト投稿" }
    context { "これはテスト投稿です" }
    user

    trait :with_parameter do
      after(:build) do |arrangement|
        arrangement.parameter = create(:parameter)
      end
    end

    trait :with_comment do
      after(:build) do |arrangement|
        arrangement.comments << create(:comment)
      end
    end

    trait :with_comments do
      transient do
        count { 5 }
      end

      after(:build) do |arrangement, evaluator|
        arrangement.comments << create_list(:comment, evaluator.count)
      end
    end

    trait :with_likes do
      transient do
        count { 5 }
      end

      after(:build) do |arrangement, evaluator|
        arrangement.liked_by_users << create_list(:user, evaluator.count)
      end
    end
  end
end
