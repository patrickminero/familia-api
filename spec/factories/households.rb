FactoryBot.define do
  factory :household do
    user { create(:user, :with_profile) }
    name { "#{Faker::Name.last_name} Family" }
  end
end
