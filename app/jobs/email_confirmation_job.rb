class EmailConfirmationJob < ApplicationJob
  queue_as :default

  def perform(request_id)
    request = Request.find(request_id)
    RequestMailer.with(request: request).confirmation.deliver_now
  end
end
