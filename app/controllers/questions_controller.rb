class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy update delete_file_attachments publish_question]
  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.order(:id)
    gon.current_user_id = current_user&.id
    gon.token = form_authenticity_token
  end

  def new
    @question = Question.new
    @question.links.new
    @question.reward = Reward.new
  end

  def show
    @answer = Answer.new
    @answer.links.new
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

    if current_user&.author_of?(@question)
      @question.update(question_params_without_files)
      @question.files.attach(params[:question][:files]) if params[:question][:files].present?
      delete_file_attachments(params[:question][:file_list_for_delete])
      @question.reload
    end
  end

  def destroy
    if current_user&.author_of?(@question)
      @question.destroy
      redirect_to questions_path, success: 'Question has been removed successfully.'
    end
  end

  private

  def question_params
    params.require(:question).permit(
      :title, :body,
      links_attributes: [:id, :name, :url, :_destroy],
      reward_attributes: [:id, :title, :image, :_destroy],
      files: []
    )
  end

  def question_params_without_files
    params.require(:question).permit(:title, :body, links_attributes: [:id, :name, :url, :_destroy])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def delete_file_attachments(str_with_files_ids)
    return if str_with_files_ids.blank?
    files_ids = str_with_files_ids.split(',').compact
    files_ids.each do |file_id|
      @question.files.find(file_id).purge
    end
  end

  def publish_question
    return if @question.errors.any?

    files = @question.files.map { |file| { filename: file.filename.to_s, url: url_for(file) } }
    links = @question.links.map { |link| { name: link.name, url: link.url } }

    ActionCable.server.broadcast('questions_channel', {
      question: @question.attributes.merge(files: files, links: links, url: url_for(@question))
    })
  end
end
