module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commenteable, only: %w[add_comment publish_comment]
    after_action :publish_comment, only: %w[add_comment]
  end

  def add_comment
    @comment = @commenteable.comments.new(comment_params.merge(author: current_user))

    response = nil
    status = nil

    if @commenteable.save
      status = :ok
      response = success_response_for_comment(@comment)
    else
      status = :unprocessable_entity
      response = {
        errors: {
          count: @comment.errors.count,
          full_messages: @comment.errors.full_messages
        },
        error_alert: "Error add comment for #{controller_name.singularize}"
      }
    end

    respond_to_json(response, status)
  end

  private

  def comment_params
    params.permit(:body)
  end

  def respond_to_json(response, status)
    respond_to do |format|
      format.json do
        render json: response, status: status
      end
    end
  end

  def success_response_for_comment(comment)
    {
      message: 'Comment has been added successfully',
      comment: {
        body: comment.body,
        author_email: comment.author.email,
        created_date: comment.formatted_creation_date
      }
    }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def commented_path
    send("#{controller_name.singularize}_path".to_sym, @commenteable)
  end

  def set_commenteable
    @commenteable = model_klass.find(params[:id])
    instance_variable_set("@#{controller_name.singularize}", @commenteable)
  end

  def publish_comment
    @comment.valid?
    return if @comment.errors.any?

    ActionCable.server.broadcast("comments_channel", {
      comment: {
        body: @comment.body,
        author_email: @comment.author.email,
        created_date: @comment.formatted_creation_date,
        commenteable_type: @comment.commenteable_type,
        commenteable_id: @comment.commenteable_id
      },
      sid: session.id.public_id
    })
  end
end
