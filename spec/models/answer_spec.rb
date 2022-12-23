require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of(:question) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:author) }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
