class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[new show]
  before_action :set_question
  before_action :set_answer, only: %i[show destroy]

  def show; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, success: 'Answer has been created successfully.'
    else
      render 'questions/show'
    end
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
