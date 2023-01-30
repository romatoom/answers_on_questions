require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    {
      "ACCEPT" => "application/json"
    }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_reponse) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns successful status ( 200, 201...)' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields (without author_id)' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_reponse[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(question_reponse['author'][attr]).to eq question.author.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:id) { 123 }
    let(:api_path) { "/api/v1/questions/#{id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question, :with_files, id: id) }
      let!(:comments_list) { create_list(:comment, 3, commenteable: question) }
      let!(:links) { create_list(:link, 4, linkable: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns successful status ( 200, 201...)' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        it 'returns list of comments' do
          expect(json['question']['comments'].size).to eq 3
        end

        it 'returns fields for comment' do
          %w[id body created_at updated_at].each do |attr|
            expect(json['question']['comments'].first[attr]).to eq question.comments.first.send(attr).as_json
          end
        end

        it 'contains author of comment (user object)' do
          %w[id email admin created_at updated_at].each do |attr|
            expect(json['question']['comments'].first['author'][attr]).to eq question.comments.first.author.send(attr).as_json
          end
        end
      end

      describe 'files' do
        it 'contains list of attached files' do
          expect(json['question']['list_of_files'].size).to eq 3
        end

        it 'returns filename and url' do
          %w[name url].each do |attr|
            expect(json['question']['list_of_files'].first).to have_key(attr)
          end
        end
      end

      describe 'links' do
        it 'contains list of attached files' do
          expect(json['question']['list_of_links'].size).to eq 4
        end

        it 'returns id, name and url' do
          %w[id name url].each do |attr|
            expect(json['question']['list_of_links'].first).to have_key(attr)
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { "/api/v1/questions" }

    let!(:links_attributes) do
      [
        { name: 'Google link', url: 'http://google.com', _destroy: false },
        { name: 'VK link', url: 'http://vk.com', _destroy: false },
      ]
    end

    let!(:params) do
      {
        title: 'New question title',
        body: 'New question body',
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
              question: params,
              access_token: access_token.token
            },
            headers: headers
        end

        it 'returns successful status ( 200, 201...)' do
          expect(response).to be_successful
        end

        describe 'returns created question' do
          it 'returns public fields' do
            %w[id title body created_at].each do |attr|
              expect(json['question']).to have_key(attr)
            end
          end

          describe 'return links' do
            it 'returns list of links' do
              expect(json['question']['list_of_links'].size).to eq 2
            end

            it 'returns name and url for link' do
              %w[name url].each do |attr|
                expect(json['question']['list_of_links'].first[attr]).to eq links_attributes.first[attr.to_sym]
              end
            end
          end
        end
      end

      context 'errors when create' do
        before { post api_path, params: { access_token: access_token.token, question: { title: nil} }, headers: headers }

        it 'response with unprocessable entity status' do
          expect(response.status).to eq 422
        end

        it 'returns errors' do
          expect(json['errors']).to eq ["Title can't be blank", "Body can't be blank"]
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:id) { 123 }
    let!(:question) { create(:question, id: id) }
    let!(:links) { create_list(:link, 2, linkable: question) }

    let(:api_path) { "/api/v1/questions/#{id}" }

    let!(:links_attributes) do
      [
        { id: links.first.id, name: 'New Google link', url: 'http://google-new.com', _destroy: false },
        { id: links.second.id, name: 'New VK link', url: 'http://vk-new.com', _destroy: true },
      ]
    end

    let!(:params) do
      {
        title: 'Updated question title',
        body: 'Updated question body',
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
              question: params,
              access_token: access_token.token
            },
            headers: headers
        end

        it 'returns successful status ( 200, 201...)' do
          expect(response).to be_successful
        end

        describe 'returns updated question' do
          it 'returns updated public fields' do
            question.reload
            %w[id title body created_at updated_at].each do |attr|
              expect(json['question'][attr]).to eq question.send(attr).as_json
            end
          end

          describe 'return updated links' do
            it 'returns list of links (second link has been removed)' do
              expect(json['question']['list_of_links'].size).to eq 1
            end

            it 'returns name and url for link' do
              %w[id name url].each do |attr|
                expect(json['question']['list_of_links'].first[attr]).to eq links_attributes.first[attr.to_sym]
              end
            end
          end
        end
      end

      context 'errors when update' do
        before { patch api_path, params: { access_token: access_token.token, question: { title: nil } }, headers: headers }

        it 'response with unprocessable entity status' do
          expect(response.status).to eq 422
        end

        it 'returns error' do
          expect(json['errors']).to eq ["Title can't be blank"]
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:id) { 123 }
    let!(:question) { create(:question, id: id) }

    let(:api_path) { "/api/v1/questions/#{id}" }

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

          it 'returns removed question' do
            %w[id title body created_at updated_at].each do |attr|
              expect(json['question'][attr]).to eq question.send(attr).as_json
            end
          end
        end

        it 'question has been removed' do
          expect do
            delete api_path,
              params: {
                access_token: access_token.token
              },
              headers: headers
          end.to change { Question.count }.from(1).to(0)
        end
      end
    end
  end
end
