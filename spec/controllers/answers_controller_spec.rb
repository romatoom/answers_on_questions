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
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }

    let!(:answer) { create(:answer, author: author) }

    before { create_list(:answer, 3, author: author) }

    subject(:delete_answer) do
      delete :destroy, params: { question_id: question.id, id: answer.id, format: :js }
    end

    context 'with author of answer' do
      before { login(author) }

      it 'number of answers decreased by 1' do
        expect { delete_answer }.to change(Answer, :count).by(-1)
      end

      it 'render view destroy' do
        delete_answer
        expect(response).to render_template :destroy
      end
    end

    context 'with not author of answer' do
      before { login(not_author) }

      it 'number of answers not change' do
        expect { delete_answer }.to_not change(Answer, :count)
      end
    end

    it 'with unauthenticated user' do
      expect { delete_answer }.to_not change(Answer, :count)
    end
  end

  describe 'POST #mark_best_answer' do
    let!(:author) { create(:user) }
    let!(:not_author) { create(:user) }

    let!(:question_of_author) { create(:question, author: author) }
    let!(:answer1) { create(:answer, question: question_of_author) }
    let!(:answer2) { create(:answer, question: question_of_author) }

    subject(:mark_best_answer) do
      post :mark_answer_as_best, params: { id: answer1.id, format: :js }
    end

    context 'with author of question' do
      before { login(author) }

      context 'if not have best answer' do
        it 'mark best answer' do
          expect { mark_best_answer }.to change { answer1.reload.best }.from(false).to(true)
        end

        it "don't' mark other as best answer" do
          expect { mark_best_answer }.to_not change { answer2.reload.best }
        end
      end

      context 'if also have best answer' do
        let!(:answer1) { create(:answer, question: question_of_author) }
        let!(:answer2) { create(:answer, question: question_of_author, best: true) }

        it 'mark new best answer' do
          expect { mark_best_answer }.to change { answer1.reload.best }.from(false).to(true)
        end

        it 'unmark previous best answer' do
          expect { mark_best_answer }.to change { answer2.reload.best }.from(true).to(false)
        end
      end
    end

    context 'with not author of question' do
      before { login(not_author) }
      before { mark_best_answer }

      it "don't mark any as best answer" do
        expect(answer1.reload.best).to be false
        expect(answer2.reload.best).to be false
      end

      it "redirect to new user session path" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with unauthenticated user' do
      before { mark_best_answer }

      it "don't mark any as best answer" do
        mark_best_answer
        expect(answer1.reload.best).to be false
        expect(answer2.reload.best).to be false
      end

      it "responds with unauthorized status" do
        expect(response.status).to be 401
      end
    end
  end

  it_behaves_like 'voted'
  it_behaves_like 'commented'
end
