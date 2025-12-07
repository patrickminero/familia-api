# spec/factories/profiles.rb

FactoryBot.define do
  factory :profile do
    association :user
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
    timezone { "UTC" }
    bio { Faker::Lorem.sentence }

    # Trait for minimal profile
    trait :minimal do
      name { "Test User" }
      phone { nil }
      bio { nil }
    end
  end
end
