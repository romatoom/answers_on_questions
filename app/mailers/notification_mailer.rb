class NotificationMailer < ApplicationMailer
  def notify_about_new_answer_for_question(user, question)
    @question = question
    @new_answer = question.answers.last
    @user = user

    mail to: user.email, subject: 'New answer'
  end

  def notify_about_change_question(user, question)
    @question = question
    @user = user

    mail to: user.email, subject: 'Question changed'
  end
end
