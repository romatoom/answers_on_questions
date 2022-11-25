require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }

  let(:question) { create(:question) }

  let(:answer) { create(:answer) }

  describe 'POST #create' do
    subject(:create_with_valid_attributes) do
      post :create, params: {
        question_id: question.id,
        author_id: user.id,
        answer: attributes_for(:answer)
      }
    end

    subject(:create_with_invalid_attributes) do
      post :create, params: {
        question_id: question.id,
        author_id: user.id,
        answer: attributes_for(:answer, :invalid)
      }
    end

    context 'with authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { create_with_valid_attributes }.to change(Answer, :count).by(1)
        end

        it 'redirects to question show' do
          create_with_valid_attributes
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { create_with_invalid_attributes }.to_not change(Answer, :count)
        end

        it 're-renders new view' do
          create_with_invalid_attributes
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'with unauthenticated user' do
      before { create_with_valid_attributes }

      it 'redirect to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { question_id: question, id: answer } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'DELETE #destroy' do
    before { create_list(:answer, 3) }
    let!(:answer) { create(:answer) }

    subject(:delete_answer) do
      delete :destroy, params: { question_id: question.id, id: answer.id }
    end

    context 'with authenticated user' do
      before { login(user) }

      it 'number of answers decreased by 1' do
        expect { delete_answer }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show' do
        delete_answer
        expect(response).to redirect_to question_path(question)
      end
    end

    it 'with unauthenticated user' do
      expect { delete_answer }.to_not change(Answer, :count)
    end
  end
end
