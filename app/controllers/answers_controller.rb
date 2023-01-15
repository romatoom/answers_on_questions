class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[new create show update]
  before_action :set_question, only: %i[create publish_answer]
  before_action :set_answer, only: %i[show update destroy mark_answer_as_best publish_answer]
  after_action :publish_answer, only: %i[create]

  def show; end

  def create
    redirect_to new_user_session_path, alert: t('devise.failure.unauthenticated') unless user_signed_in?
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def update
    redirect_to new_user_session_path, alert: t('devise.failure.unauthenticated') unless user_signed_in?

    if current_user&.author_of?(@answer)
      @answer.update(answer_params_without_files)
      @answer.files.attach(params[:answer][:files]) if params[:answer][:files].present?
      delete_file_attachments(params[:answer][:file_list_for_delete])
      @answer.reload
    end
  end

  def destroy
    @answer.destroy if current_user&.author_of?(@answer)
  end

  def mark_answer_as_best
    return head :forbidden if !current_user.author_of?(@answer.question)

    @top_answer = @answer.question.answers.sort_by_best.first
    @best_answer = @top_answer&.best ? @top_answer : nil

    @answer.mark_as_best

    @best_answer.reload if @best_answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :best, links_attributes: [:id, :name, :url, :_destroy], files: [])
  end

  def answer_params_without_files
    params.require(:answer).permit(:body, :best, links_attributes: [:id, :name, :url, :_destroy])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def delete_file_attachments(str_with_files_ids)
    return if str_with_files_ids.blank?
    files_ids = str_with_files_ids.split(',').compact
    files_ids.each do |file_id|
      @answer.files.find(file_id).purge
    end
  end

  def publish_answer
    return if @answer.errors.any?

    files = @answer.files.map { |file| { filename: file.filename.to_s, url: url_for(file) } }
    links = @answer.links.map { |link| { name: link.name, url: link.url } }
    votes = {
      sum: @answer.votes_sum,
      like_url: polymorphic_url(@answer, action: :like),
      dislike_url: polymorphic_url(@answer, action: :dislike)
    }

    ActionCable.server.broadcast("question_channel_#{@question.id}", {
      answer: @answer.attributes.merge(files:, links:, votes:),
      sid: session.id.public_id
    })
  end
end
