FactoryBot.define do
  factory :answer do
    association :question
    association :author, factory: :user
    body { "MyText" }

    trait :invalid do
      body { nil }
    end
  end
end
