class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments_channel"
  end
end
