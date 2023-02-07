shared_examples_for 'unsubscriptionable' do
  let!(:question) { create(:question) }

  subject(:post_action) do
    post action, params: { id: question.id }
  end

  context 'when user not authorized' do
    before { post_action }

    it 'redirect to sign in page' do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when user authorized' do
    before { login(user) }

    context 'when user not have subscription' do
      it 'not remove subscription' do
        expect { post_action }.to_not change(UsersSubscription, :count)
      end
    end

    context 'when user have subscription' do
      before { create(:users_subscription, user: user, subscription: subscription, question: question) }

      it 'remove subscribe for user' do
        expect { post_action }.to change(UsersSubscription, :count).by(-1)
      end
    end
  end
end

