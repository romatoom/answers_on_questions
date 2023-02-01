FactoryBot.define do
  factory :answer do
    association :question
    association :author, factory: :user
    body { "MyText" }

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      files do
        [ Rack::Test::UploadedFile.new("#{Rails.root}/spec/files_for_active_storage/file-1.txt"),
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/files_for_active_storage/file-2.txt"),
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/files_for_active_storage/file-3.txt") ]
      end
    end
  end
end
