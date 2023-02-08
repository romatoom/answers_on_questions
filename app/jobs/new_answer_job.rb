class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(question)
    SubscriptionService.new.question_got_new_answer(question)
  end
end
