require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:search_service) { double(SearchService) }
    let(:query) { "Find me" }

    def perform(params = {})
      get :index, params: params
    end

    context 'search by questions' do
      let(:params) do
        {
          query: query,
          search_questions: "1"
        }
      end

      let!(:user1) { create(:user, email: 'test1@mail.ru') }
      let!(:user2) { create(:user, email: 'test2@mail.ru') }
      let!(:question1) { create(:question, title: 'You find me?') }
      let!(:question2) { create(:question, body: 'Yes. You find me again!') }
      let!(:answer) { create(:answer, body: 'You can not find me') }
      let!(:comment) { create(:comment, commenteable: answer, body: 'You can not find me') }

      it_behaves_like 'searcheable' do
        let(:count_results) { 2 }
      end
    end

    context 'search by answers' do
      let(:params) do
        {
          query: query,
          search_answers: "1"
        }
      end

      let!(:user1) { create(:user, email: 'test1@mail.ru') }
      let!(:user2) { create(:user, email: 'test2@mail.ru') }
      let!(:answer1) { create(:answer, body: 'Try find me') }
      let!(:answer2) { create(:answer, body: 'Try find me again!') }
      let!(:question1) { create(:question, body: 'You can not find me') }
      let!(:question2) { create(:question, title: 'You can not find me') }
      let!(:comment) { create(:comment, commenteable: question1, body: 'You can not find me') }

      it_behaves_like 'searcheable' do
        let(:count_results) { 2 }
      end
    end

    context 'search by users' do
      let!(:query) { 'test1@mail.ru' }
      let(:params) do
        {
          query: query,
          search_users: "1"
        }
      end

      let!(:user1) { create(:user, email: 'test1@mail.ru') }
      let!(:user2) { create(:user, email: 'test2@mail.ru') }
      let!(:answer) { create(:answer, body: 'You can not find me') }
      let!(:question1) { create(:question, body: 'You can not find me') }
      let!(:question2) { create(:question, title: 'You can not find me') }
      let!(:comment) { create(:comment, commenteable: question1, body: 'You can not find me') }

      it_behaves_like 'searcheable' do
        let(:count_results) { 1 }
      end
    end

    context 'search by comments' do
      let(:params) do
        {
          query: query,
          search_comments: "1"
        }
      end

      let!(:user1) { create(:user, email: 'test1@mail.ru') }
      let!(:user2) { create(:user, email: 'test2@mail.ru') }
      let!(:answer) { create(:answer, body: 'You can not find me') }
      let!(:question1) { create(:question, body: 'You can not find me') }
      let!(:question2) { create(:question, title: 'You can not find me') }
      let!(:comment1) { create(:comment, commenteable: question1, body: 'Try find me') }
      let!(:comment2) { create(:comment, commenteable: question2, body: 'Try find me again!') }

      it_behaves_like 'searcheable' do
        let(:count_results) { 2 }
      end
    end

    context 'search by all' do
      let(:params) do
        {
          query: query,
          search_questions: "1",
          search_answers: "1",
          search_users: "1",
          search_comments: "1"
        }
      end

      let!(:user1) { create(:user, email: 'test1@mail.ru') }
      let!(:user2) { create(:user, email: 'test2@mail.ru') }
      let!(:answer) { create(:answer, body: 'Try find me 1') }
      let!(:question1) { create(:question, body: 'Try find me 2') }
      let!(:question2) { create(:question, title: 'Try find me 3') }
      let!(:comment1) { create(:comment, commenteable: question1, body: 'Try find me 4') }
      let!(:comment2) { create(:comment, commenteable: question2, body: 'Try find me again 5') }

      it_behaves_like 'searcheable' do
        let(:count_results) { 5 }
      end
    end

    context 'search user email by all' do
      let!(:query) { 'test1@mail.ru' }

      let(:params) do
        {
          query: query,
          search_questions: "1",
          search_answers: "1",
          search_users: "1",
          search_comments: "1"
        }
      end

      let!(:user1) { create(:user, email: 'test1@mail.ru') }
      let!(:user2) { create(:user, email: 'test2@mail.ru') }
      let!(:answer1) { create(:answer, body: 'You can not find me') }
      let!(:answer2) { create(:answer, body: 'You can find me!', author: user1) }
      let!(:question1) { create(:question, body: 'You can not find me') }
      let!(:question2) { create(:question, title: 'You can find me!', author: user1) }
      let!(:comment1) { create(:comment, commenteable: question1, body: 'Try find me') }
      let!(:comment2) { create(:comment, commenteable: question2, body: 'You can find me!', author: user1) }

      it_behaves_like 'searcheable' do
        let(:count_results) { 4 }
      end
    end
  end
end
