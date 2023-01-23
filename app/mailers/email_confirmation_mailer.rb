class EmailConfirmationMailer < ApplicationMailer
  def email_confirmation(confirmed_email)
    @confirmed_email = confirmed_email
    mail to: @confirmed_email.email, subject: 'Confirm your email'
  end
end
