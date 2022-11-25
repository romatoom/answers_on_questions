class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    @answer = Answer.new
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to question_path(@question), success: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, success: 'Question has been removed successfully.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
