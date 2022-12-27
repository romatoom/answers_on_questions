require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:user).optional(true) }
  it { should belong_to(:question) }

  it 'has one attached file' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it { should validate_presence_of(:question) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:image) }

end

