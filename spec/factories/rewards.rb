FactoryBot.define do
  factory :reward do
    association :question
    title { "MyString" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/files_for_active_storage/reward.png") }
    association :user
  end
end
