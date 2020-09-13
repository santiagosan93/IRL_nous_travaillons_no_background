class ContractsController < ApplicationController
  before_action :set_request, only: :create
  before_action :set_contract, only: :renewal_confirmation
  def create
    @contract = Contract.new(expiery_date: Date.today.next_month)
    @contract.request = @request
    @contract.save!

    @request.accept!
    @request.save
  end

  def renewal_confirmation
    @new_contract = @contract.provisional
    @contract.confirm!
    @contract.renew_expiery_date!
    @contract.save
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def set_request
    @request = Request.find(params[:request_id])
  end
end
