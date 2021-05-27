# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  arrangements_count              :bigint           default(0)
#  avatar_url                      :string           default("/images/default_avatar.png")
#  crypted_password                :string
#  email                           :string           not null
#  likes_count                     :bigint           default(0)
#  nickname                        :string           not null
#  reset_password_email_sent_at    :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  role                            :integer          default("general")
#  salt                            :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_nickname  (nickname) UNIQUE
#
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
        user.arrangements << create_list(:arrangement, evaluator.count, :with_after_arrangement_photo, :with_before_arrangement_photo, :with_parameter)
      end
    end
  end
end
