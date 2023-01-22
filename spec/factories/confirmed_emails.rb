FactoryBot.define do
  factory :confirmed_email do
    email { "mail@example.com" }
    provider { "telegram" }
    uid { 1 }
    confirmation_token { "Confirnation_token" }
  end
end
