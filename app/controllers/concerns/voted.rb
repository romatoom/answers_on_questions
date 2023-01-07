module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %w[like dislike reset_vote]
  end

  def like
    vote(1)
  end

  def dislike
    vote(-1)
  end

  def reset_vote
    if !current_user.can_revote?(@voteable)
      respond_to do |format|
        format.json do
          render json: {
            error: "You can not revote for #{controller_name.singularize}"
          }
        end
      end
      return
    end

    @vote = @voteable.votes.find_by(user_id: current_user)

    response = nil
    status = nil

    if @vote&.destroy
      status = :ok
      response = {
        message: "You reset vote for the #{controller_name.singularize}",
        can_vote: true,
        can_revote: false,
        votes_sum: @voteable.votes_sum,
        btn_like: {
          link: polymorphic_url(@voteable, action: :like)
        },
        btn_dislike: {
          link: polymorphic_url(@voteable, action: :dislike)
        }
      }
    else
      status = :unsupported_entity
      response = {
        error: "Failed to reset vote for #{controller_name.singularize}"
      }
    end

    respond_to do |format|
      format.json do
        render json: response, status: status
      end
    end
  end

  private

  def vote(value)
    if !current_user.can_vote?(@voteable)
      respond_to do |format|
        format.json do
          render json: {
            error: "You can not vote for #{controller_name.singularize}"
          }
        end
      end
      return
    end

    liked = value > 0
    success_message = liked ? "You voted for the #{controller_name.singularize}" : "You voted down the #{controller_name.singularize}"

    @voteable.votes.new(user: current_user, value: value)

    response = nil
    if @voteable.save
      response = {
        message: success_message,
        can_vote: false,
        can_revote: true,
        votes_sum: @voteable.votes_sum,
        liked: liked,
        btn_revote: {
          link: polymorphic_url(@voteable, action: :reset_vote)
        }
      }
    else
      response = {
        error: "Error saving #{controller_name.singularize}"
      }
    end

    respond_to do |format|
      format.json do
        render json: response
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def voteable_path
    send("#{controller_name.singularize}_path".to_sym, @voteable)
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
    instance_variable_set("@#{controller_name.singularize}", @voteable)
  end
end
