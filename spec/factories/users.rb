FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password123" }

    trait :with_profile do
      after(:create) do |user|
        create(:profile, user: user)
      end
    end
  end
end
