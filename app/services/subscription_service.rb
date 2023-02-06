class SubscriptionService
  def create_subscription_for_user(user:, subscription_slug:, question:)
    return if user.subscription_by_slug(subscription_slug, question).present?

    subscription = Subscription.find_by(slug: subscription_slug)
    user.users_subscriptions.create!(subscription_id: subscription.id, question_id: question.id)
  end

  def remove_subscription_for_user(user:, subscription_slug:, question:)
    user_subscription = user.subscription_by_slug(subscription_slug, question)
    user_subscription.destroy! if user_subscription.present?
  end

  def question_got_new_answer(question)
    send_notifies("new_answer", question, :notify_about_new_answer_for_question)
  end

  def question_has_been_changed(question)
    send_notifies("change_question", question, :notify_about_change_question)
  end

  private

  def send_notifies(subscription_slug, question, notification_mailer_method)
    subscription = Subscription.find_by(slug: subscription_slug)
    users_subscriptions = UsersSubscription.where(subscription_id: subscription.id, question_id: question.id)

    users_subscriptions.find_each do |user_subscription|
      NotificationMailer.send(notification_mailer_method, user_subscription.user, user_subscription.question).deliver_later
    end
  end
end
