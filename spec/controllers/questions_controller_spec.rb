require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #new' do
    context 'with authenticated user' do
      before { login(user) }

      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'with unauthenticated user' do
      before { get :new }

      it 'redirect to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    let(:answers) { create_list(:answer)}

    before { get :show, params: { id: question.id } }

    it 'assigns a requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    let!(:user) { create(:user) }

    subject(:create_with_valid_attributes) do
      post :create, params: { question: attributes_for(:question) }
    end

    subject(:create_with_invalid_attributes) do
      post :create, params: { question: attributes_for(:question, :invalid) }
    end

    context 'with authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { create_with_valid_attributes }.to change(Question, :count).by(1)
        end

        it 'redirects to new question answer view' do
          create_with_valid_attributes
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { create_with_invalid_attributes }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          create_with_invalid_attributes
          expect(response).to render_template :new
        end
      end
    end

    context 'with unauthenticated user' do
      it 'redirect to sign in page' do
        create_with_valid_attributes
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to eq questions
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'DELETE #destroy' do
    before { create_list(:question, 3) }
    let!(:question) { create(:question) }

    subject(:delete_question) { delete :destroy, params: { id: question.id } }

    context 'with authenticated user' do
      before { login(user) }

      it 'number of questions decreased by 1' do
        expect { delete_question }.to change(Question, :count).by(-1)
      end

      it 'redirect to questions show' do
        delete_question
        expect(response).to redirect_to questions_path
      end
    end

    it 'with unauthenticated user' do
      expect { delete_question }.to_not change(Question, :count)
    end
  end
end
