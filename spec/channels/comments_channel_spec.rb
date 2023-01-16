require 'rails_helper'

RSpec.describe CommentsChannel, type: :channel do
  it "successfully subscribes" do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription.streams).to eq ["comments_channel"]
  end
end
