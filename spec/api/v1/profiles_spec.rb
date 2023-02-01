require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    {
      "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns successful status ( 200, 201...)' do
        expect(response).to be_successful
      end

      it_behaves_like 'API fields checkable' do
        let(:existing_fields) { %w[id email admin created_at updated_at] }
        let(:not_existing_fields) { %w[password encrypted_password] }
        let(:expectable) { json['user'] }
        let(:received) { me }
      end
    end
  end

  describe 'GET /api/v1/profiles/others' do
    let(:api_path) { '/api/v1/profiles/others' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:other_profiles) { create_list(:user, 3) }
      let(:profile) { other_profiles.first }
      let(:profile_reponse) { json['users'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns successful status ( 200, 201...)' do
        expect(response).to be_successful
      end

      it 'returns list of profiles' do
        expect(json['users'].size).to eq 3
      end

      it_behaves_like 'API fields checkable' do
        let(:existing_fields) { %w[id email admin created_at updated_at] }
        let(:not_existing_fields) { %w[password encrypted_password] }
        let(:expectable) { profile_reponse }
        let(:received) { profile }
      end
    end
  end
end
