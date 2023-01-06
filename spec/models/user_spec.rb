require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }

    let(:question) { create(:question, author: author) }
    let(:answer) { create(:answer, author: author) }

    context 'when author' do
      it 'of question' do
        expect(author.author_of?(question)).to be true
      end

      it 'of answer' do
        expect(author.author_of?(answer)).to be true
      end
    end

    context 'when not author' do
      it 'of question' do
        expect(not_author.author_of?(question)).to be false
      end

      it 'of answer' do
        expect(not_author.author_of?(answer)).to be false
      end
    end
  end

  describe '#can_vote?' do
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, author: author) }

    it 'question author can not vote' do
      expect(author.can_vote?(question)).to eq false
    end

    it 'answer author can not vote' do
      expect(author.can_vote?(answer)).to eq false
    end

    context 'when voteable not have user votes' do
      it 'not question author can vote' do
        expect(not_author.can_vote?(question)).to eq true
      end

      it 'not answer author can vote' do
        expect(not_author.can_vote?(answer)).to eq true
      end
    end

    context 'when voteable have user votes' do
      before do
        create(:vote, user: not_author, voteable: question)
        create(:vote, user: not_author, voteable: answer)
      end

      it 'not question author can not vote again' do
        expect(not_author.can_vote?(question)).to eq false
      end

      it 'not answer author can not vote again' do
        expect(not_author.can_vote?(answer)).to eq false
      end
    end

  end
end
