require 'rails_helper'

RSpec.describe UsersSubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:subscription_slug) { "subscription_slug" }
  let!(:question) { create(:question) }

  describe '#subscribe' do
    let!(:subscription) { create(:subscription, slug: subscription_slug) }

    subject(:subscribe) do
      post :subscribe, params: { question_id: question.id, subscription_slug: subscription_slug }
    end

    context 'when user not authorized' do
      before { subscribe }

      it 'redirect to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user authorized' do
      before { login(user) }

      context 'when user not have subscription' do
        it 'add correct subscribe for user' do
          expect { subscribe }.to change(UsersSubscription, :count).by(1)
          users_subscription = UsersSubscription.last
          expect(users_subscription.user).to eq(user)
          expect(users_subscription.question).to eq(question)
          expect(users_subscription.subscription).to eq(subscription)
        end
      end

      context 'when user have subscription' do
        before { create(:users_subscription, user: user, subscription: subscription, question: question) }

        it 'not add new subscription' do
          expect { subscribe }.to_not change(UsersSubscription, :count)
        end
      end
    end
  end

  describe '#unsubscribe' do
    let!(:subscription) { create(:subscription, slug: subscription_slug) }

    subject(:unsubscribe) do
      post :unsubscribe, params: { question_id: question.id, subscription_slug: subscription_slug }
    end

    context 'when user not authorized' do
      before { unsubscribe }

      it 'redirect to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user authorized' do
      before { login(user) }

      context 'when user not have subscription' do
        it 'not remove subscription' do
          expect { unsubscribe }.to_not change(UsersSubscription, :count)
        end
      end

      context 'when user have subscription' do
        before { create(:users_subscription, user: user, subscription: subscription, question: question) }

        it 'remove subscribe for user' do
          expect { unsubscribe }.to change(UsersSubscription, :count).by(-1)
        end
      end
    end
  end
end
