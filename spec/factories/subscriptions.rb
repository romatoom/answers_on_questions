FactoryBot.define do
  factory :subscription do
    title { "Subscription" }
    slug { "slug" }

    trait :new_answer do
      slug { "new_answer" }
    end

    trait :change_question do
      slug { "change_question" }
    end
  end
end
