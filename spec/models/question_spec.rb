require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }

  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }

  it { should validate_presence_of(:body) }
end
