FactoryBot.define do
  factory :comment do
    commenteable { nil }
    association :user
    body { "This is comment text" }
  end
end
