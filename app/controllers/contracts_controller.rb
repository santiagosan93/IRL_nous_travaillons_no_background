class ContractsController < ApplicationController
  before_action :set_request

  def create
    @contract = Contract.new(expiery_date: Date.today.next_month)
    @contract.request = @request
    @contract.save
  end

  private

  def set_request
    @request = Request.find(params[:request_id])
  end
end
