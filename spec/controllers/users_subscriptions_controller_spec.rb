require 'rails_helper'

RSpec.describe UsersSubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:subscription_slug) { "subscription_slug" }
  let!(:subscription) { create(:subscription, slug: subscription_slug) }
  let!(:question) { create(:question) }

  describe '#create' do
    def perform(params = {})
      post :create, params: params
    end

    context 'when user not authorized' do
      before { perform }

      it 'redirect to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user authorized' do
      before { login(user) }

      context 'when user not have subscription' do
        it 'add correct subscribe for user' do
          expect { perform(question_id: question.id, subscription_slug: subscription_slug) }.to change(UsersSubscription, :count).by(1)
          users_subscription = UsersSubscription.last
          expect(users_subscription.user).to eq(user)
          expect(users_subscription.question).to eq(question)
          expect(users_subscription.subscription).to eq(subscription)
        end
      end

      context 'when user have subscription' do
        before { create(:users_subscription, user: user, subscription: subscription, question: question) }

        it 'not add new subscription' do
          expect { perform(question_id: question.id, subscription_slug: subscription_slug) }.to_not change(UsersSubscription, :count)
        end
      end
    end
  end

  describe '#destroy' do
    let!(:user_subscription) { create(:users_subscription, user: user, subscription: subscription, question: question) }

    def perform(id:)
      delete :destroy, params: { id: id }
    end

    context 'when user not authorized' do
      it 'redirect to sign in page' do
        perform(id: user_subscription.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user authorized' do
      it 'remove subscribe for user' do
        login(user)
        expect { perform(id: user_subscription.id) }.to change(UsersSubscription, :count).by(-1)
      end
    end
  end
end
