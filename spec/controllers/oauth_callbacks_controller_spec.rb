require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GitHub' do
    let(:oauth_data) { { 'provider' => 'github', 'uid' => 1 } }

    it 'find user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exist' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Telegram' do
    let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'telegram', uid: 1) }

    it 'find user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :telegram
    end

    context 'user exist' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :telegram
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)

        allow(User).to receive(:find_for_oauth)
        get :telegram
      end

      it 'redirect to confirmed email page' do
        expect(response).to redirect_to new_confirmed_email_path(provider: oauth_data[:provider], uid: oauth_data[:uid])
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end
end
