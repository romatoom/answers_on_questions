require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User').with_foreign_key('author_id') }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of(:question) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:author) }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#mark_as_best' do
    let(:question_author) { create(:user ) }
    let!(:question) { create(:question, author: question_author, reward_attributes: attributes_for(:reward)) }

    let(:answer1_author) { create(:user) }
    let(:answer1) { create(:answer, author: answer1_author, question: question) }

    let(:answer2_author) { create(:user) }
    let(:answer2) { create(:answer, author: answer2_author, question: question) }

    it 'change best answer' do
      answer1.mark_as_best

      expect(answer1.reload.best).to be true
      expect(answer2.reload.best).to be false
      expect(question.reload.reward.user).to eq answer1_author
      expect(answer1_author.reload.rewards).to eq [question.reward]
      expect(answer2_author.reload.rewards).to eq []

      answer2.mark_as_best

      expect(answer1.reload.best).to be false
      expect(answer2.reload.best).to be true
      expect(question.reload.reward.user).to eq answer2_author
      expect(answer2_author.reload.rewards).to eq [question.reward]
      expect(answer1_author.reload.rewards).to eq []
    end
  end

  it_behaves_like 'voteable'
end
