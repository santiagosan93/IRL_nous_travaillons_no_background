class RenewRequestJob < ApplicationJob
  queue_as :default

  def perform(request_id)
    # Do something later
    request = Request.find(request_id)
    request.confirmed = false
    request.save
    RequestMailer.with(request: request).request_renewal_confirmation.deliver_now
  end
end
