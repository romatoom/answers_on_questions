class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[new create show update]
  before_action :set_question
  before_action :set_answer, only: %i[show update destroy]

  def show; end

  def create
    redirect_to new_user_session_path, alert: t('devise.failure.unauthenticated') unless user_signed_in?

    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def update
    redirect_to new_user_session_path, alert: t('devise.failure.unauthenticated') unless user_signed_in?

    @answer.update(answer_params) if current_user == @answer.author
  end

  def destroy
    @answer.destroy if current_user == @answer.author
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
