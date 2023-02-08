class UsersSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_question
  before_action :set_subscription
  before_action :set_user_subscription

  def subscribe
    authorize! :subscribe, @user_subscription

    current_user.users_subscriptions.create!(subscription_id: @subscription.id, question_id: @question.id)
    redirect_to question_path(@question), success: "You have subscribed to be '#{@subscription.title}' subscription."
  end

  def unsubscribe
    authorize! :unsubscribe, @user_subscription

    @user_subscription.destroy!
    redirect_to question_path(@question), success: "You have unsubscribed to be '#{@subscription.title}' subscription."
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_subscription
    @subscription = Subscription.find_by(slug: params[:subscription_slug])
  end

  def set_user_subscription
    @user_subscription = current_user&.subscription_by_slug(params[:subscription_slug], @question) || UsersSubscription.new
  end
end
