class SubscriptionService
  def create_subscription_for_user(user:, subscription_slug:, question:)
    subscription = Subscription.find_by(slug: subscription_slug)
    user.users_subscriptions.create!(subscription_id: subscription.id, question_id: question.id, active: true)
  end

  def remove_subscription_for_user(user:, subscription_slug:, question:)
    subscription = Subscription.find_by(slug: subscription_slug)
    user_subscription = user.users_subscriptions.where(subscription_id: subscription.id, question_id: question.id)
    user_subscription.destroy!
  end

  def question_got_new_answer(question)
    subscription = Subscription.find_by(slug: "new_answer")
    active_users_subscription = UsersSubscription.where(subscription_id: subscription.id, question_id: question.id, active: true)

    active_users_subscription.find_each do |user_subscription|
      NotificationMailer.notify_about_new_answer_for_question(user_subscription.user, user_subscription.question).deliver_later
    end
  end
end
