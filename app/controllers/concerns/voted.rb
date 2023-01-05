module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %w[like dislike]
  end

  def like
    vote(1)
  end

  def dislike
    vote(-1)
  end

  private

  def vote(value)
    success_message = value > 0 ? "You voted for the #{controller_name.singularize}" : "You voted down the #{controller_name.singularize}"

    @voteable.votes.new(user: current_user, value: value)

    response = nil
    if @voteable.save
      response = {
        message: success_message
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
