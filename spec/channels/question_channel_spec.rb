require 'rails_helper'

RSpec.describe QuestionChannel, type: :channel do
  let(:question_id) { rand(100) }

  it "successfully subscribes" do
    subscribe(question_id: question_id)
    expect(subscription).to be_confirmed
    expect(subscription.streams).to eq ["question_channel_#{question_id}"]
  end
end
