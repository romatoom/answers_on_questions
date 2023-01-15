require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commenteable }
  it { should belong_to :author }

  it { should validate_presence_of :commenteable }
  it { should validate_presence_of :author }

  describe '#formatted_creation_date' do
    let(:date_of_creation) { Time.current }
    let(:question) { create(:question) }
    let(:comment) { create(:comment, commenteable: question, created_at: date_of_creation) }

    it 'check date formatting' do
      expect(comment.formatted_creation_date).to eq date_of_creation.strftime('%H:%M:%S %d.%m.%Y')
    end
  end
end
