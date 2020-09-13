class ExpiredContractJob < ApplicationJob
  queue_as :default

  def perform(contract_id)
    contract = Contract.find(contract_id)
    contract.expire!
    contract.save

    request = contract.request
    request.remove_from_que!
    request.unaccept!
    request.unconfirm!
    request.expire!
    request.save
    ContractMailer.with(contract: contract).contract_expired.deliver_now
    # I don't know yet how to chain background jobs, so the closest I could come up
    # with was to have this happening inside the job. The problem is thant this is inside
    # of an iteration, and im sure there is a cleaner way of writing this.
    Request.calculate_que_number
  end
end
