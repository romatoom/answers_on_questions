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
end
