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

    context 'when voteable not have user vote' do
      it 'not question author can vote' do
        expect(not_author.can_vote?(question)).to eq true
      end

      it 'not answer author can vote' do
        expect(not_author.can_vote?(answer)).to eq true
      end
    end

    context 'when voteable have user vote' do
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

  describe '#can_revote?' do
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, author: author) }

    it 'question author can not vote' do
      expect(author.can_revote?(question)).to eq false
    end

    it 'answer author can not vote' do
      expect(author.can_revote?(answer)).to eq false
    end

    context 'when voteable not have user vote' do
      it 'not question author can vote' do
        expect(not_author.can_revote?(question)).to eq false
      end

      it 'not answer author can vote' do
        expect(not_author.can_revote?(answer)).to eq false
      end
    end

    context 'when voteable have user vote' do
      before do
        create(:vote, user: not_author, voteable: question)
        create(:vote, user: not_author, voteable: answer)
      end

      it 'not question author can reset vote' do
        expect(not_author.can_revote?(question)).to eq true
      end

      it 'not answer author can reset vote' do
        expect(not_author.can_revote?(answer)).to eq true
      end
    end
  end

  describe '#like?' do
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, author: author) }

    context 'when voteable not have user vote' do
      it 'user like question is nil' do
        expect(not_author.like?(question)).to be nil
      end

      it 'user like answer is nil' do
        expect(not_author.like?(answer)).to be nil
      end
    end

    context 'when voteable have user like' do
      before do
        create(:vote, user: not_author, voteable: question, value: 1)
        create(:vote, user: not_author, voteable: answer, value: 1)
      end

      it 'user like question' do
        expect(not_author.like?(question)).to be true
      end

      it 'user like answer' do
        expect(not_author.like?(answer)).to be true
      end
    end

    context 'when voteable have user dislike' do
      before do
        create(:vote, user: not_author, voteable: question, value: -1)
        create(:vote, user: not_author, voteable: answer, value: -1)
      end

      it 'user not like question' do
        expect(not_author.like?(question)).to be false
      end

      it 'user not like answer' do
        expect(not_author.like?(answer)).to be false
      end
    end
  end

  describe '#dislike?' do
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, author: author) }

    context 'when voteable not have user vote' do
      it 'user dislike question is nil' do
        expect(not_author.dislike?(question)).to be nil
      end

      it 'user dislike answer is nil' do
        expect(not_author.dislike?(answer)).to be nil
      end
    end

    context 'when voteable have user dislike' do
      before do
        create(:vote, user: not_author, voteable: question, value: -1)
        create(:vote, user: not_author, voteable: answer, value: -1)
      end

      it 'user dislike question' do
        expect(not_author.dislike?(question)).to be true
      end

      it 'user dislike answer' do
        expect(not_author.dislike?(answer)).to be true
      end
    end

    context 'when voteable have user like' do
      before do
        create(:vote, user: not_author, voteable: question, value: 1)
        create(:vote, user: not_author, voteable: answer, value: 1)
      end

      it 'user not dislike question' do
        expect(not_author.dislike?(question)).to be false
      end

      it 'user not dislike answer' do
        expect(not_author.dislike?(answer)).to be false
      end
    end
  end
end
