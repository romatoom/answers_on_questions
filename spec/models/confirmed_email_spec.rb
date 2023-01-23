require 'rails_helper'

RSpec.describe ConfirmedEmail, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :confirmation_token }
end
