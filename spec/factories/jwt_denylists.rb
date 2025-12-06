FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2025-12-06 18:25:39" }
  end
end
