module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %w[like dislike reset_vote success_response_for_vote success_response_for_revote]
  end

  def like
    vote(1)
  end

  def dislike
    vote(-1)
  end

  def reset_vote
    @vote = @voteable.votes.find_by(user_id: current_user)

    response = nil
    status = nil

    if @vote&.destroy
      status = :ok
      response = success_response_for_revote
    else
      status = :unprocessable_entity
      response = {
        error: "Failed to reset vote for #{controller_name.singularize}"
      }
    end

    respond_to_json(response, status)
  end

  private

  def vote(value)
    @voteable.votes.new(user: current_user, value: value)

    response = nil
    status = nil

    if @voteable.save
      status = :ok
      response = success_response_for_vote(value)
    else
      status = :unprocessable_entity
      response = {
        error: "Error saving #{controller_name.singularize}"
      }
    end

    respond_to_json(response, status)
  end

  def respond_to_json(response, status)
    respond_to do |format|
      format.json do
        render json: response, status: status
      end
    end
  end

  def success_response_for_vote(value)
    liked = value > 0
    success_message = liked ? "You voted for the #{controller_name.singularize}" : "You voted down the #{controller_name.singularize}"

    {
      message: success_message,
      can_vote: false,
      can_revote: true,
      votes_sum: @voteable.votes_sum,
      liked: liked,
      btn_revote_link: polymorphic_url(@voteable, action: :reset_vote)
    }
  end

  def success_response_for_revote
    {
      message: "You reset vote for the #{controller_name.singularize}",
      can_vote: true,
      can_revote: false,
      votes_sum: @voteable.votes_sum,
      btn_like_link: polymorphic_url(@voteable, action: :like),
      btn_dislike_link: polymorphic_url(@voteable, action: :dislike)
    }
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
