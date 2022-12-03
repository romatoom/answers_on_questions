class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy update]

  def index
    @questions = Question.order(:id)
  end

  def new
    @question = Question.new
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.sort_by_best
  end

  def create
    @question = Question.new(question_params.merge(author: current_user))

    if @question.save
      redirect_to question_path(@question), success: 'Question has been created successfully.'
    else
      render :new
    end
  end

  def update
    redirect_to new_user_session_path, alert: t('devise.failure.unauthenticated') unless user_signed_in?

    @question.update(question_params) if current_user == @question.author
  end

  def destroy
    if current_user == @question.author
      @question.destroy
      redirect_to questions_path, success: 'Question has been removed successfully.'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
