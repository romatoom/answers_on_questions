require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should_not be_able_to :index, Reward }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let!(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    # Questions

    it { should be_able_to :create, Question }

    it { should be_able_to [:update, :destroy], create(:question, author: user) }
    it { should_not be_able_to [:update, :destroy], create(:question, author: other_user) }

    it { should be_able_to :add_comment, Question }

    context 'can?([:like, :dislike], question)' do
      context 'when question author' do
        let(:question) { create(:question, author: user) }
        it { should_not be_able_to [:like, :dislike], question }
      end

      context 'when not question author' do
        let!(:question) { create(:question, author: other_user) }

        describe 'if not votes' do
          it { should be_able_to [:like, :dislike], question }
        end

        describe 'if exist other user vote' do
          let!(:vote) { create(:vote, voteable: question, user: create(:user)) }
          it { should be_able_to [:like, :dislike], question }
        end

        describe 'if exist current user vote' do
          let!(:vote) { create(:vote, voteable: question, user: user) }
          it { should_not be_able_to [:like, :dislike], question }
        end
      end
    end

    context 'can?(:reset_vote, question)' do
      context 'when question author' do
        let(:question) { create(:question, author: user) }
        it { should_not be_able_to :reset_vote, question }
      end

      context 'when not question author' do
        let!(:question) { create(:question, author: other_user) }

        describe 'if not votes' do
          it { should_not be_able_to :reset_vote, question }
        end

        describe 'if exist other user vote' do
          let!(:vote) { create(:vote, voteable: question, user: create(:user)) }
          it { should_not be_able_to :reset_vote, question }
        end

        describe 'if exist current user vote' do
          let!(:vote) { create(:vote, voteable: question, user: user) }
          it { should be_able_to :reset_vote, question }
        end
      end
    end

    # Answers

    it { should be_able_to :create, Answer }

    it { should be_able_to [:update, :destroy], create(:answer, author: user) }
    it { should_not be_able_to [:update, :destroy], create(:answer, author: other_user) }

    it { should be_able_to :add_comment, Answer }

    context 'can?(:mark_answer_as_best, answer)' do
      let(:question) { create(:question, author: user) }

      describe 'when not-best answer' do
        let(:answer) { create(:answer, question: question, author: other_user) }
        it { should be_able_to :mark_answer_as_best, answer }
      end

      describe 'when best answer' do
        let(:answer) { create(:answer, question: question, best: true, author: other_user) }
        it { should_not be_able_to :mark_answer_as_best, answer }
      end

      describe 'when answer for self' do
        let(:answer) { create(:answer, author: user) }
        it { should_not be_able_to :mark_answer_as_best, answer }
      end
    end

    context 'can?([:like, :dislike], answer)' do
      context 'when answer author' do
        let(:answer) { create(:answer, author: user) }
        it { should_not be_able_to [:like, :dislike], answer }
      end

      context 'when not answer author' do
        let!(:answer) { create(:answer, author: other_user) }

        describe 'if not votes' do
          it { should be_able_to [:like, :dislike], answer }
        end

        describe 'if exist other user vote' do
          let!(:vote) { create(:vote, voteable: answer, user: create(:user)) }
          it { should be_able_to [:like, :dislike], answer }
        end

        describe 'if exist current user vote' do
          let!(:vote) { create(:vote, voteable: answer, user: user) }
          it { should_not be_able_to [:like, :dislike], answer }
        end
      end
    end

    context 'can?(:reset_vote, answer)' do
      context 'when answer author' do
        let(:answer) { create(:answer, author: user) }
        it { should_not be_able_to :reset_vote, answer }
      end

      context 'when not answer author' do
        let!(:answer) { create(:answer, author: other_user) }

        describe 'if not votes' do
          it { should_not be_able_to :reset_vote, answer }
        end

        describe 'if exist other user vote' do
          let!(:vote) { create(:vote, voteable: answer, user: create(:user)) }
          it { should_not be_able_to :reset_vote, answer }
        end

        describe 'if exist current user vote' do
          let!(:vote) { create(:vote, voteable: answer, user: user) }
          it { should be_able_to :reset_vote, answer }
        end
      end
    end

    context 'can?(:subscribe, user_subscription)' do
      describe 'when user subscription is new record' do
        it { should be_able_to :subscribe, UsersSubscription.new }
      end

      describe 'when user subscription exist' do
        let!(:user_subscription) { create(:users_subscription) }
        it { should_not be_able_to :subscribe, user_subscription }
      end
    end

    context 'can?(:unsubscribe, user_subscription)' do
      describe 'when user subscription is new record' do
        it { should_not be_able_to :unsubscribe, UsersSubscription.new }
      end

      describe 'when user subscription exist' do
        let!(:user_subscription) { create(:users_subscription) }
        it { should be_able_to :unsubscribe, user_subscription }
      end
    end

    # API V1
    it { should be_able_to [:me, :others], :profile }
  end
end
