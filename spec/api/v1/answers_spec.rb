require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    {
      "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }
  end

  describe 'GET /api/v1/questions/:id/answers' do
    let(:id) { 123 }
    let(:api_path) { "/api/v1/questions/#{id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question, :with_files, id: id) }
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

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        it 'returns list of comments' do
          expect(json['answer']['comments'].size).to eq 3
        end

        it 'returns fields for comment' do
          %w[id body created_at updated_at].each do |attr|
            expect(json['answer']['comments'].first[attr]).to eq answer.comments.first.send(attr).as_json
          end
        end

        it 'contains author of comment (user object)' do
          %w[id email admin created_at updated_at].each do |attr|
            expect(json['answer']['comments'].first['author'][attr]).to eq answer.comments.first.author.send(attr).as_json
          end
        end
      end

      describe 'files' do
        it 'contains list of attached files' do
          expect(json['answer']['list_of_files'].size).to eq 3
        end

        it 'returns filename and url' do
          %w[name url].each do |attr|
            expect(json['answer']['list_of_files'].first).to have_key(attr)
          end
        end
      end

      describe 'links' do
        it 'contains list of attached files' do
          expect(json['answer']['list_of_links'].size).to eq 4
        end

        it 'returns filename and url' do
          %w[name url].each do |attr|
            expect(json['answer']['list_of_links'].first).to have_key(attr)
          end
        end
      end
    end
  end
end
