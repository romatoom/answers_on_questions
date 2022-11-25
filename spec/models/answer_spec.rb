require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }

  it { should validate_presence_of(:question) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:author) }
end
