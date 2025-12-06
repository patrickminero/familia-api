FactoryBot.define do
  factory :profile do
    user
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    timezone { "America/New_York" }
    bio { Faker::Lorem.paragraph }
    notification_preferences do
      {
        email: true,
        push: true,
        sms: false,
      }
    end
    app_preferences do
      {
        theme: "light",
        language: "en",
      }
    end
  end
end
