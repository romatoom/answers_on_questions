FactoryBot.define do
  factory :comment do
    commenteable { nil }
    association :author, factory: :user
    body { "This is comment text" }
  end
end
