# Preview all emails at http://localhost:3000/rails/mailers/notification
class NotificationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification/digest/notify_about_new_answer_for_question
  def notify_about_new_answer_for_question
    NotificationMailer.notify_about_new_answer_for_question(User.first, Question.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification/digest/notify_about_change_question
  def notify_about_change_question
    NotificationMailer.notify_about_new_answer_for_question(User.first, Question.first)
  end
end
