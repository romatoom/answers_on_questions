FactoryBot.define do
  factory :reward do
    title { "MyString" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/files_for_active_storage/reward.png") }
    user { nil }
    question
  end
end
