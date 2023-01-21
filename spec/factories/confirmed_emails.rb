FactoryBot.define do
  factory :confirmed_email do
    email { "MyString" }
    provider { "MyString" }
    uid { "MyString" }
    confirmation_token { "MyString" }
  end
end
