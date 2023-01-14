require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commenteable }
  it { should belong_to :user }

  it { should validate_presence_of :commenteable }
  it { should validate_presence_of :user }
end
