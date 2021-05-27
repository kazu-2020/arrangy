# == Schema Information
#
# Table name: comments
#
#  id             :bigint           not null, primary key
#  body           :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  arrangement_id :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_comments_on_arrangement_id  (arrangement_id)
#  index_comments_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (arrangement_id => arrangements.id)
#  fk_rails_...  (user_id => users.id)
#
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
