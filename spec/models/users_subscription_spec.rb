require 'rails_helper'

RSpec.describe UsersSubscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:subscription) }
  it { should belong_to(:question) }
end
