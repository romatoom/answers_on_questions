require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    {
      "ACCEPT" => "application/json"
    }
  end

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question_id) { 123 }
    let(:api_path) { "/api/v1/questions/#{question_id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question, :with_files, id: question_id) }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns successful status ( 200, 201...)' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answers'].first[attr]).to eq answers.first.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:id) { 123 }
    let(:api_path) { "/api/v1/answers/#{id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, :with_files, id: id) }
      let!(:comments_list) { create_list(:comment, 3, commenteable: answer) }
      let!(:links) { create_list(:link, 4, linkable: answer) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns successful status ( 200, 201...)' do
        expect(response).to be_successful
      end

      it_behaves_like 'API fields checkable' do
        let(:existing_fields) { %w[id body created_at updated_at] }
        let(:not_existing_fields) { [] }
        let(:expectable) { json['answer'] }
        let(:received) { answer }
      end

      it_behaves_like 'API commentable' do
        let(:expecteable) { json['answer']['comments'] }
        let(:received) { answer.comments }
      end

      it_behaves_like 'API fileable' do
        let(:expecteable) { json['answer']['list_of_files'] }
        let(:list_length) { 3 }
      end

      it_behaves_like 'API linkeable' do
        let(:expecteable) { json['answer']['list_of_links'] }
        let(:list_length) { 4 }
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let!(:question_id) { 123 }
    let!(:question) { create(:question, id: question_id) }
    let(:api_path) { "/api/v1/questions/#{question_id}/answers" }

    let!(:links_attributes) do
      [
        { name: 'Google link', url: 'http://google.com', _destroy: false },
        { name: 'VK link', url: 'http://vk.com', _destroy: false },
      ]
    end

    let!(:params) do
      {
        body: 'New answer body',
        links_attributes: links_attributes
      }
    end

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }

      context 'when create success' do
        before do
          post api_path,
            params: {
              answer: params,
              access_token: access_token.token
            },
            headers: headers
        end

        it 'returns successful status ( 200, 201...)' do
          expect(response).to be_successful
        end

        it_behaves_like 'API create/update linkeable' do
          let(:expectable) { json['answer'] }
          let(:received) { question.answers.first }
          let(:count_of_links) { 2 }
          let(:fields) { %w[id body created_at updated_at] }
        end
      end

      context 'errors when create' do
        before { post api_path, params: { access_token: access_token.token, answer: { body: nil} }, headers: headers }

        it 'response with unprocessable entity status' do
          expect(response.status).to eq 422
        end

        it 'returns errors' do
          expect(json['errors']).to eq ["Body can't be blank"]
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:id) { 123 }
    let!(:answer) { create(:answer, id: id) }
    let!(:links) { create_list(:link, 2, linkable: answer) }

    let(:api_path) { "/api/v1/answers/#{id}" }

    let!(:links_attributes) do
      [
        { id: links.first.id, name: 'New Google link', url: 'http://google-new.com', _destroy: false },
        { id: links.second.id, name: 'New VK link', url: 'http://vk-new.com', _destroy: true },
      ]
    end

    let!(:params) do
      {
        body: 'Updated answer body',
        links_attributes: links_attributes
      }
    end

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }

      context 'when update success' do
        before do
          patch api_path,
            params: {
              answer: params,
              access_token: access_token.token
            },
            headers: headers
        end

        it 'returns successful status ( 200, 201...)' do
          expect(response).to be_successful
        end

        it_behaves_like 'API create/update linkeable' do
          let(:expectable) { json['answer'] }
          let(:received) { answer.reload }
          let(:count_of_links) { 1 }
          let(:fields) { %w[id body created_at updated_at] }
        end
      end

      context 'errors when update' do
        before { patch api_path, params: { access_token: access_token.token, answer: { body: nil } }, headers: headers }

        it 'response with unprocessable entity status' do
          expect(response.status).to eq 422
        end

        it 'returns error' do
          expect(json['errors']).to eq ["Body can't be blank"]
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:id) { 123 }
    let!(:answer) { create(:answer, id: id) }

    let(:api_path) { "/api/v1/answers/#{id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }

      context 'when delete success' do
        describe 'check request' do
          before do
            delete api_path,
              params: {
                access_token: access_token.token
              },
              headers: headers
          end

          it 'returns successful status ( 200, 201...)' do
            expect(response).to be_successful
          end

          it 'returns removed answer' do
            %w[id body created_at updated_at].each do |attr|
              expect(json['answer'][attr]).to eq answer.send(attr).as_json
            end
          end
        end

        it 'answer has been removed' do
          expect do
            delete api_path,
              params: {
                access_token: access_token.token
              },
              headers: headers
          end.to change { Answer.count }.from(1).to(0)
        end
      end
    end
  end
end
