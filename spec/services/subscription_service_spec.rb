require 'rails_helper'

RSpec.describe SubscriptionService do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:subscription_new_answer) { create(:subscription, :new_answer) }
  let!(:subscription_change_question) { create(:subscription, :change_question) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  subject { SubscriptionService.new }

  describe '#create_subscription_for_user' do
    context 'when user not have subscription' do
      it 'add subscription to user' do
        expect do
          subject.create_subscription_for_user(
            user: user,
            subscription_slug: "change_question",
            question: question
          )
        end.to change { UsersSubscription.count }.from(0).to(1)

        user_subscription = user.users_subscriptions.last
        expect(user_subscription.subscription).to eq subscription_change_question
        expect(user_subscription.question).to eq question
        expect(user_subscription.user).to eq user
      end
    end

    context 'when user have subscription' do
      before { create(:users_subscription, user: user, subscription: subscription_change_question, question: question) }

      it 'do not add subscription to user' do
        expect do
          subject.create_subscription_for_user(
            user: user,
            subscription_slug: "change_question",
            question: question
          )
        end.to_not change { UsersSubscription.count }
      end
    end
  end

  describe '#remove_subscription_for_user' do
    context 'when user not have subscription' do
      it 'do not remove user subscription' do
        expect do
          subject.remove_subscription_for_user(
            user: user,
            subscription_slug: "change_question",
            question: question
          )
        end.to_not change { UsersSubscription.count }
      end
    end

    context 'when user have subscription' do
      before { create(:users_subscription, user: user, subscription: subscription_change_question, question: question) }

      it 'remove user subscription' do
        expect do
          subject.remove_subscription_for_user(
            user: user,
            subscription_slug: "change_question",
            question: question
          )
        end.to change { UsersSubscription.count }.from(1).to(0)
      end
    end
  end

  describe '#question_got_new_answer' do
    before do
      create(:users_subscription, user: user, subscription: subscription_new_answer, question: question)
      create(:users_subscription, user: other_user, subscription: subscription_new_answer, question: question)
    end

    it 'sends notification about new answer to all users' do
      UsersSubscription.all.each { |user_subscription| expect(NotificationMailer).to receive(:notify_about_new_answer_for_question).with(user_subscription.user, user_subscription.question).and_call_original }
      subject.question_got_new_answer(question)
    end
  end

  describe '#question_has_been_changed' do
    before do
      create(:users_subscription, user: user, subscription: subscription_change_question, question: question)
      create(:users_subscription, user: other_user, subscription: subscription_change_question, question: question)
    end

    it 'sends notification about update question to all users' do
      UsersSubscription.all.each { |user_subscription| expect(NotificationMailer).to receive(:notify_about_change_question).with(user_subscription.user, user_subscription.question).and_call_original }
      subject.question_has_been_changed(question)
    end
  end
end
