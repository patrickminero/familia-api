# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    # Trait to create user with profile (using association)
    trait :with_profile do
      after(:create) do |user|
        create(:profile, user: user)
      end
    end

    # Trait to create user with nested profile attributes
    trait :with_nested_profile do
      after(:build) do |user|
        user.profile_attributes = { name: "Test User" }
      end
    end

    # Trait with custom profile name
    trait :with_named_profile do
      transient do
        profile_name { "John Doe" }
      end

      after(:create) do |user, evaluator|
        create(:profile, user: user, name: evaluator.profile_name)
      end
    end
  end
end
