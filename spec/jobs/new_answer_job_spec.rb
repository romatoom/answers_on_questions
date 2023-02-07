require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { double(SubscriptionService) }
  let(:question) { create(:question)}

  before do
    allow(SubscriptionService).to receive(:new).and_return(service)
  end

  it 'calls SubscriptionService#question_got_new_answer' do
    expect(service).to receive(:question_got_new_answer).with(question)
    NewAnswerJob.perform_now(question)
  end
end
