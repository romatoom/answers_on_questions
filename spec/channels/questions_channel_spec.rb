require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  it "successfully subscribes" do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription.streams).to be eq ["questions_channel"]
  end
end
