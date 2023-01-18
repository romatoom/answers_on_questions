FactoryBot.define do
  factory :authorization do
    association :user
    provider { "Provider" }
    uid { "123" }
  end
end
