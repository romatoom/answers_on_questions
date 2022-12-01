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
        answer: attributes_for(:answer),
        format: :js
      }
    end

    subject(:create_with_invalid_attributes) do
      post :create, params: {
        question_id: question.id,
        author_id: user.id,
        answer: attributes_for(:answer, :invalid),
        format: :js
      }
    end

    context 'with authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { create_with_valid_attributes }.to change(Answer, :count).by(1)
        end

        it 'render create view' do
          create_with_valid_attributes
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { create_with_invalid_attributes }.to_not change(Answer, :count)
        end

        it 'render create view' do
          create_with_invalid_attributes
          expect(response).to render_template :create
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

  describe 'PATCH #update' do
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }

    let!(:answer_of_author) { create(:answer, author: author) }

    subject(:update) do
      patch :update, params: {
        question_id: answer_of_author.question,
        id: answer_of_author,
        answer: { body: "New body" },
        format: :js
      }
    end

    subject(:update_with_invalid_attributes) do
      patch :update, params: {
        question_id: answer_of_author.question,
        id: answer_of_author,
        answer: attributes_for(:answer, :invalid),
        format: :js
      }
    end

    context 'with answer author' do
      before { login(author) }

      context 'with valid attributes' do
        before { update }

        it 'change answer attributes' do
          answer_of_author.reload

          expect(answer_of_author.body).to eq 'New body'
        end

        it 'render update view' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'not change answer attributes' do
          expect { update_with_invalid_attributes }.to_not change { answer_of_author.reload.body }
        end

        it 'render update view' do
          update_with_invalid_attributes
          expect(response).to render_template :update
        end
      end
    end

    context 'with not answer author' do
      before { login(not_author) }

      it 'not changes the answer attributes' do
        expect { update }.to_not change { answer_of_author.reload.body }
      end
    end

    context 'with not-autorized user' do
      it 'not changes the answer attributes' do
        expect { update }.to_not change { answer_of_author.reload.body }
      end
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
