class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    DailyDigestService.new.send_digests
  end
end
