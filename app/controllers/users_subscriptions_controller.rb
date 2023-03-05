class UsersSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    question = Question.find(params[:question_id])
    subscription = Subscription.find_by(slug: params[:subscription_slug])
    user_subscription = current_user&.subscription_by_slug(params[:subscription_slug], question) || UsersSubscription.new

    authorize! :create, user_subscription

    current_user.users_subscriptions.create!(subscription_id: subscription.id, question_id: question.id)

    redirect_to question_path(question), success: "You have subscribed to be '#{subscription.title}' subscription."
  end

  def destroy
    user_subscription = UsersSubscription.find(params[:id])
    authorize! :destroy, user_subscription

    user_subscription.destroy!

    redirect_to question_path(user_subscription.question), success: "You have unsubscribed to be '#{user_subscription.subscription.title}' subscription."
  end
end
