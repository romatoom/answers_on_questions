class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_channel_#{params[:question_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
