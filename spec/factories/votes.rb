FactoryBot.define do
  factory :vote do
    association :user
    value { 1 }

    trait :invalid do
      user { nil }
    end
  end
end
