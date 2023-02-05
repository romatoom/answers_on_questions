class UpdateQuestionJob < ApplicationJob
  queue_as :default

  def perform(question)
    SubscriptionService.new.question_has_been_changed(question)
  end
end
