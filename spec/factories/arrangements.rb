# == Schema Information
#
# Table name: arrangements
#
#  id             :bigint           not null, primary key
#  arrange_level  :integer          default("row"), not null
#  comments_count :bigint           default(0)
#  context        :text             not null
#  likes_count    :bigint           default(0)
#  rating         :integer          not null
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint
#
# Indexes
#
#  index_arrangements_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :arrangement do
    title { "テスト投稿" }
    context { "これはテスト投稿です" }
    rating { 3 }
    arrange_level { 0 }
    user

    trait :with_after_arrangement_photo do
      after(:build) do |arrangement|
        arrangement.after_arrangement_photo = create(:after_arrangement_photo)
      end
    end

    trait :with_before_arrangement_photo do
      after(:build) do |arrangement|
        arrangement.before_arrangement_photo = create(:before_arrangement_photo)
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
