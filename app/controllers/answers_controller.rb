class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[new create show]
  before_action :set_question
  before_action :set_answer, only: %i[show destroy]

  def show; end

  def create
    if current_user.nil?
      redirect_to new_user_session_path, alert: t('devise.failure.unauthenticated')
    end

    @answer = @question.answers.new(answer_params.merge(author: current_user))

    flash.now[:success] = 'Answer has been created successfully.' if @answer.save
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@question), success: 'Answer has been removed successfully.'
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
