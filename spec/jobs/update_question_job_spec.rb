require 'rails_helper'

RSpec.describe UpdateQuestionJob, type: :job do
  let(:service) { double(SubscriptionService) }
  let(:question) { create(:question)}

  before do
    allow(SubscriptionService).to receive(:new).and_return(service)
  end

  it 'calls SubscriptionService#question_has_been_changed' do
    expect(service).to receive(:question_has_been_changed).with(question)
    UpdateQuestionJob.perform_now(question)
  end
end
