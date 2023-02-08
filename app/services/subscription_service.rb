class SubscriptionService
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
