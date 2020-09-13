class RenewContractJob < ApplicationJob
  queue_as :default

  def perform(contract_id)
    contract = Contract.find(contract_id)
    contract.unconfirm!
    contract.save
    ContractMailer.with(contract: contract).contract_renewal_confirmation.deliver_now
  end
end
