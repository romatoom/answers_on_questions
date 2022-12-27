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

  describe 'mark_as_best method' do
    before(:each) do
      @question_author = User.create!(email: "question_author@gmail.com", password: "Password")
      @question = @question_author.questions.create!(title: "@question title", body: "@question body")

      @reward = Reward.create!(
        question_id: @question.id,
        title: "reward title",
        image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/files_for_active_storage/reward.png")
      )

      @answer1_author = User.create!(email: "answer1_author@gmail.com", password: "Password")
      @answer1 = @answer1_author.answers.create!(body: "Answer body 1", question_id: @question.id)

      @answer2_author = User.create!(email: "answer2_author@gmail.com", password: "Password")
      @answer2 = @answer2_author.answers.create!(body: "Answer body 2", question_id: @question.id)
    end

    after(:each) do
      @question_author.destroy
      @answer1_author.destroy
      @answer2_author.destroy
    end

    it 'change best answer' do
      @answer1.mark_as_best

      expect(@answer1.reload.best).to be true
      expect(@answer2.reload.best).to be false
      expect(@question.reload.reward.user).to eq @answer1_author
      expect(@answer1_author.reload.rewards).to eq [@reward]
      expect(@answer2_author.reload.rewards).to eq []

      @answer2.mark_as_best

      expect(@answer1.reload.best).to be false
      expect(@answer2.reload.best).to be true
      expect(@question.reload.reward.user).to eq @answer2_author
      expect(@answer2_author.reload.rewards).to eq [@reward]
      expect(@answer1_author.reload.rewards).to eq []
    end
  end
end
