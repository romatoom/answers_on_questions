require 'rails_helper'

shared_examples_for 'voteable' do
  it { should have_many(:votes).dependent(:destroy) }

  let!(:voteable) { create(described_class.to_s.underscore.to_sym) }

  describe '#votes_sum' do
    it 'check for votes: 1, -1, 1' do
      create(:vote, voteable: voteable, value: 1)
      create(:vote, voteable: voteable, value: -1)
      create(:vote, voteable: voteable, value: 1)

      expect(voteable.votes_sum).to eq 1
    end

    it 'check for votes: -1, -1, 1' do
      create(:vote, voteable: voteable, value: -1)
      create(:vote, voteable: voteable, value: -1)
      create(:vote, voteable: voteable, value: 1)

      expect(voteable.votes_sum).to eq -1
    end

    it 'check for votes, contains null value (1, nil, 1)' do
      create(:vote, voteable: voteable, value: 1)
      create(:vote, voteable: voteable, value: nil)
      create(:vote, voteable: voteable, value: 1)

      expect(voteable.votes_sum).to eq 2
    end
  end
end
