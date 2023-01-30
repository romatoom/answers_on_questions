shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      params = {} if !params
      do_request(method, api_path, params: { access_token: 'invalid_access_token' }.merge(params), headers: headers)
      expect(response.status).to eq 401
    end
  end
end
