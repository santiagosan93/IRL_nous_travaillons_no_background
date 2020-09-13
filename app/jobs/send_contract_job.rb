class SendContractJob < ApplicationJob
  queue_as :default

  def perform(request_id)
    # Do something later
    # Do something later
    request = Request.find(request_id)
    RequestMailer.with(request: request).send_contract.deliver_now
  end
end
