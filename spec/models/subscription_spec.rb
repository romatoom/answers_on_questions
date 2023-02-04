require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should have_many(:users_subscriptions).dependent(:destroy) }
  it { should have_many(:users).through(:users_subscriptions) }

  it { should validate_presence_of(:title) }

  describe 'validate slug' do
    subject { build(:subscription) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug) }
  end
end
