class ApplicationMailer < ActionMailer::Base
  default from: %{"Answers on Questions" <answer-on-questions@example.com>}
  layout 'mailer'
end
