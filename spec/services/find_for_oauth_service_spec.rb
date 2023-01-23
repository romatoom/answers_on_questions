require 'rails_helper'

RSpec.describe FindForOauthService do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1') }

  subject { FindForOauthService.new(auth) }

  context 'user already has authorization' do
    it 'return user' do
      user.authorizations.create(provider: 'facebook', uid: '1')
      expect(subject.call).to eq user
    end
  end

  context 'user has not authorization' do
    context "auth don't have info about email" do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1', info: {}) }

      it 'return nil' do
        expect(subject.call).to be_nil
      end
    end

    context 'user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1', info: { email: user.email }) }

      it 'does not create new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'create authorization for user' do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1', info: { email: 'new@user.com' }) }

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(subject.call).to be_a(User)
      end

      it 'fills user email' do
        user = subject.call
        expect(user.email).to eq auth.info.email
      end

      it 'creates authorization for user' do
        user = subject.call
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
