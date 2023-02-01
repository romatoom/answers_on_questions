FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  sequence :body do |n|
    "MyText#{n}"
  end

  factory :question do
    title
    body
    association :author, factory: :user

    trait :invalid do
      title { nil }
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
