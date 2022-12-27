require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let(:question1) { create(:question, author: user2) }
  let(:question2) { create(:question, author: user2) }
  let(:question3) { create(:question, author: user2) }

  let(:reward_image) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/files_for_active_storage/reward.png") }

  let(:rewards) do
    [
      create(:reward,
        title: 'Reward 1',
        image: reward_image,
        user: user1,
        question: question1
      ),

      create(:reward,
        title: 'Reward 2',
        image: reward_image,
        user: user1,
        question: question2
      ),

      create(:reward,
        title: 'Reward 3',
        image: reward_image,
        user: user2,
        question: question3
      )
    ]
  end

  describe 'GET #index' do
    context 'with authenticated user' do
      before { login(user1) }
      before { get :index }

      it 'populates an array of all user rewards' do
       expect(assigns(:rewards)).to eq rewards.filter { |r| r.user == user1 }
      end

      it 'render index view' do
        expect(response).to render_template :index
      end
    end

    it 'with not authenticated user' do
      get :index
      expect(response).to redirect_to new_user_session_path
    end
  end
end
