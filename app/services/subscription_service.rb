class SubscriptionService
  def create_subscription_for_user(user:, subscription_slug:, question:)
    return if user.subscription_by_slug(subscription_slug, question).present?

    subscription = Subscription.find_by(slug: subscription_slug)
    user.users_subscriptions.create!(subscription_id: subscription.id, question_id: question.id)
  end

  def remove_subscription_for_user(user:, subscription_slug:, question:)
    user_subscription = user.subscription_by_slug(subscription_slug, question)
    user_subscription.destroy!
  end

  def question_got_new_answer(question)
    subscription = Subscription.find_by(slug: "new_answer")
    users_subscription = UsersSubscription.where(subscription_id: subscription.id, question_id: question.id)

    users_subscription.find_each do |user_subscription|
      NotificationMailer.notify_about_new_answer_for_question(user_subscription.user, user_subscription.question).deliver_later
    end
  end
end
